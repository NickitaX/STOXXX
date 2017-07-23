//
//  RealmLoader.swift
//  Stoxxx
//
//  Created by Nickita on 9/6/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit
import RealmSwift

struct RealmLoader {
    static func downloadStocksFromRealm() -> [StockModel] {
        var stocks: [StockModel] = []
        let realm=try!Realm()
        let savedStocks=realm.objects(StockModelRealm.self)
        for realmStock in savedStocks {
            stocks.append(realmToObject(realmObject: realmStock))
        }
        return stocks
    }
    
    static func deleteStockFromRealm(query: String) {
        let realm=try!Realm()
        let stockToDelete=realm.objects(StockModelRealm.self).filter(query)
        try!realm.write {
            realm.delete(stockToDelete)
        }
    }
    
    static func addStockToRealm(stock: StockModel) {
        let realm=try!Realm()
        try!realm.write {
            realm.add(objectToRealm(stockObject: stock))
        }
        
    }
    
    //Set structure used for better performance when data is unique
    static func getSetFromRealm()->Set<String>{
        var stocks = Set<String>()
        let realm=try!Realm()
        let savedStocks=realm.objects(StockModelRealm.self)
        for realmStock in savedStocks {
            stocks.insert(realmToObject(realmObject: realmStock).stockSymbol)
        }
        return stocks
    }
}
