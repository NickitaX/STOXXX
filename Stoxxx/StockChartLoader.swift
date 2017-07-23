//
//  StockChartLoader.swift
//  Stoxxx
//
//  Created by Nickita on 27/5/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit

protocol StockChartLoaderDelegate: class {
    func receiveStockChartData(data: [String])
}

class StockChartLoader: NSObject {
    var stock, startDate, endDate: String
    weak var delegate: StockChartLoaderDelegate?

    init(delegate: StockChartLoaderDelegate, stock: String, startDate: String, endDate: String) {
        self.delegate = delegate
        self.stock = stock
        self.startDate = startDate
        self.endDate = endDate
    }

    func loadStockChartData() {

        let url = URL(string:APIValues.createGoogleHistoricalURL(stockSymbol:stock, startDate:startDate, endDate:endDate))

        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }

                let response = String(data: data, encoding: String.Encoding.utf8) as String!
                var collection_response = (response?.components(separatedBy: "\n"))! as [String]
                collection_response.remove(at: 0) //Remove header
                self.delegate?.receiveStockChartData(data: collection_response)

        }).resume()
    }

}
