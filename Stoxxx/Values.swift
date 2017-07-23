//
//  Values.swift
//  Stoxxx
//
//  Created by Nickita on 9/6/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit

import UIKit

struct ResourcesValues {
    static var mediaBackgroundVideo = "media-background"
    static var mediaBackgroundVideo_format = "mp4"

    static var spaceBackgroundVideo = "space-background"
    static var spaceBackgroundVideo_format = "mp4"

    static var streetBackgroundVideo = "street-background"
    static var streetBackgroundVideo_format = "mp4"

    static var timesBackgroundVideo = "times-background"
    static var timesBackgroundVideo_format = "mp4"
}

struct DateValues {
    static var dateFormat = "MM-dd-yyyy"
}

struct ChartValues {

    static var stockInformationTableHeader = "Stock information:"

    static func createChartDescription(stockSymbol: String, startDate: String, endDate: String) -> String {
        return "Stock price of \(stockSymbol) between \(startDate) and \(endDate)"
    }

    static func createChartPerformanceDescription(stockSymbol: String) -> String {
        return "\(stockSymbol) Performance"
    }
}

struct ReactionsValues {

    static var like = "like"
    static var love = "love"
    static var haha = "haha"
    static var wow = "wow"
    static var sad = "sad"
    static var angry = "angry"
    static var error = "error"

    static func createReactedAlertText(stockSymbol: String, reacted: String) -> String {
        return "Reacted! Your reaction for \(stockSymbol) is \(reacted)"
    }
}

struct FirebaseValues {
    static var firebaseRootRef = "STOXXX"
    static var firebaseReactionsRef = "reactions"
}

struct StockInfoValues {
    static     var stockInfoTitles = ["Name: ", "Day's low: ", "Day's high: ", "50 day moving average: ", "Volume: ", "EPS estimate next year: ",
                                      "Ernings per share: ", "EAverage daily volume: ", "Revenue: "]
}

struct AlertValues {
    static var priceHeader = "Price: "
    static var alertTitle = "Opa!"
    static var alertSuccessTitle = "Success!"

    static var alertDescriptionCouldNotConnect = "Couldn't connect to database. Please, try again!"
    static var alertDescriptionMinimumTwoStocks = "To use Stoxxx Universe you need to have two or more stocks in portfolio"
    static var alertDescriptionCheckInput = "Please, check your input and try again."
    static var alertDescriptionCouldNotFindStock = "We couldn't find this stock symbol. Please, check your input and try again."
     static var alertDescriptionStockAlreadyExists = "This stock symbol is already in your portfolio"

    static var alertDescriptionCouldNotFetchData = "We couldn't fetch sufficient data for this stock symbol."

    static var alertButtonText = "OK"

    static func createDescriptionAddedSuccessfuly(companyName: String, symbol: String) -> String {
        return "\(companyName) with symbol \(symbol) has been successfuly added to your portfolio."

    }

}

struct APIValues {
    static var yahooStockNameParam = "n"
    static var yahooStockSymbolParam = "s"
    static var yahooStockChangeInPerCentParam = "p2"
    static var yahooStockOpenPriceParam = "o"
    static var yahooStockDaysLowParam = "g"
    static var yahooStockDaysHighParam = "h"
    static var yahooStock50DaysAvgParam = "m3"
    static var yahooStockVolumeParam = "v"
    static var yahooStockEPSNextYearParam = "e8"
    static var yahooStockEPS = "e"
    static var yahooStockTargetYearPrice = "t8"
    static var yahooStockAverageDaily = "a2"
    static var yahooStockRevenue = "s6"

    static var yahooStockEPSEstimateCurrentYear = "r6"
    static var yahooStockEPSEstimateNextYear = "r7"

    static func createYahooFinanceURL(stockSymbol: String, APIParams: String) -> String {
        return "http://finance.yahoo.com/d/quotes.csv?s=\(stockSymbol)&f=\(APIParams)"
    }

    static func createGoogleHistoricalURL(stockSymbol: String, startDate: String, endDate: String) -> String {
        return "http://www.google.com/finance/historical?q=\(stockSymbol)&startdate=\(startDate)&enddate=\(endDate)&output=csv"
    }

    static var newsAPIRawLink = "https://newsapi.org/v1/articles?source=business-insider&sortBy=top&apiKey=872c20b1c66847e2ba32732cc393e7a5"
}

struct NewsUrlAPIHeaders {
    static var newsArticlesHeader = "articles"
    static var newsUrlLinkHeader = "url"
    static var imageUrlHeader = "urlToImage"
    static var titleHeader = "title"
    static var sourceTitle = "BUSINESS INSIDER"

}

//API REFERENCE
//http://wern-ancheta.com/blog/2015/04/05/getting-started-with-the-yahoo-finance-api/
//    Pricing
//
//    a – ask
//    b – bid
//    b2 – ask (realtime)
//    b3 – bid (realtime)
//    p – previous close
//    o – open
//    Dividends
//
//    y – dividend yield
//    d – dividend per share
//    r1 – dividend pay date
//    q – ex-dividend date
//    Date
//
//    c1 – change
//    c – change & percentage change
//    c6 – change (realtime)
//    k2 – change percent
//    p2 – change in percent
//    d1 – last trade date
//    d2 – trade date
//    t1 – last trade time
//    Averages
//
//    c8 – after hours change
//    c3 – commission
//    g – day’s low
//    h – day’s high
//    k1 – last trade (realtime) with time
//    l – last trade (with time)
//    l1 – last trade (price only)
//    t8 – 1 yr target price
//    m5 – change from 200 day moving average
//    m6 – percent change from 200 day moving average
//    m7 – change from 50 day moving average
//    m8 – percent change from 50 day moving average
//    m3 – 50 day moving average
//    m4 – 200 day moving average
//    Misc
//
//    w1 – day’s value change
//    w4 – day’s value change (realtime)
//    p1 – price paid
//    m – day’s range
//    m2 – day’s range (realtime)
//    g1 – holding gain percent
//    g3 – annualized gain
//    g4 – holdings gain
//    g5 – holdings gain percent (realtime)
//    g6 – holdings gain (realtime)
//    t7 – ticker trend
//    t6 – trade links
//    i5 – order book (realtime)
//    l2 – high limit
//    l3 – low limit
//    v1 – holdings value
//    v7 – holdings value (realtime)
//    s6 – revenue
//    52 Week Pricing
//
//    k – 52 week high
//    j – 52 week low
//    j5 – change from 52 week low
//    k4 – change from 52 week high
//    j6 – percent change from 52 week low
//    k5 – percent change from 52 week high
//    w – 52 week range
//    Symbol Info
//
//    v – more info
//    j1 – market capitalization
//    j3 – market cap (realtime)
//    f6 – float shares
//    n – name
//    n4 – notes
//    s – symbol
//    s1 – shares owned
//    x – stock exchange
//    j2 – shares outstanding
//    Volume
//
//    v – volume
//    a5 – ask size
//    b6 – bid size
//    k3 – last trade size
//    a2 – average daily volume
//    Ratios
//
//    e – earnings per share
//    e7 – eps estimate current year
//    e8 – eps estimate next year
//    e9 – eps estimate next quarter
//    b4 – book value
//    j4 – EBITDA
//    p5 – price / sales
//    p6 – price / book
//    r – P/E ratio
//    r2 – P/E ratio (realtime)
//    r5 – PEG ratio
//    r6 – price / eps estimate current year
//    r7 – price /eps estimate next year
//    s7 – short ratio
