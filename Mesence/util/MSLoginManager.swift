//
//  MSLoginManager.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/31.
//

import Foundation
import Alamofire

typealias RequestCompletionClosure = (Bool) -> ()

class MSLoginManager: NSObject {
    static let shared: MSLoginManager = {
       MSLoginManager()
    }()
    var userID: String = ""
    var token: String = ""
    var sharedSession: Session?
    private var isLogin: Bool = false
    private let loginTag = "MSLoginManager"
    private static let loginPath = baseURL + "/login"
    private static let baseURL = "http://louis296.top:9010"
    private static let UserInfoPathKey = "loginUserInfoPathKey"
    
    private override init() {
        super.init()
    }
    
    @discardableResult
    public func checkTokenValid() -> Bool {
        if let userInfo = UserDefaults.standard.value(forKey: MSLoginManager.UserInfoPathKey) {
            // check if token is valid
        }
        return isLogin
    }
    
    public func login(userID: String, password: String, completion: @escaping RequestCompletionClosure) {
        do {
            let headers = MSLoginRequest(Phone: userID, Password: password)
            try AF.request(MSLoginManager.loginPath.asURL(),
                           method: .post,
                           parameters: headers,
                           encoder: JSONParameterEncoder.default,
                           headers: ["Accept" : "application/json"]).responseDecodable(of: MSLoginResponse.self, completionHandler: { response in
                switch response.result {
                case .failure(let error):
                    print(error)
                case .success(let res):
                    if res.Status == "Success" {
                        self.userID = userID
                        self.token = res.Data.Token ?? ""
                        self.sharedSession = Session(interceptor: MSCommonInceptor(accessToken: self.token))
                        MSMessageClient.shared.configURLAfterLogin()
                        completion(true)
                    } else {
                        MSLog.logE(tag: self.loginTag, log: res.Data.Message ?? "")
                        completion(false)
                    }
                }
            })
        } catch(let error) {
            MSLog.logE(tag: loginTag, log: "\(error)")
        }
    }
    
    public func register(userID: String, password: String, completion: RequestCompletionClosure) {
        
    }
}

extension MSLoginManager: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
    }
}
