//
//  MSMessageClient.swift
//  Mesence
//
//  Created by 罗志华 on 2023/7/30.
//

import Foundation
 
typealias WriteDataCompletion = (Msg, Bool) -> ()
typealias NotifyObserverExcution = (MSMessageObserver) -> ()

// MARK: - ------- MSMessageClient --------
class MSMessageClient: NSObject {
    // MARK: - Public Property
    static let shared: MSMessageClient = {
        return MSMessageClient()
    }()
    
    // MARK: - Private Property
    private var socketURL = "ws://louis296.top:9010/ws?Token="
    private static let maxReconnectCount = 10
    
    private var timer: Timer?
    private var reconnectCount = 0
    private let logTag = "MSMessageClient"
    private var isConnected: Bool = false
    private var qosMessageSet: Set<Msg> = Set<Msg>()
    private let mutex: DispatchSemaphore = DispatchSemaphore(value: 1)
    private var observersMap: [String : MSMessageObserver?] = [String : MSMessageObserver?]()
    private lazy var session: URLSession = {
        return URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }()
    private lazy var websocket: URLSessionWebSocketTask = {
        let socket = session.webSocketTask(with: URL(string: self.socketURL)!)
        socket.delegate = self
        return socket
    }()
    
    // MARK: - Private Method
    private override init() {
        super.init()
    }
    
    private func reSendQosMessages() {
        if qosMessageSet.isEmpty || !isConnected { return }
        for msg in qosMessageSet {
            self.sendMessage(message: msg) { [self] msg, success in
                MSLog.logI(tag: logTag, log: "try to reSendMessages")
            }
        }
    }
    
    deinit {
        websocket.cancel()
        timer?.invalidate()
        timer = nil
        session.invalidateAndCancel()
    }
    
    @inline(__always) private func generateCurrentTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.string(from: Date())
    }

    private func receiveMessage(result: Result<URLSessionWebSocketTask.Message, Error>) {
        switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print(text)
                case .data(let data):
                    self.handleByteMessage(data)
                @unknown default:
                    print("unknown")
                }
            websocket.receive(completionHandler: self.receiveMessage)
            case .failure(let error):
                print(error)
        }
    }
    
    private func broadCast(_ excution: @escaping NotifyObserverExcution) {
        for (_, value) in observersMap {
            if let observer = value {
                DispatchQueue.main.async {
                    excution(observer)
                }
            }
        }
    }
    
    private func handleByteMessage(_ data: Data) {
        MSLog.logI(tag: logTag, log: "Received data: \(data.count)")
        do {
            let pbMSG = try Msg(serializedData: data)
            switch pbMSG.type {
            case .word:
                MSLog.logI(tag: logTag, log: "receive word")
                broadCast { observer in
                    observer.receiveMessage(pbMSG)
                }
            case .online:
                MSLog.logI(tag: logTag, log: "receive online")
                broadCast { observer in
                    observer.receiveFriendsInline(pbMSG)
                }
            case .offline:
                MSLog.logI(tag: logTag, log: "receive offline")
                broadCast { observer in
                    observer.receiveFriendsOffline(pbMSG)
                }
            case .friendRequest:
                MSLog.logI(tag: logTag, log: "receive friendRequest")
                broadCast { observer in
                    observer.receiveFriensRequest(pbMSG)
                }
            case .heartPackage:
                MSLog.logI(tag: logTag, log: "receive heartPackage")
            case.answer:
                MSLog.logI(tag: logTag, log: "receive answer")
            case .offer:
                MSLog.logI(tag: logTag, log: "receive offer")
            case .candidate:
                MSLog.logI(tag: logTag, log: "receive candidate")
            case .UNRECOGNIZED(_):
                MSLog.logE(tag: logTag, log: "unrecognized message")
            }
        } catch(let error) {
            print(error)
        }
    }
    
    @objc func tryReconnect() {
        MSLog.logI(tag: logTag, log: "tryReconnect")
        if isConnected {
            timer?.invalidate()
            timer = nil
            return
        }
        reconnectCount += 1
        if reconnectCount > MSMessageClient.maxReconnectCount {
            timer?.invalidate()
            timer = nil
            broadCast { observer in
                observer.reConnectCountIsOnTop()
            }
            MSLog.logI(tag: logTag, log: "tryReconnect is out of limitation")
            return
        }
        self.connect()
    }
    
    // MARK: Public Method
    public func sendMessage(fromUser from: String, toUser to: String, dataContent content: String, withCompletion completion: @escaping WriteDataCompletion) {
        let dataModel = DataMessage(toUser: to, fromUser: from, dataContent: content, sendMsgTime: self.generateCurrentTimestamp())
        let msg = Msg(type: .word, data: dataModel)
        self.sendMessage(message: msg, withCompletion: completion)
    }
    
    public func sendMessage(message msg: Msg, withCompletion completion: @escaping WriteDataCompletion) {
        if !isConnected {
            qosMessageSet.insert(msg)
            completion(msg, false)
            return
        }
        
        if qosMessageSet.contains(msg) {
            qosMessageSet.remove(msg)
        }
            
        do {
            let data = try msg.serializedData()
            websocket.send(.data(data)) { error in
                DispatchQueue.main.async {
                    completion(msg, error == nil)
                }
            }
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
    
    public func connect() {
        websocket.resume()
    }
    
    public func disConnect() {
        websocket.cancel()
    }
    
    public func configURLAfterLogin() {
        let token = MSLoginManager.shared.token
        if !token.isEmpty {
            socketURL += token
        }
    }
}

extension MSMessageClient: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        isConnected = true
        MSLog.logI(tag: logTag, log: "onConnected")
        broadCast { observer in
            observer.onConnected()
        }
        webSocketTask.receive { [weak self] (result) in
            if let strongSelf = self {
                switch result {
                    case .success(let message):
                        switch message {
                        case .string(let text):
                            print(text)
                        case .data(let data):
                            strongSelf.handleByteMessage(data)
                        @unknown default:
                            print("unknown")
                        }
                    self?.websocket.receive(completionHandler: strongSelf.receiveMessage)
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isConnected = false
        MSLog.logI(tag: logTag, log: "onDisConnected")
        broadCast { observer in
            observer.onDisConnected()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tryReconnect), userInfo: nil, repeats: true)
        timer?.fire()
    }
}

extension MSMessageClient :URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
    }
}

