//
//  MSMessageObserver.swift
//  Mesence
//
//  Created by 罗志华 on 2023/7/30.
//

import Foundation

protocol MSMessageObserver: AnyObject {
    /*
     When IM receives message sending from server, it converts the message content which is PB to Json
     So when obsevers reveive the parsed content, they can use it right away.
     */
    var observerID: String { get }
    
    // MARK: ------- Websocket Event --------
    func onConnected()
    func onDisConnected()
    func reConnectCountIsOnTop()
    
    // MARK: ------- Message Event --------
    // Oridinary Message
    func receiveMessage(_ msg: Msg)
    // Fridens onLine
    func receiveFriendsInline(_ msg: Msg)
    // Fridens offline
    func receiveFriendsOffline(_ msg: Msg)
    // Fridens request
    func receiveFriensRequest(_ msg: Msg)
    // Error message
    func reveiceErrorMessage(error: Error?)
}

extension MSMessageObserver {
    var observerID: String {
        return UUID().uuidString
    }
}
