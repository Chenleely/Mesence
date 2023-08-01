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
