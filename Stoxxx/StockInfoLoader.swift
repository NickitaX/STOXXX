//
//  StockInfoLoader.swift
//  Stoxxx
//
//  Created by Nickita on 27/5/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit

protocol StockInfoLoaderDelegate {
    func receiveStockInfoData(data: StockModel)
}

class StockInfoLoader: NSObject {
    var stockToFind: String
    var delegate: StockInfoLoaderDelegate?

    init(delegate: StockInfoLoaderDelegate, stock: String) {
        self.delegate = delegate
        self.stockToFind = stock
    }

    func loadStockInfoData() {

        let stock = StockModel()

        //    n – name
        //    g – day’s low
        //    h – day’s high
        //    m3 – 50 day moving average
        //    v – volume
        //    e8 – eps estimate next year
        //    e – earnings per share
        //    a2 – average daily volume
        //    s6 – revenue

        let url = URL(string: APIValues.createYahooFinanceURL(stockSymbol: stockToFind, APIParams:APIValues.yahooStockNameParam+APIValues.yahooStockDaysLowParam+APIValues.yahooStockDaysHighParam+APIValues.yahooStock50DaysAvgParam+APIValues.yahooStockVolumeParam+APIValues.yahooStockEPSNextYearParam+APIValues.yahooStockEPS+APIValues.yahooStockAverageDaily+APIValues.yahooStockRevenue ))

        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            let response = String(data: data, encoding: String.Encoding.utf8) as String!
            var P2O_ARR = (response?.components(separatedBy: ","))! as [String]

            stock.stockCompanyName = P2O_ARR[0]
            stock.stockDaysLow = P2O_ARR[1]
            stock.stockDaysHigh = P2O_ARR[2]
            stock.stock50DaysMA = P2O_ARR[3]
            stock.stockVolume = P2O_ARR[4]
            stock.stockEPSNext = P2O_ARR[5]
            stock.stockEPS = P2O_ARR[6]
            stock.stockAverageDailyVolume = P2O_ARR[7]
            stock.stockRevenue = P2O_ARR[8]

            self.delegate?.receiveStockInfoData(data: stock)

        }).resume()
    }
}
