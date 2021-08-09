//
//  MarketCap.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-08-08.
//

import Foundation
import Combine
import SwiftUI
import Alamofire

struct Response: Codable {
    let items: [Item]
}

struct Item: Codable {
    let metadata: [Metadatum]
}

struct Metadatum: Codable {
    let key: String
    let value: String?
}



class MarketCap: ObservableObject {
    
    
    @Published var MarketData : [Wallet] = []
    
    static let sharedInstance = MarketCap()
    
    func getData(){
        
        var myURL = "https://web3api.io/api/v2/addresses/0x7a27a20f6a489882700db0c86be063f12a4f6bf2/token-balances/latest"
        
        let url = NSURL(string: myURL)!

        let config = URLSessionConfiguration.default

        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "x-amberdata-blockchain-id": "ethereum-mainnet",
            "x-api-key": "UAK64419e1e37f9e2caefbd7d8c5bf313bc"
        ]

        let urlSession = URLSession(configuration: config)

            let myQuery = urlSession.dataTask(with: url as URL, completionHandler: { [self]
            data, response, error -> Void in
            /* ... */
            //print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
                
                let s = (json as NSDictionary).value(forKeyPath: "payload.records.symbol") as? NSArray
                
                let amount = (json as NSDictionary).value(forKeyPath: "payload.records.amount") as? NSArray
                
                
                for i in 0..<s!.count {
                    DispatchQueue.main.async {
                    let sum = s?[i]
                    
                    let am = amount?[i]
                    
                    
                    
                    MarketCap.sharedInstance.MarketData.append(Wallet(symbol: sum as! String, amount: am as! String))
                    }
                }
                
                
                print(MarketCap.sharedInstance.MarketData)                //print(json)
                /*
                for value in Array(json.values) {
                    print("\(value)")
                }*/
                
            } catch {
                print("error")
            }
            
        })
        myQuery.resume()
       
        
        var myURLs = "https://web3api.io/api/v2/addresses/0xca1D42E55517197787Be198ED803A3c4c5631E46/account-balances/latest"
        
        let urls = NSURL(string: myURLs)!

        let configs = URLSessionConfiguration.default

        configs.httpAdditionalHeaders = [
            "Accept": "application/json",
            "x-amberdata-blockchain-id": "ethereum-mainnet",
            "x-api-key": "UAK64419e1e37f9e2caefbd7d8c5bf313bc"
        ]

        let urlSessions = URLSession(configuration: configs)

        let myQuerys = urlSessions.dataTask(with: urls as URL, completionHandler: {
            data, response, error -> Void in
            /* ... */
            //print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
               // print(json)
            } catch {
                print("error")
            }
            
        })
        myQuerys.resume()
       
    }
        
    
    
    init(){
        
        
        
        
    }

}
