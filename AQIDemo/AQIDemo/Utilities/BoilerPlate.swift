//
//  BoilerPlate.swift
//  AQIDemo
//
//  Created by Santosh Gupta on 19/06/21.
//

import Foundation

class Constants {
    static var webSocketUrl = "wss://city-ws.herokuapp.com/"
}

extension NSObject {
    static var className : String {
        return String(describing:self)
    }
}

extension Date {
    func relativeDateTime() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let relativeDate = formatter.localizedString(for: self, relativeTo: Date())
        return relativeDate
    }
}

