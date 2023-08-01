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
    private let tokenDic = [
        "test" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJQaG9uZSI6InRlc3QiLCJOYW1lIjoidGVzdCIsImV4cCI6MTY5MDk1NDIxMiwiaXNzIjoic3Vubnlfd2VhdGhlcl9sb3VpczI5NiIsInN1YiI6InN1bm55X3dlYXRoZXIifQ.j7bxp3fLi-_N67fdWvfcTpwcwasKjiXFDMJlGHmQ7no",
        "b"    : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJQaG9uZSI6ImIiLCJOYW1lIjoiYiIsImV4cCI6MTY5MDk3ODczMSwiaXNzIjoic3Vubnlfd2VhdGhlcl9sb3VpczI5NiIsInN1YiI6InN1bm55X3dlYXRoZXIifQ.nrmK7Y_uGVlfjSEXwkViESeLfQWd0qdnBRQr3oKwUvg"
    ]
    private var isLogin: Bool = false
    var userID: String = ""
    var token: String = ""
    
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
        if let token = self.tokenDic[userID] {
            self.token = token
            MSMessageClient.shared.configURLAfterLogin()
            completion(true)
        }
    }
    
    public func register(userID: String, password: String, completion: RequestCompletionClosure) {
        
    }
}

extension MSLoginManager: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
    }
}
