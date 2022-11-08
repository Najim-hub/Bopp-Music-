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
import BigInt

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

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension Double {
    var avoidNotation: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 18
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self) ?? ""
    }
}

extension String {
    var avoidNotation: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 18
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self) ?? ""
    }
}

extension String {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number! / 1000
        let million = number! / 1000000
        let billion = number! / 1000000000
        let trillion = number! / 1000000000000
        
        
        if trillion >= 1.0 {
            return "\(round(trillion*10)/10)T"
        }
        
        else if billion >= 1.0 {
            return "\(round(billion*10)/10)B"
        }
        
        else if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        
        else {
            return "\(self)"
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter
    }()

    var delimiter: String {
        return Double.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
class MarketCap: ObservableObject {
    
    @AppStorage("MarketData") var MarketData: [Wallet] = []
    
    @Published var items : [Wallet] = []
    
    @Published var TokenPrices : [Price] = []
    
    @AppStorage("price") var price : Double = 0
     
    @State var value = 0
    
    static let sharedInstance = MarketCap()
    
    func getEtherLastPrice(){
        
       var myURL = "https://api.etherscan.io/api?module=stats&action=ethprice&apikey=KWDSQPGWMIMT9T3F6NA38YA47GQIJ4F6YM"
        
        
        let url = NSURL(string: myURL)!

        let config = URLSessionConfiguration.default


        let urlSession = URLSession(configuration: config)

            let myQuery = urlSession.dataTask(with: url as URL, completionHandler: { [self]
            data, response, error -> Void in
          
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
                
                print(json)
               
                }
             catch {
                print("error")
            }
    })
            
    
        myQuery.resume()
        
        
    }
    
    func getTokenInfo(TokenSymbol : String, TokenName : String){

        var TokenSymbol = TokenSymbol
        var TokenName = TokenName
        
    var myURL = "https://api.lunarcrush.com/v2?data=assets&key=lo10p6pattjcie45kiula&symbol="+TokenSymbol+""
        
        guard let url = NSURL(string: myURL) else{
            return
        }

        let config = URLSessionConfiguration.default


        let urlSession = URLSession(configuration: config)

            let myQuery = urlSession.dataTask(with: url as URL, completionHandler: { [self]
            data, response, error -> Void in
          
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
                //print(json)
                let token = (json as NSDictionary).value(forKeyPath: "data.price") as? NSArray
                
                let TokenNamed = (json as NSDictionary).value(forKeyPath: "data.name") as? NSArray
                
                
                if(token != nil){
                  
                    print("NAMEEEE ! 1STTTT", TokenNamed![0])
                    
                    var objCArray = NSMutableArray(array: token!)

                    var swiftArray = objCArray as NSArray as! [Double]
                   
                    DispatchQueue.main.async {
                           
                            //TokenPrices.removeAll()
                            
                           // price = (swiftArray[0].avoidNotation as NSString).doubleValue
                        var amount = swiftArray[0].avoidNotation
                        
                        
                       var val = Double(amount.replacingOccurrences(of: ",", with: ""))
                        
                        print("Priceee!!!!!!!!!!", val, "SYMBOLLLLLLL", TokenSymbol, "NAMEEEEEEE!!", TokenNamed![0] as! String)
                        
                        TokenPrices.append(Price(name: TokenNamed![0] as! String, symbols: TokenSymbol, price: val!))
                        }
                       
                
                }
                }
             
             catch {
                print("error")
            }
    })
            
    
        myQuery.resume()
        
    }
    
    func returnValue(Symbol: String, Amount : Double, Name: String) -> String {
        
        var price = 0.0
        
        var amount = Amount.avoidNotation
        
        var Name = Name
        
        var val = Double(amount.replacingOccurrences(of: ",", with: ""))
        
        
        
        for i in 0..<TokenPrices.count{
            
            print(Name)
         print(TokenPrices[i].name)
            
            if(TokenPrices[i].symbols == Symbol && TokenPrices[i].name.caseInsensitiveCompare(Name) == .orderedSame){
            
                if(amount != nil){
                    
                    price = TokenPrices[i].price * val!
                
        break
                }
        }
        
        }
        
      
        
        return  price.delimiter
    
        
    }
    
    func getData(){
        
        var firstUrl = "https://api.1inch.exchange/v3.0/1/tokens"
        
        let Securls = NSURL(string: firstUrl)!

        let configure = URLSessionConfiguration.default


        let urlSessioned = URLSession(configuration: configure)

        let myQueried = urlSessioned.dataTask(with: Securls as URL, completionHandler: {
            data, response, error -> Void in
            /* ... */
            //print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
                let s = json as? NSArray
                
                
               //print(s)
                
            } catch {
                print("error")
            }
            
        })
        myQueried.resume()
       
    

        var myURL = "https://web3api.io/api/v2/addresses/0x7a27a20f6a489882700db0c86be063f12a4f6bf2/token-balances/latest?&includePrice=true&currency=eth"
        
        
        //var myURL = "https://web3api.io/api/v2/addresses/0xca1D42E55517197787Be198ED803A3c4c5631E46/account-balances/latest"
       //total balance in ETH
        
