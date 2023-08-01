//
//  MSTimeTools.swift
//  Mesence
//
//  Created by 罗志华 on 2023/8/1.
//

import Foundation

class MSTimeTools {
    class func generateRFC3339String(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.string(from: date)
    }
}
