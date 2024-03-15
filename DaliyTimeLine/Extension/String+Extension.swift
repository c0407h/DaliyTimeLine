//
//  String+Extension.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 3/16/24.
//

import Foundation

extension String {
    func stringToDate(format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
