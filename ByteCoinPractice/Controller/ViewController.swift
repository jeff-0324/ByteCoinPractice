//
//  ViewController.swift
//  ByteCoinPractice
//
//  Created by jae hoon lee on 2023/09/12.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate{

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }

    func didUpdateCoin(price : String, currency : String) {
        DispatchQueue.main.sync {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    
    // pickerview의 선택하는 라인 갯수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // pickerview에 들어가는 컴포넌트 갯수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    // pickervie에 들어가는 내용
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return coinManager.currencyArray[row]
    }
    //pickerview에서 선택된 벨류값을 반환
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
    
}

