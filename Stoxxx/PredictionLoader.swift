//
//  PredictionLoader.swift
//  Stoxxx
//
//  Created by Nickita on 5/6/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit

protocol PredictionLoaderDelegate {
    func receivePredictionData(data: PredictionModel)
}

class PredictionLoader: NSObject {

    var delegate: PredictionLoaderDelegate?

    init(delegate: PredictionLoaderDelegate) {
        self.delegate = delegate
    }

    func loadStockPredictionData(stockname: String) {

        let stockName = stockname

        let url = URL(string: APIValues.createYahooFinanceURL(stockSymbol: stockName, APIParams: APIValues.yahooStockEPSEstimateCurrentYear+APIValues.yahooStockTargetYearPrice+APIValues.yahooStockEPSEstimateNextYear))
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            let response = String(data: data, encoding: String.Encoding.utf8) as String!
            
            let prediction = PredictionModel()
            
            var P2O_ARR = (response?.components(separatedBy: ","))! as [String]
            
            prediction.currentYearEPS = P2O_ARR[0]
            prediction.targetYearPrice = P2O_ARR[1]
            prediction.nextYearEPS = P2O_ARR[2].replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)

            self.delegate?.receivePredictionData(data: prediction)

        }).resume()
    }

}
