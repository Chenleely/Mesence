//
//  MSBaseResponse.swift
//  Mesence
//
//  Created by 罗志华 on 2023/8/1.
//

import Foundation

// MARK: - Login
struct MSLoginResponse: Codable {
    var Status: String
    var Time: String
    var Data: LoginDataStruct
}

struct LoginDataStruct: Codable {
    var Token: String?
    var Message: String?
}

// MARK: - HistoryRecord
struct MSHistoryRecordResponse: Codable {
    var Status: String
    var Time: String
    var Data: HistoryRecordListStruct
}

struct HistoryRecordDataStruct: Codable {
    var ID: Int?
    var From: String?
    var SendTime: String?
    var Content: String?
}

struct HistoryRecordListStruct: Codable {
    var List: [HistoryRecordDataStruct]?
}

// MARK: - User Info
struct MSUserInfoResponse: Codable {
    var Status: String
    var Time: String
    var Data: UserInfoStruct
}

struct UserInfoStruct: Codable {
    var Id: Int?
    var Name: String?
    var Phone: String?
    var Avatar: String?
    var Location: String?
}

// MARK: - Friends List
struct MSFriendListResponse: Codable {
    var Status: String
    var Time: String
    var Data: FriendDataListStruct
}

struct FriendDataListStruct: Codable {
    var List: [FriendDataStruct]?
}

struct FriendDataStruct: Codable {
    var FriendNoteName: String?
    var Friend: UserInfoStruct?
}

// MARK: - Friends Apply
struct MSFriendApplyListResponse: Codable {
    var Status: String
    var Time: String
    var Data: FriendApplyDataListStruct
}

struct FriendApplyDataListStruct: Codable {
    var List: [FriendApplyDataStruct]?
}

struct FriendApplyDataStruct: Codable {
    var Id: Int?
    var Sender: String?
    var Content: String?
    var Candidate: String?
    var StartTime: String?
    var RequestStatus: String?
}

// MARK: - Friend Apply Response
struct MSFriendApplyAuthReponse: Codable {
    var Status: String?
    var Time: String?
}



