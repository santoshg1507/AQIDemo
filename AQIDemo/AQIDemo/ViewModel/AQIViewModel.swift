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
    func setWebSocketDelegate()
    var delegate: AQIDataDelegate? { get set }
    
}

class AQIViewModel: AQIViewModelProtocol {
    
    var webSocketManager: WebSocketManagerProtocol?
    var cityList = [String]()
    var aqiDataListWithCity = [String:AQIData]()
    weak var delegate: AQIDataDelegate?
    private var callingFlag = false
    init() {}
    
    func setup(webSocketManager: WebSocketManagerProtocol) {
        self.webSocketManager = webSocketManager
        self.webSocketManager?.delegate = self
        self.webSocketManager?.connect()
    }
    
    func setWebSocketDelegate() {
        self.webSocketManager?.delegate = self
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
        if !callingFlag {
            callingFlag = true
            let queue = DispatchQueue.global(qos: .userInitiated)
            queue.async {
                for data in list {
                    if var savedData = self.aqiDataListWithCity[data.city] {
                        savedData.aqi = data.aqi
                        savedData.updatedAt = Date()
                        self.aqiDataListWithCity[data.city] = savedData
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
                self.callingFlag = false
            }
        }
    }
}
