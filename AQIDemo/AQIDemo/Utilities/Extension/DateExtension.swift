//
//  DateExtension.swift
//  AQIDemo
//
//  Created by Santosh Gupta on 19/06/21.
//

import Foundation

extension Date {
    func relativeDateTime() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let relativeDate = formatter.localizedString(for: self, relativeTo: Date())
        return relativeDate
    }
}
