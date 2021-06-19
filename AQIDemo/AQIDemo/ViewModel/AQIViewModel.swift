//
//  AQIViewModel.swift
//  AQIDemo
//
//  Created by Santosh Gupta on 19/06/21.
//

import UIKit

protocol AQIDataDelegate: class {
    func aqiDataUpdated()
}

protocol AQIViewModelProtocol {
    func numberOfSections() -> Int
    func notOfRowInSection(section: Int) -> Int
    func aqiDataAt(index: Int) -> AQIData?
    func setup(webSocketManager: WebSocketManagerProtocol)
    var delegate: AQIDataDelegate? { get set }
    
}

class AQIViewModel: AQIViewModelProtocol {
    
    var webSocketManager: WebSocketManagerProtocol?
    var cityList = [String]()
    var aqiDataListWithCity = [String:AQIData]()
    weak var delegate: AQIDataDelegate?
    
    init() {}
    
    func setup(webSocketManager: WebSocketManagerProtocol) {
        self.webSocketManager = webSocketManager
        self.webSocketManager?.delegate = self
        self.webSocketManager?.connect()
    }
    
}

extension AQIViewModel: WebSocketManagerDelegate {
    
    func recievedAQIData(aqiList: [AQIData]) {
        self.addDataInList(list: aqiList)
    }
    
}

extension AQIViewModel {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func notOfRowInSection(section: Int) -> Int {
        return self.cityList.count
    }
    
    func aqiDataAt(index: Int) -> AQIData? {
        if index < self.cityList.count {
            if let data = self.aqiDataListWithCity[cityList[index]] {
                return data
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
}

extension AQIViewModel {
    
    func addDataInList(list: [AQIData]) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            for data in list {
                if let savedData = self.aqiDataListWithCity[data.city] {
                    savedData.aqi = data.aqi
                    savedData.updatedAt = Date()
                }
                else {
                    self.aqiDataListWithCity[data.city] = data
                    self.cityList.append(data.city)
                }
            }
            self.cityList.sort()
            DispatchQueue.main.async {
                self.delegate?.aqiDataUpdated()
            }
        }
    }
}
