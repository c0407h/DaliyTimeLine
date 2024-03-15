//
//  Date+Extension.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 3/16/24.
//

import Foundation

extension Date {
    func dateToString(format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
