//
//  MSNetworkRequest.swift
//  Mesence
//
//  Created by 罗志华 on 2023/8/1.
//

import Foundation

// MARK: - Login
struct MSLoginRequest: Codable {
    var Phone: String
    var Password: String
}

// MARK: - User Info
struct MSUserInfoRequest: Codable {
    var Action: String = "GetUserInfo"
    var Version: String = "20220101"
}

// MARK: - HistoryRecord
struct MSHistoryRecordRequest: Codable {
    var Action: String = "ListMessageRecord"
    var Version: String = "20220101"
    var Limit: Int
    var Offset: Int
    var AnotherUser: String
    var StartTime: String
    var EndTime: String
}

// MARK: - Friend Apply
struct MSFriendApplyRequest: Codable {
    var Action: String = "ListMessageRecord"
    var Version: String = "20220101"
    var Limit: Int?
    var Offset: Int?
    var `Type`: Int?
}

// MARK: - Friend List
struct MSFriendListRequest: Codable {
    var Action: String = "ListFriend"
    var Version: String = "20220101"
}
