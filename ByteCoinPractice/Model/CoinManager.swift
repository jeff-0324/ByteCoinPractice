//
//  CoinManager.swift
//  ByteCoinPractice
//
//  Created by jae hoon lee on 2023/09/12.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager : CoinManager, coin : CoinValue)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/USD"
    let apiKey = "apikey=1D05E12E-8263-4308-A976-F76AA00D6D1E"
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate : CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)?\(apiKey)"
        self.performRequest(urlString: urlString)
    }
    
    func performRequest(urlString : String) {
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
                    self.parseJSON(coinData: safeData)
                }
            }
           
                task.resume()
            }
        }
    func parseJSON(coinData : Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            print(decodedData.rate)
        } catch {
            print(error)
        }
    }
}
   

  
    
//    func parseJson(_: _ ) {
//        
//    }
    
    



//            let task = session.dataTask(with: url) {(data, response, error) in
//                if error != nil {
//                    delegate?.didFailWithError(error: error!)
//                    return
//                }
//                if let safeData = data {
//                    if let rate = self.parseJson(safeData) {
//                        self.delegate?.didUpdateCoin(self, coin: rate)
//                    }
//                }
