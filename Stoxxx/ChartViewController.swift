//
//  ChartViewController.swift
//  Stoxxx
//
//  Created by Nickita on 11/5/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit
import Charts
import SwiftVideoBackground
import Reactions
import Firebase
import FirebaseDatabase
import JDropDownAlert

struct ChartReceiver {
    static var passedStock = ""
}

class StockInfoCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!
}

class ChartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StockInfoLoaderDelegate, StockChartLoaderDelegate, ReactionFeedbackDelegate {

    var chartYEntries = [ChartDataEntry]()

    var startDate: String = ""

    var endDate: String = ""

    var stockInfo: [String] = []

    var stockInfoLoader: StockInfoLoader?

    var stockChartLoader: StockChartLoader?

    var ref: DatabaseReference!

    @IBOutlet weak var barChart: BarChartView!

    @IBOutlet weak var stockDescriptionTableView: UITableView!

    @IBOutlet var backgroundVideo: BackgroundVideo!

    @IBOutlet weak var reactionsSelector: ReactionSelector!

    @IBAction func unwindToMain(segue: UIStoryboardSegue) { }

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setUpVideoBackground()
        updateDate()
        loadChartData()
        loadTableData()
        setUpReactionsSelector()
        stockDescriptionTableView.delegate = self
        stockDescriptionTableView.dataSource = self
        stockDescriptionTableView.showsVerticalScrollIndicator = false
    }

    func setUpVideoBackground() {
        backgroundVideo.createBackgroundVideo(name: ResourcesValues.timesBackgroundVideo, type: ResourcesValues.timesBackgroundVideo_format, alpha: 0.5)
    }

    func reactionFeedbackDidChanged(_ feedback: ReactionFeedback?) {
        if feedback == nil {
            ref.child(FirebaseValues.firebaseRootRef).child(FirebaseValues.firebaseReactionsRef).observeSingleEvent(of: .value, with: { (snapshot) in

                guard let reactionStocks = snapshot.value as? NSDictionary else {
                    return
                }

                let stockName = ChartReceiver.passedStock

                var reactionList = reactionStocks[stockName] as? [Int]

                var reacted: String!

                guard let id = self.reactionsSelector.selectedReaction?.id as String? else {
                    return
                }

                switch id {

                case ReactionsValues.like:
                    reactionList?[0] = (reactionList?[0])! + 1
                    reacted = ReactionsValues.like
                case ReactionsValues.love:
                    reactionList?[1] = (reactionList?[1])! + 1
                    reacted = ReactionsValues.love
                case ReactionsValues.haha:
                    reactionList?[2] = (reactionList?[2])! + 1
                    reacted = ReactionsValues.haha
                case ReactionsValues.wow:
                    reactionList?[3] = (reactionList?[3])! + 1
                    reacted = ReactionsValues.wow
                case ReactionsValues.sad:
                    reactionList?[4] = (reactionList?[4])! + 1
                    reacted = ReactionsValues.sad
                case ReactionsValues.angry:
                    reactionList?[5] = (reactionList?[5])! + 1
                    reacted = ReactionsValues.angry
                default:
                    reacted = ReactionsValues.error
                }

                let alert = JDropDownAlert(position: .top, direction: .toLeft)
                alert.alertWith(ReactionsValues.createReactedAlertText(stockSymbol: stockName, reacted: reacted!))

                self.ref.child(FirebaseValues.firebaseRootRef).child(FirebaseValues.firebaseReactionsRef).child(stockName).setValue(reactionList)
                print(self.reactionsSelector.selectedReaction!.id)
            })
        }
    }

    func reactionDidChanged(_ sender: AnyObject) {
        print(reactionsSelector.selectedReaction ?? "N/A")
    }

    func setUpReactionsSelector() {
        reactionsSelector.reactions = Reaction.facebook.all

        reactionsSelector.feedbackDelegate = self

        reactionsSelector.addTarget(self, action: #selector(reactionDidChanged), for: .valueChanged)

    }

    func updateDate() {
        let date = Date()
        let formatter = DateFormatter()

        formatter.dateFormat = DateValues.dateFormat

        let userCalendar = NSCalendar.current

        let oneMonthAgo = userCalendar.date(byAdding: .day, value: -31, to: NSDate() as Date)

        endDate = formatter.string(from: date)

        startDate = formatter.string(from: oneMonthAgo!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func displayChart() {
        let chartDataSet = BarChartDataSet(values: chartYEntries, label: ChartValues.createChartDescription(stockSymbol: ChartReceiver.passedStock, startDate: startDate, endDate: endDate))

        chartDataSet.colors = [UIColor.white]
        chartDataSet.valueColors = [UIColor.white]
        chartDataSet.valueTextColor = UIColor.white
        let chartData = BarChartData(dataSets: [chartDataSet])

        barChart.chartDescription?.text = ChartValues.createChartPerformanceDescription(stockSymbol: ChartReceiver.passedStock)

        barChart.data = chartData

        barChart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)

    }

    func loadChartData() {
        let stockName = ChartReceiver.passedStock

        stockChartLoader = StockChartLoader(delegate:self, stock:stockName, startDate: startDate, endDate: endDate)
        stockChartLoader?.loadStockChartData()
    }

    func loadTableData() {
        let stockName = ChartReceiver.passedStock

        stockInfoLoader = StockInfoLoader(delegate:self, stock:stockName)
        stockInfoLoader!.loadStockInfoData()

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StockInfoCell = tableView.dequeueReusableCell(withIdentifier: "stockDescriptionCell", for: indexPath) as! StockInfoCell
        cell.selectionStyle = .none
        if(stockInfo.count>0) {
            cell.titleLabel.text = StockInfoValues.stockInfoTitles[indexPath.row]
            cell.descriptionLabel.text = stockInfo[indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ChartValues.stockInformationTableHeader
    }

    func receiveStockChartData(data: [String]) {
        loadingIndicator.stopAnimating()
        if data.count == 0 {
            showMyAlert(target: self, title: AlertValues.alertTitle, description: AlertValues.alertDescriptionCouldNotFetchData, buttonText: AlertValues.alertButtonText)
        } else {
            for i in 0..<data.count - 1 {
                var P20_ARR = (data[i].components(separatedBy: ",")) as [String]
                let day = String(i+1)
                let stock_high = P20_ARR[1]
                let chartEntry = BarChartDataEntry(x: Double(day)!, y: Double(stock_high)!)
                self.chartYEntries.append(chartEntry)
            }
            self.displayChart()
        }

    }

    func receiveStockInfoData(data: StockModel) {
        if data.stock50DaysMA == "" {
            showMyAlert(target: self, title: AlertValues.alertTitle, description: AlertValues.alertDescriptionCouldNotFetchData, buttonText: AlertValues.alertButtonText)
        } else {
            stockInfo.append(data.stockCompanyName)
            stockInfo.append(data.stockDaysLow)
            stockInfo.append(data.stockDaysHigh)
            stockInfo.append(data.stock50DaysMA)
            stockInfo.append(data.stockVolume)
            stockInfo.append(data.stockEPSNext)
            stockInfo.append(data.stockEPS)
            stockInfo.append(data.stockAverageDailyVolume)
            stockInfo.append(data.stockRevenue)
            DispatchQueue.main.async {
                self.stockDescriptionTableView.reloadData()
            }
        }

    }

}
