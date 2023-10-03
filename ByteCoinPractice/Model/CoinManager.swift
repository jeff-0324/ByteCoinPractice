//
//  CoinManager.swift
//  ByteCoinPractice
//
//  Created by jae hoon lee on 2023/09/12.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(price : String, currency : String)
    func didFailWithError(error: Error)
}


struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "apikey= "
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate : CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?\(apiKey)"
        //input으로 받은 url
        if let url = URL(string: urlString){
            //session을 생성하는데 기본 브라우저와 같은 설정
            let session = URLSession(configuration: .default)
            //session에게 임무를 준 후 결과물을 task에 넣는다
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdateCoin(price: priceString, currency: currency)
                    }
                }
            }
           
                task.resume()
            }
        }
    
    func parseJSON(_ data : Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let price = decodedData.rate
            return price
        } catch {
            print(error)
            return nil
        }
    }
}
