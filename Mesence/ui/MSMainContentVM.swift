//
//  MSMainContentVM.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/31.
//

import Foundation

class MSMainContentVM {
    static let MSMessageListChanceNofiName = Notification.Name("MSMessageListChangeNotiKey")
    private var msgList: [Msg] = [Msg]()
    private let tag = "MSMainContentVM"
    private var currentFriend: String = ""
    
    init() {
        MSMessageClient.shared.registerObserver(self)
        MSMessageClient.shared.connect()

    }
    
    // MARK: - private Methods
    private func fetchHistory() {
        let endDate = MSTimeTools.generateRFC3339String(Date())
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = -2
        let startDate = MSTimeTools.generateRFC3339String(calendar.date(byAdding: dateComponents, to: Date()) ?? Date())
        MSCommunicationRepo.getHistory(anotherUser: currentFriend, page: 0, limit: 20, startTime: startDate, endTime: endDate) { history,success in
            if let list = history?.Data.List {
                for singleMsg in list {
                    let dataMsg = DataMessage(toUser: MSLoginManager.shared.userID, fromUser: singleMsg.From ?? "", dataContent: singleMsg.Content ?? "", sendMsgTime: singleMsg.SendTime ?? "")
                    let msg = Msg(type: .word, data: dataMsg)
                    self.msgList.append(msg)
                }
                NotificationCenter.default.post(Notification(name: MSMainContentVM.MSMessageListChanceNofiName))
            }
        }
    }

    // MARK: - Public Methods
    func checkOutDialog(newUser: String) {
        if newUser.isEmpty { return }
        self.currentFriend = newUser
        self.msgList.removeAll()
        self.fetchHistory()
    }
    
    func sendMessage(_ text: String) {
        MSMessageClient.shared.sendMessage(fromUser: MSLoginManager.shared.userID , toUser: currentFriend, dataContent: text) { [weak self] msg, success in
            if success {
                self?.msgList.append(msg)
                NotificationCenter.default.post(Notification(name: MSMainContentVM.MSMessageListChanceNofiName))
            }
            MSLog.logI(tag: self?.tag ?? " ", log: "Send Message \(success)")
        }
    }
}

extension MSMainContentVM: MSMessageObserver {
    func onConnected() {
        
    }
    
    func onDisConnected() {
        
    }
    
    func reConnectCountIsOnTop() {
        
    }
    
    func receiveMessage(_ msg: Msg) {
        self.msgList.append(msg)
        NotificationCenter.default.post(Notification(name: MSMainContentVM.MSMessageListChanceNofiName))
    }
    
    func receiveFriendsInline(_ msg: Msg) {
        
    }
    
    func receiveFriendsOffline(_ msg: Msg) {
        
    }
    
    func receiveFriensRequest(_ msg: Msg) {
        
    }
    
    func reveiceErrorMessage(error: Error?) {
        
    }
    
    
}
