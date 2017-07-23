//
//  AddStockPerformer.swift
//  Stoxxx
//
//  Created by Nickita on 9/6/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit

protocol AddStockPerformerDelegate: class {
    func finishedAddingStocks(result: [String]?)
}

class AddStockPerformer: NSObject {
    weak var delegate: AddStockPerformerDelegate?
    
    init(delegate: AddStockPerformerDelegate) {
        self.delegate = delegate
    }
    
    func addStock(stockSymbol:String){
        let url=URL(string:
            APIValues.createYahooFinanceURL(stockSymbol: stockSymbol, APIParams: APIValues.yahooStockSymbolParam+APIValues.yahooStockNameParam))
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error)in
            guard let data=data, error==nil else {return}
            let response=String(data:data, encoding:String.Encoding.utf8)as String!
            if response==nil {
                self.delegate?.finishedAddingStocks(result: nil)
                return
            }
            var P2O_ARR=(response?.components(separatedBy:","))!as[String]
            if P2O_ARR.count <= 1 {
                self.delegate?.finishedAddingStocks(result: nil)
                return
            }
            if P2O_ARR[1] != "N/A\n"{
                print(P2O_ARR[1])
                DispatchQueue.main.async {
                    let stockToAdd=StockModel()
                    stockToAdd.stockSymbol=P2O_ARR[0].replacingOccurrences(of:"\"", with:"", options:NSString.CompareOptions.literal, range:nil)
                    RealmLoader.addStockToRealm(stock:stockToAdd)
                    self.delegate?.finishedAddingStocks(result: P2O_ARR)
                }
                
            } else {
                self.delegate?.finishedAddingStocks(result: nil)
            }
        }).resume()
    }
    
}
