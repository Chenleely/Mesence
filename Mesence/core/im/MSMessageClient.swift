//
//  MSMessageClient.swift
//  Mesence
//
//  Created by 罗志华 on 2023/7/30.
//

import Foundation
import Starscream
 
typealias WriteDataCompletion = () -> ()
typealias NotifyObserverExcution = (MSMessageObserver) -> ()

// MARK: - ------- MSMessageClient --------
class MSMessageClient {
    
    // MARK: - Public Property
    static let shared: MSMessageClient = {
        return MSMessageClient()
    }()
    
    // MARK: - Private Property
    private static let socketURL = "ws://louis296.top:9010/ws"
    private static let maxReconnectCount = 10
    
    private var timer: Timer?
    private var reconnectCount = 0
    private var isConnected: Bool = false
    private var qosMessageSet: Set<Msg> = Set<Msg>()
    private let mutex: DispatchSemaphore = DispatchSemaphore(value: 1)
    private var observersMap: [String : MSMessageObserver?] = [String : MSMessageObserver?]()
    private let websocket: WebSocket = {
        let request = URLRequest(url: URL(string: MSMessageClient.socketURL)!)
        let socket = WebSocket(request: request)
        return socket
    }()
    
    // MARK: - Private Method
    private init() {
        self.connect()
    }
    
    private func connect() {
        websocket.connect()
    }
    
    private func disConnect() {
        websocket.connect()
    }
    
    private func reSendQosMessages() {
        if qosMessageSet.isEmpty { return }
        if !isConnected { return }
        for msg in qosMessageSet {
            self.sendMessage(message: msg) {
                print("try to reSendMessages")
            }
        }
    }
    
    deinit {
        websocket.forceDisconnect()
        timer?.invalidate()
        timer = nil
    }
    
    @inline(__always) private func generateCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    @objc func tryReconnect() {
        if isConnected {
            timer?.invalidate()
            timer = nil
            return
        }
        if reconnectCount > MSMessageClient.maxReconnectCount {
            timer?.invalidate()
            timer = nil
            broadCast { observer in
                observer.reConnectCountIsOnTop()
            }
            return
        }
        self.connect()
    }
    
    // MARK: Public Method
    public func sendMessage(fromUser from: String, toUser to: String, dataContent content: String, withCompletion completion: @escaping WriteDataCompletion) {
        let dataModel = DataMessage(toUser: from, fromUser: to, dataContent: content, sendMsgTime: self.generateCurrentTimestamp())
        let msg = Msg(type: .word, data: dataModel)
        self.sendMessage(message: msg, withCompletion: completion)
    }
    
    public func sendMessage(message msg: Msg, withCompletion completion: @escaping WriteDataCompletion) {
        if !isConnected {
            qosMessageSet.insert(msg)
            return
        }
        
        if qosMessageSet.contains(msg) {
            qosMessageSet.remove(msg)
        }
            
        do {
            let data = try msg.serializedData()
            websocket.write(data: data, completion: completion)
        } catch(let error) {
            print(error)
        }
    }
    
    public func registerObserver(_ observer: MSMessageObserver) {
        mutex.wait()
        observersMap[observer.observerID] = observer
        mutex.signal()
    }
    
    public func removeObserver(_ observer: MSMessageObserver) {
        mutex.wait()
        if let existObserver = observersMap[observer.observerID], existObserver != nil {
            observersMap.removeValue(forKey: observer.observerID)
        }
        mutex.signal()
    }
    
    public func reconnect() {
        if isConnected { return }
    }
}

// MARK: - ------- MSMessageClient<WebSocketDelegate> --------
extension MSMessageClient: WebSocketDelegate {
    
    // MARK: - WebSocketDelegate
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("websocket is connected: \(headers)")
            handleConnectMessage()
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
            handleDisonnectMessage()
        case .text(let string):
            handleStringMessage(string)
        case .binary(let data):
            handleByteMessage(data)
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            handleCancelMessage()
        case .error(let error):
            handleErrorMessage(error)
        }
    }
    
    // MARK: - Notify Observers
    private func broadCast(_ excution: @escaping NotifyObserverExcution) {
        for (_, value) in observersMap {
            if let observer = value {
                excution(observer)
            }
        }
    }
    
    private func handleByteMessage(_ data: Data) {
        print("Received data: \(data.count)")
        do {
            let pbMSG = try Msg(serializedData: data)
            switch pbMSG.type {
            case .word:
                broadCast { observer in
                    observer.receiveMessage(pbMSG)
                    print("receive word")
                }
            case .online:
                broadCast { observer in
                    observer.receiveFriendsInline(pbMSG)
                    print("receive online")
                }
            case .offline:
                broadCast { observer in
                    observer.receiveFriendsOffline(pbMSG)
                    print("receive offline")
                }
            case .friendRequest:
                broadCast { observer in
                    observer.receiveFriensRequest(pbMSG)
                    print("receive friendRequest")
                }
            case .heartPackage:
                print("receive heartPackage")
            case.answer:
                print("receive answer")
            case .offer:
                print("receive offer")
            case .candidate:
                print("receive candidate")
            case .UNRECOGNIZED(_):
                print("unrecognized message")
            }
        } catch(let error) {
            print(error)
        }
    }
    
    private func handleStringMessage(_ string: String) {
        print("Received text: \(string)")
    }
    
    private func handleConnectMessage() {
        isConnected = true
        broadCast { observer in
            observer.onConnected()
        }
        self.reSendQosMessages()
    }
    
    private func handleDisonnectMessage() {
        isConnected = false
        broadCast { observer in
            observer.onDisConnected()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tryReconnect), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    private func handleCancelMessage() {
        isConnected = false
        broadCast { observer in
            observer.onDisConnected()
        }
    }
    
    private func handleErrorMessage(_ error: Error?) {
        isConnected = false
        broadCast { observer in
            observer.reveiceErrorMessage(error: error)
        }
    }
}

