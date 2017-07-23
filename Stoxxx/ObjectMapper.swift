//
//  RealmToObject.swift
//  Stoxxx
//
//  Created by Nickita on 8/6/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit
import RealmSwift

func realmToObject(realmObject: StockModelRealm) -> StockModel {
    let stockObject = StockModel()
    stockObject.stockSymbol=realmObject.stockSymbol
    stockObject.stockChange=realmObject.stockChange
    stockObject.stockPrice=realmObject.stockPrice
    stockObject.stockCompanyName=realmObject.stockCompanyName
    stockObject.stockDaysLow=realmObject.stockDaysLow
    stockObject.stockDaysHigh=realmObject.stockDaysHigh
    stockObject.stock50DaysMA=realmObject.stock50DaysMA
    stockObject.stockVolume=realmObject.stockVolume
    stockObject.stockEPSNext=realmObject.stockEPSNext
    stockObject.stockEPSCurrent=realmObject.stockEPSCurrent
    stockObject.stockEPS=realmObject.stockEPS
    stockObject.stockAverageDailyVolume=realmObject.stockAverageDailyVolume
    stockObject.stockRevenue=realmObject.stockRevenue
    return stockObject
}

func objectToRealm(stockObject: StockModel) -> StockModelRealm {
    let realmObject = StockModelRealm()
    realmObject.stockSymbol = stockObject.stockSymbol
    realmObject.stockChange = stockObject.stockChange
    realmObject.stockPrice = stockObject.stockPrice
    realmObject.stockCompanyName = stockObject.stockCompanyName
    realmObject.stockDaysLow = stockObject.stockDaysLow
    realmObject.stockDaysHigh = stockObject.stockDaysHigh
    realmObject.stock50DaysMA = stockObject.stock50DaysMA
    realmObject.stockVolume = stockObject.stockVolume
    realmObject.stockEPSNext = stockObject.stockEPSNext
    realmObject.stockEPSCurrent = stockObject.stockEPSCurrent
    realmObject.stockEPS = stockObject.stockEPS
    realmObject.stockAverageDailyVolume = stockObject.stockAverageDailyVolume
    realmObject.stockRevenue = stockObject.stockRevenue
    return realmObject
}