            // var myURL = "https://web3api.io/api/v2/addresses/0xC1B27B0F1dC8125AD6547500D294e804f9e20540/account-balances/latest"
        
        
        //var myURL = "https://api.etherscan.io/api?module=token&action=tokeninfo&contractaddress=0x0e3a2a1f2146d86a604adc220b4967a898d7fe07&apikey=KWDSQPGWMIMT9T3F6NA38YA47GQIJ4F6YM"
        
        
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
          
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
                print(json)
                let s = (json as NSDictionary).value(forKeyPath: "payload.records.symbol") as? NSArray
                
                let amount = (json as NSDictionary).value(forKeyPath: "payload.records.amount") as? NSArray
                
                let decimal = (json as NSDictionary).value(forKeyPath: "payload.records.decimals") as? NSArray
                
                let addr = (json as NSDictionary).value(forKeyPath: "payload.records.address") as? NSArray
                
                let name = (json as NSDictionary).value(forKeyPath: "payload.records.name") as? NSArray
                
                let swiftArray: [String] = (amount?.compactMap({ $0 as? String }))!
                
                let intArray = swiftArray.map { Float($0)!}
                
                let decArray: [String] = (decimal?.compactMap({ $0 as? String }))!
                
                let decIntArry =  decArray.map { Float($0)!}
                
                guard let num = s?.count else{
                    print("Empty")
                    return
                }
                
                if s != []  {
                
                if !MarketCap.sharedInstance.MarketData.isEmpty{
                    
                    DispatchQueue.main.async {
                   MarketCap.sharedInstance.MarketData.removeAll()
                    }
                    for i in 0..<num {
                        DispatchQueue.main.async {
                            let sum = s?[i]
                            
                            let names = name?[i]
                            
                            print("NAMEEEE IN MAINNN CALLL", names)
                            
                            if (decIntArry[i] <= 9){
                                
                                
                            let ints = intArray[i]/1000000000
                                
                                let addrSymb = addr?[i]
                                    
                                    let numberFormatter = NumberFormatter()
                                    numberFormatter.numberStyle = .none
                                  
                                    guard let formattedNumber = numberFormatter.string(from: NSNumber(value: ints)) else { return }
                                
                               // print(ints)
                                getTokenInfo(TokenSymbol :  sum as! String, TokenName: names as! String)
                               
                                       // print("SYMBOLSSSS", TokenPrices)
                                        
                                MarketCap.sharedInstance.MarketData.append(Wallet(name: names as! String, symbol: sum as! String, amount: formattedNumber.roundedWithAbbreviations, address: addrSymb as! String, rawAmount: String(ints), decimal: String(decIntArry[i])
                                          ))
                                        
                                 
                                
                             }
                            
                            
                            else if (decIntArry[i] == 18){
                                
                            let ints = intArray[i]/1000000000000000000
                                
                                let addrSymb = addr?[i]
                                    
                                    let numberFormatter = NumberFormatter()
                                    numberFormatter.numberStyle = .none
                                  
                                    guard let formattedNumber = numberFormatter.string(from: NSNumber(value: ints)) else { return }
                                    
                              
                                getTokenInfo(TokenSymbol :  sum as! String, TokenName: names as! String)
                                
                              
                                value = Int(price * Double(ints))
                                       
                               
                                MarketCap.sharedInstance.MarketData.append(Wallet(name: names as! String, symbol: sum as! String, amount: formattedNumber.roundedWithAbbreviations, address: addrSymb as! String, rawAmount: String(ints), decimal: String(decIntArry[i]) ))
                                
                             }
                            
                            //dispactch end
                        }
                        
                    }
                }
                
                
                
                    else{
                        
                for i in 0..<num {
                    DispatchQueue.main.async {
                        let sum = s?[i]
                        let names = name?[i]
                        
                        if (decIntArry[i] <= 9){
                        let ints = intArray[i]/1000000000
                            
                            let addrSymb = addr?[i]
                                
                                let numberFormatter = NumberFormatter()
                                numberFormatter.numberStyle = .none
                              
                                guard let formattedNumber = numberFormatter.string(from: NSNumber(value: ints)) else { return }
                                
                            var value = price * Double(ints)
                                
                            MarketCap.sharedInstance.MarketData.append(Wallet(name: names as! String, symbol: sum as! String, amount: formattedNumber.roundedWithAbbreviations, address: addrSymb as! String, rawAmount: String(ints), decimal: String(decIntArry[i]) ))
                            
                         }
                        
                        
                        else if (decIntArry[i] == 18){
                            
                        let ints = intArray[i]/1000000000000000000
                            
                            let addrSymb = addr?[i]
                                
                                let numberFormatter = NumberFormatter()
                                numberFormatter.numberStyle = .none
                              
                                guard let formattedNumber = numberFormatter.string(from: NSNumber(value: ints)) else { return }
                            var value = price * Double(ints)
                                
                            MarketCap.sharedInstance.MarketData.append(Wallet(name: names as! String, symbol: sum as! String, amount: formattedNumber.roundedWithAbbreviations, address: addrSymb as! String, rawAmount: String(ints), decimal: String(decIntArry[i])))
                            
                         }
                    }
                }
                
                    }
                }
                //print(MarketCap.sharedInstance.MarketData)                //print(json)
              print(TokenPrices)
                
            } catch {
                print("error")
            }
            
        })
        myQuery.resume()
       
        
        var myURLs = "https://web3api.io/api/v2/0x7a27a20f6a489882700db0c86be063f12a4f6bf2/balances"
        
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
           // print(response!)
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
