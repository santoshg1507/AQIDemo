//
//  AQIViewController.swift
//  AQIDemo
//
//  Created by Santosh Gupta on 19/06/21.
//

import UIKit

class AQIViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    var viewModel: AQIViewModelProtocol = AQIViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setup(webSocketManager: WebSocketManager.shared)
        viewModel.delegate = self
    }
    
    
}

//MARK: AQIDataDelegate func
extension AQIViewController: AQIDataDelegate {
    
    func aqiDataUpdated() {
        self.tableView.reloadData()
    }
    
}

//MARK: table view delegate
extension AQIViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notOfRowInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AQITableViewCell.className, for: indexPath) as! AQITableViewCell
        if let aqiData = viewModel.aqiDataAt(index: indexPath.row) {
            cell.configureCell(data: aqiData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}


