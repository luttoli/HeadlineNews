//
//  Date.swift
//  HeadlineNews
//
//  Created by 김지훈 on 10/11/24.
//

import UIKit

extension Date {
    func toStringDetail() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd. HH:mm"
        dateFormatter.locale = Locale(identifier: "Asia/Seoul")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: self)
    }
}
