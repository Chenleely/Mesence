//
//  MSMainContentVM.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/31.
//

import Foundation

class MSMainContentVM {
    var msgList: [Msg] = [Msg]()
    var vc: MSMainViewController
    var friendsList: [FriendDataStruct]? = nil
    var currentUser: UserInfoStruct? = nil
    static let MSMessageListChanceNofiName = Notification.Name("MSMessageListChangeNotiKey")
    private let tag = "MSMainContentVM"
    private var currentFriend: String = ""
    
    init(vc: MSMainViewController) {
        self.vc = vc
        MSMessageClient.shared.registerObserver(self)
        MSMessageClient.shared.connect()
        self.fetchFriendList()
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
                self.vc.reloadMainView()
            }
        }
    }
    
    private func fetchFriendList() {
        MSCommunicationRepo.getFriendList { res, success in
            self.friendsList = res?.Data.List ?? [FriendDataStruct]()
            self.friendsList?.append(FriendDataStruct(FriendNoteName: "我", Friend: UserInfoStruct(Name: MSLoginManager.shared.userID)))
            self.vc.reloadFriendsListView()
            if self.currentUser == nil {
                self.currentUser = self.friendsList?.first?.Friend
                self.vc.checkoutCurrentUser()
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
        MSMessageClient.shared.sendMessage(fromUser: MSLoginManager.shared.userID , toUser: currentUser?.Name ?? "MSLoginManager.shared.userID", dataContent: text) { [weak self] msg, success in
            if success {
                self?.msgList.append(msg)
                NotificationCenter.default.post(Notification(name: MSMainContentVM.MSMessageListChanceNofiName))
            }
            MSLog.logI(tag: self?.tag ?? " ", log: "Send Message \(success)")
        }
    }
    
    func checkoutCurrentUser(_ user: UserInfoStruct?) {
        self.currentUser = user
        self.fetchHistory()
    }
    
    func responseToFriendRequest(msg: Msg) {
        MSMessageClient.shared.sendMessage(message: msg) { [weak self] msg, success in
            MSLog.logI(tag: self?.tag ?? " ", log: "responseToFriendRequest \(success)")
        }
        MSCommunicationRepo.responseToFriendApplyList(id: msg.data.from, accept: msg.data.requestStatus == .accepted) { [weak self] res, success in
            self?.fetchFriendList()
        }
    }
    
    func requestAdddNewuser(to: String) {
        var msgData = DataMessage(toUser: to, fromUser:MSLoginManager.shared.userID , dataContent: "add new user", sendMsgTime: MSTimeTools.generateRFC3339String(Date()))
        msgData.setRequestStatus(status: .waiting)
        let msg = Msg(type: .friendRequest, data: msgData)
        MSMessageClient.shared.sendMessage(message: msg) { msg, success in
            print("\(msg)  \(success)")
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
        vc.reloadMainView()
    }
    
    func receiveFriendsInline(_ msg: Msg) {
        
    }
    
    func receiveFriendsOffline(_ msg: Msg) {
        
    }
    
    func receiveFriensRequest(_ msg: Msg) {
        switch msg.data.requestStatus {
        case .accepted:
            self.vc.receiveOldFriendRequst(msg: msg)
        case .refused:
            self.vc.receiveOldFriendRequst(msg: msg)
        case .waiting:
            self.vc.receiveNewFriendRequst(msg: msg)
        case .UNRECOGNIZED(_):
            MSLog.logE(tag: tag, log: "UNRECOGNIZED")
        }
    }
    
    func reveiceErrorMessage(error: Error?) {
        
    }
    
    
}
