//
//  StockModel.swift
//  Stoxxx
//
//  Created by Nickita on 8/6/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit
import RealmSwift

//Realm objects have issue being instanciated on one thread and used on another. Therefore, plain NSObject with same properties has been created to represent Realm object when required using realmToObject converter

class StockModel: NSObject {
    dynamic var stockSymbol=""
    dynamic var stockChange=""
    dynamic var stockPrice=""
    dynamic var stockCompanyName=""
    dynamic var stockDaysLow=""
    dynamic var stockDaysHigh=""
    dynamic var stock50DaysMA=""
    dynamic var stockVolume=""
    dynamic var stockEPSNext=""
    dynamic var stockEPSCurrent=""
    dynamic var stockEPS=""
    dynamic var stockAverageDailyVolume=""
    dynamic var stockRevenue=""
}

class StockModelRealm: Object {
    dynamic var stockSymbol=""
    dynamic var stockChange=""
    dynamic var stockPrice=""
    dynamic var stockCompanyName=""
    dynamic var stockDaysLow=""
    dynamic var stockDaysHigh=""
    dynamic var stock50DaysMA=""
    dynamic var stockVolume=""
    dynamic var stockEPSNext=""
    dynamic var stockEPSCurrent=""
    dynamic var stockEPS=""
    dynamic var stockAverageDailyVolume=""
    dynamic var stockRevenue=""
}
