//
//  AQITableViewCell.swift
//  AQIDemo
//
//  Created by Santosh Gupta on 19/06/21.
//

import Foundation
import UIKit

class AQITableViewCell: UITableViewCell {
    
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var aqiLabel: UILabel!
    @IBOutlet private weak var updatedTimeLabel: UILabel!
    
    func configureCell(data: AQIData) {
        self.cityNameLabel.text = data.city
        self.aqiLabel.text =  String(format: "%.2f", data.aqi)
        self.updatedTimeLabel.text = data.relativeDateString
    }
    
}
