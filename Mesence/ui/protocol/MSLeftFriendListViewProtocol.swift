//
//  MSLeftFriendListViewProtocol.swift
//  Mesence
//
//  Created by 罗志华 on 2023/8/2.
//

import Foundation

protocol MSLeftFriendListViewDelegate: AnyObject {
    func didClickItem(atIndex: Int)
    func didClickAddNewUser()
}

protocol MSLeftFriendListViewDataSource: AnyObject {
    var friendList: [FriendDataStruct]? { get }
}
