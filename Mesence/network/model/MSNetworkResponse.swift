//
//  MSBaseResponse.swift
//  Mesence
//
//  Created by 罗志华 on 2023/8/1.
//

import Foundation

// MARK: - Login
struct MSLoginResponse: Codable {
    struct LoginDataStruct: Codable {
        var Token: String?
        var Message: String?
    }
    var Status: String
    var Time: String
    var Data: LoginDataStruct
}

// MARK: - HistoryRecord
struct MSHistoryRecordResponse: Codable {
    struct HistoryRecordDataStruct: Codable {
        var ID: Int?
        var From: String?
        var SendTime: String?
        var Content: String?
    }
    struct HistoryRecordListStruct: Codable {
        var List: [HistoryRecordDataStruct]?
    }
    var Status: String
    var Time: String
    var Data: HistoryRecordListStruct
}


