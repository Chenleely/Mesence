//
//  MSLog.swift
//  Mesence
//
//  Created by 罗志华 on 2023/7/31.
//

import Foundation

enum MSLogLevel {
    case info
    case debug
    case warning
    case error
}

class MSLog {
    class func logI(tag: String, log: String) {
        print("\(MSLogLevel.info) " +  "<\(tag)> : "  + "  " + log)
    }
    class func logD(tag: String, log: String) {
        print("\(MSLogLevel.debug) " + "<\(tag) > : " + "  " + log)
    }
    class func logW(tag: String, log: String) {
        print("\(MSLogLevel.warning) " +  "<\(tag)> : "  + "  " + log)
    }
    class func logE(tag: String, log: String) {
        print("\(MSLogLevel.error) " +  "<\(tag)> : " + "  " + log)
    }
}
