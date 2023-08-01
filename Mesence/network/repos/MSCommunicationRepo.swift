//
//  MSCommunicationRepo.swift
//  Mesence
//
//  Created by 罗志华 on 2023/8/1.
//

import Foundation
import Alamofire

class MSCommunicationRepo {
    private static let baseURL = "http://louis296.top:9010"
    private static let getAllHistoryURL = baseURL + "/v1"
    
    class func getHistory(anotherUser: String, page: Int, limit: Int, startTime: String, endTime: String, completion: @escaping (MSHistoryRecordResponse?, Bool) -> Void) {
        let param = MSHistoryRecordRequest(Limit: limit, Offset: page, AnotherUser: anotherUser, StartTime: startTime, EndTime: endTime)
        do {
            try MSLoginManager.shared.sharedSession?.request(getAllHistoryURL.asURL(),
                            method: .get,
                            parameters: param,
                            encoder: URLEncodedFormParameterEncoder.default).responseDecodable(of:MSHistoryRecordResponse.self) { response in
                switch response.result {
                case.failure(let error):
                    completion(nil, false)
                    print(error)
                case .success(let result):
                    completion(result, true)
                }
            }
        } catch (let error) {
            print(error)
        }
    }
}
