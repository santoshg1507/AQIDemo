//
//  AQIChartViewController.swift
//  AQIDemo
//
//  Created by Santosh Gupta on 19/06/21.
//

import UIKit

class AQIChartViewController: UIViewController {
    
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var graphView: UIView!
    @IBOutlet private var widthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var intervalTextField: UITextField!

    var viewModel: AQIChartViewModelProtocol = AQIChartViewModel()
    private var addedIndex = 0
    private var intervalList: [Int] = [5,10,20,30,40,50,60]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AQI Chart of \(viewModel.data?.city ?? "")"
        self.viewModel.setup()
        self.viewModel.delegate = self
        self.textFieldSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupGraph()
    }
    
    func textFieldSetup() {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        self.intervalTextField.inputView = pickerView
        
        let bar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        bar.items = [space,done]
        bar.sizeToFit()
        intervalTextField.inputAccessoryView = bar
        self.intervalTextField.text = "\(self.viewModel.interval) seconds"
    }
    
    @objc func dismissKeyboard() {
        self.intervalTextField.resignFirstResponder()
        (self.backView.viewWithTag(101) as? UILabel)?.text = "Live AQI data in \(viewModel.interval) second interval"
        self.viewModel.setWebSocketDelegate()
    }
    
    func setupGraph() {
        let arr = [0,50,100,200,300,400,500]
        for i in 0 ... 6 {
            let label = UILabel(frame: CGRect(x: 30, y: 250 - arr[i]/2 - 20, width: 50, height: 20))
            label.text = "\(arr[i])"
            self.backView.addSubview(label)
        }
        self.scrollView.layer.borderColor = UIColor.gray.cgColor
        self.scrollView.layer.borderWidth = 1

        let desclabel = UILabel(frame: CGRect(x: 70 , y: 250 + 10 , width: CGFloat(300), height: 20))
        desclabel.text = "Live AQI data in \(viewModel.interval) second interval"
        desclabel.tag = 101
        desclabel.textAlignment = .left
        desclabel.textColor = UIColor.black
        
        self.backView.addSubview(desclabel)
    }
    
    func updateGraph() {
        if self.addedIndex < viewModel.aqilist.count {
            for i in self.addedIndex ..< viewModel.aqilist.count {
                let barview = UIView(frame: CGRect(x: CGFloat(30*i) + 10, y: CGFloat(250 - self.viewModel.aqilist[i]/2) , width: CGFloat(10), height: CGFloat(self.viewModel.aqilist[i]/2)))
                barview.backgroundColor = UIColor.fromHexCode(hex: AQIRange.range(aqi: self.viewModel.aqilist[i]).hexColorCode())
                self.graphView.addSubview(barview)
                let valuelabel = UILabel(frame: CGRect(x: CGFloat(30*i), y: CGFloat(250 - self.viewModel.aqilist[i]/2) - 25 , width: CGFloat(30), height: 20))
                valuelabel.text = "\(Int(viewModel.aqilist[i]))"
                valuelabel.textAlignment = .center
                valuelabel.font = valuelabel.font.withSize(10)
                valuelabel.textColor = UIColor.black
                self.graphView.addSubview(valuelabel)
                
            }
        }
        self.widthConstraint.constant = CGFloat(viewModel.aqilist.count*30)
        self.view.layoutIfNeeded()
        self.addedIndex = viewModel.aqilist.count
        
        if self.scrollView.frame.size.width < self.widthConstraint.constant {
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentOffset.x = self.scrollView.contentSize.width - self.scrollView.frame.size.width
            }
        }
    }
    
}

//MARK: AQIDataDelegate func
extension AQIChartViewController: AQIDataDelegate {
    
    func aqiDataUpdated() {
        self.updateGraph()
    }
    
}


// MARK: UIPickerView Delegation
extension AQIChartViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.intervalList.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(self.intervalList[row]) seconds"
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.interval = self.intervalList[row]
        self.intervalTextField.text = "\(self.intervalList[row]) seconds"
    }
}
