//
//  MSLoginManager.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/31.
//

import Foundation

typealias RequestCompletionClosure = (Bool) -> ()
class MSLoginManager: NSObject {
    static let shared: MSLoginManager = {
       MSLoginManager()
    }()
    private static let UserInfoPathKey = "loginUserInfoPathKey"
    private var isLogin: Bool = false
    var userID: String = ""
    
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
    
    public func login(userID: String, password: String, completion: RequestCompletionClosure) {
        isLogin = true
        self.userID = userID
        completion(true)
    }
    
    public func register(userID: String, password: String, completion: RequestCompletionClosure) {
        
    }
}

extension MSLoginManager: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
    }
}
