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
    private static let requestURL = baseURL + "/v1"
    
    // 历史消息列表
    class func getHistory(anotherUser: String, page: Int, limit: Int, startTime: String, endTime: String, completion: @escaping (MSHistoryRecordResponse?, Bool) -> Void) {
        self.GET(url: requestURL,
                 params: MSHistoryRecordRequest(Limit: limit, Offset: page, AnotherUser: anotherUser, StartTime: startTime, EndTime: endTime)) { res, success in
            completion(res, success)
        }
    }
    
    // 好友列表
    class func getFriendList(completion: @escaping (MSFriendListResponse?, Bool) -> Void) {
        self.GET(url: requestURL, params: MSFriendListRequest()) { res, success in
            completion(res, success)
        }
    }
    
    // 用户个人信息
    class func getUserInfo(completion: @escaping (MSUserInfoResponse?, Bool) -> Void) {
        self.GET(url: requestURL,
                 params: MSUserInfoRequest()) { res, success in
            completion(res, success)
        }
    }
    
    // 获取我发起的好友请求
    class func getSendedFriendApplyList(limit: Int, offset: Int ,completion: @escaping (MSFriendApplyListResponse?, Bool) -> Void) {
        self.GET(url: requestURL,
                 params: MSFriendApplyRequest(Limit: limit, Offset: offset, Type: 0)) { res, success in
            completion(res, success)
        }
    }
    
    // 获取我收到的好友请求
    class func getReceivedFriendApplyList(limit: Int, offset: Int ,completion: @escaping (MSFriendApplyListResponse?, Bool) -> Void) {
        self.GET(url: requestURL,
                 params: MSFriendApplyRequest(Limit: limit, Offset: offset, Type: 1)) { res, success in
            completion(res, success)
        }
    }
    
    // 回应别人发起的好友请求
    class func responseToFriendApplyList(id: String, accept: Bool, completion: @escaping (MSFriendApplyAuthReponse?, Bool) -> Void) {
        self.POST(url: requestURL,
                  params: MSFriendApplyAuthRequestBody(Id: id, Type: accept ? 1 : 0),
                  headers: MSFriendApplyAuthRequestParam(),
                  encoder: JSONParameterEncoder.default, responseType: MSFriendApplyAuthReponse.self) { res, success in
            completion(res, success)
        }
    }
    
    private class func GET<Response: Decodable, Param: Encodable>(url: String,
                                                                  params:Param? = nil,
                                                                  responseType: Response.Type = Response.self,
                                                                  completion: @escaping (Response?, Bool) -> Void) {
        do {
            try MSLoginManager.shared.sharedSession?.request(url.asURL(),
                                                             method: .get,
                                                             parameters: params,
                                                             encoder: URLEncodedFormParameterEncoder.default).responseDecodable(of: Response.self) { response in
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
            completion(nil, false)
        }
    }
    
    private class func GET<Response: Decodable>(url: String,
                                                responseType: Response.Type = Response.self,
                                                completion: @escaping (Response?, Bool) -> Void) {
        do {
            try MSLoginManager.shared.sharedSession?.request(url.asURL(),
                                                             method: .get).responseDecodable(of: Response.self) { response in
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
            completion(nil, false)
        }
    }
    
    private class func POST<Response: Decodable, Param: Encodable, Header: Codable>(url: String,
                                                                   params:Param,
                                                                   headers: Header? = nil,
                                                                   encoder: ParameterEncoder,
                                                                   responseType: Response.Type = Response.self,
                                                                   completion: @escaping (Response?, Bool) -> Void) {
        do {
            var httpHeaders: HTTPHeaders? = nil
            if let data = try? JSONEncoder().encode(headers),
               let dict = try? JSONSerialization.jsonObject(with: data , options: []) as? [String: String] {
               httpHeaders = HTTPHeaders(dict)
            }
            try MSLoginManager.shared.sharedSession?.request(url.asURL(),
                                                             method: .post,
                                                             parameters: params,
                                                             encoder: encoder,
                                                             headers: httpHeaders).responseDecodable(of: Response.self) { response in
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
            completion(nil, false)
        }
    }
}
