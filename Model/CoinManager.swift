//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func updateLabel(for rate: String)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "BF654CD1-69CD-4656-BA33-3A53E6CB007D"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(currency: String) {
        let urlComplete = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        getCurrencyRate(for: urlComplete)
        
    }

    func getCurrencyRate(for urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                if let safeData = data {
                    if let rateExchange = self.parseJSON(for: safeData) {
                        self.delegate?.updateLabel(for: rateExchange)
                    }
                    
                    
                }
            }
            
            task.resume()
            
            
            
            
            
        }
        
    }
    
    func parseJSON(for exchange: Data) -> String? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ByteData.self, from: exchange)
            return String(format: "%.f3", decodedData.rate)
        }
        
        catch {
            print(error)
            return nil
        }
        
    }
    
}
