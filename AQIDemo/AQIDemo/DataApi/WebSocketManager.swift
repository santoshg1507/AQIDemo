//
//  WebSocketManager.swift
//  AQIDemo
//
//  Created by Santosh Gupta on 19/06/21.
//

import Foundation
import Starscream

protocol WebSocketManagerDelegate: class {
    func recievedAQIData(aqiList: [AQIData])
}

protocol WebSocketManagerProtocol {
    func setup(urlstring: String)
    func connect()
    func handleWebSocketData(text: String)
    func disconnect()
    var delegate: WebSocketManagerDelegate? {get set}
    func setTriggerTime(interval: Int)
}

class WebSocketManager: WebSocketManagerProtocol {
    
    private var websocket: WebSocket?
    weak var delegate: WebSocketManagerDelegate?
    var triggerTime = Date().timeIntervalSince1970
    private var triggerInterval = 1
    private var forceTrigger = true

    static let shared: WebSocketManager = WebSocketManager()
    
    private init() {
        self.setup()
    }
    
    func setup(urlstring: String = Constants.webSocketUrl) {
        if let url = URL(string: urlstring) {
            let request = URLRequest(url: url)
            self.websocket = WebSocket(request: request)
            self.websocket?.delegate = self
            self.websocket?.onEvent = { event in
                self.handleEvent(event: event)
            }
        }
    }
    
    func setTriggerTime(interval: Int) {
        self.forceTrigger = true
        self.triggerInterval = interval
    }
    
    func connect() {
        self.websocket?.connect();
    }
    
    func disconnect() {
        self.websocket?.disconnect(closeCode: CloseCode.goingAway.rawValue)
        
    }
    
    func handleEvent(event: WebSocketEvent) {
        switch event {
        case .connected(let headers):
            print("connected \(headers)")
        case .disconnected(let reason, let closeCode):
            print("disconnected \(reason) \(closeCode)")
        case .text(let text):
            self.handleWebSocketData(text: text)
            print("received text: \(text)")
        case .binary(let data):
            print("received data: \(data)")
        case .pong(let pongData):
            print("received pong: \(pongData ?? Data())")
        case .ping(let pingData):
            print("received ping: \(pingData ?? Data())")
        case .error(let error):
            print("error: \(error?.localizedDescription ?? "")")
        case .viabilityChanged:
            print("viabilityChanged")
        case .reconnectSuggested:
            print("reconnectSuggested")
        case .cancelled:
            print("cancelled")
        }
    }
    
    func handleWebSocketData(text: String) {
        if forceTrigger || Int((Date().timeIntervalSince1970 - triggerTime)) > self.triggerInterval {
            forceTrigger = false
            self.triggerTime = Date().timeIntervalSince1970
            if let models = AQIData.objects(jsonString: text) {
                self.delegate?.recievedAQIData(aqiList: models)
            }
        }

    }
    
}

extension WebSocketManager: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        self.handleEvent(event: event)
    }
}
