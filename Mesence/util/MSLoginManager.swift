//
//  MSLoginManager.swift
//  Mesence
//
//  Created by luozhihua on 2023/7/31.
//

import Foundation

typealias RequestCompletionClosure = (Bool) -> ()
class MSLoginManager {
    static let shared: MSLoginManager = {
       MSLoginManager()
    }()
    private static let UserInfoPathKey = "loginUserInfoPathKey"
    private var isLogin: Bool = false
    
    private init() {}
    
    @discardableResult
    public func checkTokenValid() -> Bool {
        if let userInfo = UserDefaults.standard.value(forKey: MSLoginManager.UserInfoPathKey) {
            // check if token is valid
        }
        return false
    }
    
    public func login(userID: String, password: String, completion: RequestCompletionClosure) {
        completion(true)
    }
    
    public func register(userID: String, password: String, completion: RequestCompletionClosure) {
        
    }
}
