//
//  AQIChartViewModel.swift
//  AQIDemo
//
//  Created by Santosh Gupta on 19/06/21.
//

import Foundation

protocol AQIChartViewModelProtocol {
    var data: AQIData? { get set }
    var aqilist: [Double] { get }
    var delegate: AQIDataDelegate? { get set }
    func setup()
    func filterCityAQI(aqiList: [AQIData])
    func setWebSocketDelegate()
}

class AQIChartViewModel: AQIChartViewModelProtocol {
    
    var data: AQIData?
    var aqilist = [Double]()
    weak var delegate: AQIDataDelegate?
    var timer: Timer?
    init() {}
    
    func setup() {
        self.setWebSocketDelegate()
        WebSocketManager.shared.setTriggerTime(interval: 5)
    }
    
    func setWebSocketDelegate() {
        WebSocketManager.shared.delegate = self
    }
    
}

extension AQIChartViewModel: WebSocketManagerDelegate {
    
    func recievedAQIData(aqiList: [AQIData]) {
        self.filterCityAQI(aqiList: aqiList)
    }
    
    func filterCityAQI(aqiList: [AQIData]) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async { [weak self] in
            guard let self = self else { return }
            if let data = self.data {
                for aqiData in aqiList {
                    if aqiData.city == data.city {
                        self.aqilist.append(aqiData.aqi)
                        break
                    }
                }
            }
            DispatchQueue.main.async {
                print(self.aqilist.count)
                self.delegate?.aqiDataUpdated()
            }
        }
    }
    
}
