//
//  StockLoader.swift
//  Stoxxx
//
//  Created by Nickita on 26/5/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit
import RealmSwift

protocol StockLoaderDelegate {
    func receiveStockData(data: [StockModel])
}

class StockLoader: NSObject {
    var stocks: [StockModel] = []
    var delegate: StockLoaderDelegate?

    init(delegate: StockLoaderDelegate) {
        self.delegate = delegate
    }

    func loadStockData() {
        stocks = RealmLoader.downloadStocksFromRealm()
        let stocksCount = stocks.count
        var stocksLoaded = 0
        for i in 0..<stocks.count {

            let stockSymbol = stocks[i].stockSymbol

            let url = URL(string: APIValues.createYahooFinanceURL(stockSymbol: stockSymbol, APIParams: APIValues.yahooStockChangeInPerCentParam+APIValues.yahooStockOpenPriceParam+APIValues.yahooStockNameParam))

            URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
                stocksLoaded += 1

                guard let data = data, error == nil else { return }
                let response = String(data: data, encoding: String.Encoding.utf8) as String!
                var P2O_ARR = (response?.components(separatedBy: ","))! as [String]

                self.stocks[i].stockPrice = P2O_ARR[1]

                self.stocks[i].stockChange = P2O_ARR[0].replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)

                self.stocks[i].stockCompanyName = P2O_ARR[2].replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)
                if (stocksLoaded == stocksCount) {
                    self.delegate?.receiveStockData(data: self.stocks)
                }

            }).resume()
        }

    }

}
