//
//  MSMainContentVM.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/31.
//

import Foundation

class MSMainContentVM {
    static let MSMessageListChanceNofiName = Notification.Name("MSMessageListChangeNotiKey")
    private let tag = "MSMainContentVM"
    var msgList: [Msg] = [Msg]()
    
    init() {}

    func getMsgList() {
        NotificationCenter.default.post(Notification(name: MSMainContentVM.MSMessageListChanceNofiName))
    }
    
    func sendMessage(_ text: String) {
        let from = MSLoginManager.shared.userID
        let to = from == "test" ? "b" : "test"
        
        MSMessageClient.shared.sendMessage(fromUser: from , toUser: to, dataContent: text) { [weak self] msg, success in
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
