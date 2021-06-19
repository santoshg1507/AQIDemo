//
//  BoilerPlate.swift
//  AQIDemo
//
//  Created by Santosh Gupta on 19/06/21.
//

import Foundation
import UIKit

class Constants {
    static var webSocketUrl = "wss://city-ws.herokuapp.com/"
}

extension NSObject {
    static var className : String {
        return String(describing:self)
    }
}

extension UIStoryboard {
    static func instantiateVC(storyboard: StoryboardName, identifier: String) -> UIViewController? {
        return UIStoryboard(name: storyboard.rawValue , bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
}

enum StoryboardName: String {
    case main = "Main"
}
