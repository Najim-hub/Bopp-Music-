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
        if(number != nil){
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
        
        return ""
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

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
class MarketCap: ObservableObject {
    
    @AppStorage("MarketData") var MarketData: [Wallet] = []
    
    @AppStorage("Chart") var Chart : [ String ] = []
    
    @AppStorage("EtherPrice") var EtherPrice: Double = 0
    
    @AppStorage("TotalValue") var TotalValue: String = "0"
    
    @AppStorage("AccountBalance") var AccountBalance = ""
    
    @AppStorage("FinalValue") var FinalValue = 0
    
    @AppStorage("AccountNumber") var AccountNumber = ""
    
    @AppStorage("walletConnected") var walletConnected = false
    
    @Published var items : [Wallet] = []
    
    @Published var TokenPrices : [Price] = []
    
    @AppStorage("price") var price : Double = 0
     
    @State var value = 0
    
    @AppStorage("currentValue") private var currentValue: Double = 0
    
    static let sharedInstance = MarketCap()
    
    func chartData(){
        
        var myURL = "https://web3api.io/api/v2/addresses/0x06012c8cf97bead5deae237070f9587f8e7a266d/account-balances/historical?includePrice=true"
      
        
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
                
                for (key, value) in json {
                    print("\(key) -> \(value)")
                }
            }
            
         catch {
            print("error")
        }
})
        

    myQuery.resume()
    }
    
    func getEtherLastPrice(){
        
       var myURL = "https://api.etherscan.io/api?module=stats&action=ethprice&apikey=KWDSQPGWMIMT9T3F6NA38YA47GQIJ4F6YM"
       
        let url = NSURL(string: myURL)!

        let config = URLSessionConfiguration.default


        let urlSession = URLSession(configuration: config)

            let myQuery = urlSession.dataTask(with: url as URL, completionHandler: { [self]
            data, response, error -> Void in
          
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
            
                let ethPrice = (json as NSDictionary).value(forKeyPath: "result.ethusd") as? NSArray
                
             
                let ethPriceString = (json["result"]!["ethusd"]! as! NSString).doubleValue
            
                DispatchQueue.main.async {
                    
                EtherPrice = ethPriceString
                 
                    if walletConnected {
                    if(Double(AccountBalance) != nil ){
                        
                var RealValue = EtherPrice * Double(AccountBalance)!
                  
                    TotalValue = RealValue.delimiter
                       
                   var AbsoluteTotal =  TotalValue.replacingOccurrences(of: ",", with: "")
                        
                        if(Double(AbsoluteTotal) != nil){
                    currentValue = Double(AbsoluteTotal)!
                        if Chart.last != AbsoluteTotal  {
                        
                    Chart.append(AbsoluteTotal)
                        
                    }
                        }
                        else{
                            print("Total Value is nil, ", AbsoluteTotal)
                        }
                 
                    print(Chart)
                    }
                }
                    else {
                        Chart.removeAll()
                    }
                }
               
               // print(TotalValue)
               
                }
             catch {
                print("error  unable to get ether price")
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
                if(data != nil){
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
                //print(json)
                let token = (json as NSDictionary).value(forKeyPath: "data.price") as? NSArray
                
                let TokenNamed = (json as NSDictionary).value(forKeyPath: "data.name") as? NSArray
                
                
                if(token != nil){
                  
                    //print("NAMEEEE ! 1STTTT", TokenNamed![0])
                    
                    var objCArray = NSMutableArray(array: token!)

                    
                    let swiftArray = objCArray as NSArray as? [Double]
                   
                    DispatchQueue.main.async {
                        
                        guard let amount = swiftArray?[exist: 0]?.avoidNotation else { return }
                        
                        var val = Double(amount.replacingOccurrences(of: ",", with: "") ?? "0")
                      
                        TokenPrices.append(Price(name: TokenNamed![0] as! String, symbols: TokenSymbol, price: val!))
                        }
                }
                    
                }
                }
             
             catch {
                print("error with token prices")
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
        
        if(AccountNumber != nil || AccountNumber != "" || walletConnected == false){
     var myURL = "https://web3api.io/api/v2/addresses/"+AccountNumber+"/token-balances/latest?&includePrice=true&currency=eth"
      
        
        let url = NSURL(string: myURL)!

        let config = URLSessionConfiguration.default

        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            
            "x-amberdata-blockchain-id": "ethereum-mainnet",
            "x-api-key": "UAK9f65da8aa1a86fd4d1a91bb932adb4a1"
            
        ]

        let urlSession = URLSession(configuration: config)

            let myQuery = urlSession.dataTask(with: url as URL, completionHandler: { [self]
            data, response, error -> Void in
          
            do {
                
                if(data != nil){
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
               // print(json)
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
                            
                           // print("NAMEEEE IN MAINNN CALLL", names)
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
            }
                
            }catch {
                print("error with market data")
            }
            
        })
        myQuery.resume()
       
        
        var myURLs = "https://web3api.io/api/v2/"+AccountNumber+"/balances"
        
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
                print("error with balances")
            }
            
        })
        myQuerys.resume()
       
    }
    }
    
    
    init(){
        
        
        
        
    }

}

extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
