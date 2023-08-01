//
//  MSCommonInceptor.swift
//  Mesence
//
//  Created by 罗志华 on 2023/8/1.
//

import Foundation
import Alamofire

final class MSCommonInceptor: RequestInterceptor {
    let accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var modifiedRequest = urlRequest
        modifiedRequest.addValue(accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(modifiedRequest))
    }
}

