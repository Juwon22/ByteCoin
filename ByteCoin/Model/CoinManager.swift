//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8DFB7627-5D13-4EE2-A669-27592D5D6B37"
    
    //create optional delegate
    var delegate: CoinManagerDelegate?
    
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        if let url = URL(string: "https://rest.coinapi.io/v1/exchangerate/BTC/\(currency)?apikey=\(apiKey)") {
//            print(url)
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, respone, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                if let safedata = data {
                    
                    if let bitcoinPrice = self.parseJSONData(safedata) {
                        
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSONData(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let rate = decodedData.rate
            print(rate)
            return rate
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}


protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}
