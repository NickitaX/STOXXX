//
//  StocksTableViewController.swift
//  Stoxxx
//
//  Created by Nickita on 10/5/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit
import QuartzCore
import RealmSwift
import DGElasticPullToRefresh
import SwiftVideoBackground
import Reactions
import Firebase
import FirebaseDatabase

class MainUIViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, StockLoaderDelegate, NewsLoaderDelegate {
    
    @IBOutlet weak var stocksTableView: UITableView!
    
    @IBOutlet weak var pagerIndicator: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var backgroundVideo: BackgroundVideo!
    
    var stocks: [StockModel]=[]
    
    var selectedIndex: IndexPath?
    
    var stockLoader: StockLoader?
    
    var newsLoader: NewsLoader?
    
    var firebaseDatabase: DatabaseReference!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureFirebase()
        
        loadStocks()
        
        startStocks()
        
        startNews()
        
        setUpVideoBackground()
        
        configureTablewView()
        
    }
    
    func configureTablewView() {
        stocksTableView.showsVerticalScrollIndicator=false
        setUpTablePullToRefresh()
        
    }
    
    func configureFirebase() {
        firebaseDatabase=Database.database().reference()
    }
    
    func startNews() {
        newsLoader=NewsLoader(delegate:self)
        newsLoader!.loadNewsData()
    }
    
    func startStocks() {
        stockLoader=StockLoader(delegate:self)
        stockLoader!.loadStockData()
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    func setUpVideoBackground() {
        backgroundVideo.createBackgroundVideo(name:ResourcesValues.mediaBackgroundVideo, type:ResourcesValues.mediaBackgroundVideo_format, alpha:0.5)
    }
    
    func setUpTablePullToRefresh() {
        let loadingView=DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor=MyColors.yellowColor
        stocksTableView.dg_addPullToRefreshWithActionHandler({[weak self]()->Void in
            self?.stockLoader?.loadStockData()
            self?.stocksTableView.dg_stopLoading()
            }, loadingView:loadingView)
        stocksTableView.dg_setPullToRefreshFillColor(MyColors.greyColor)
        stocksTableView.dg_setPullToRefreshBackgroundColor(stocksTableView.backgroundColor!)
    }
    
    func loadStocks() {
        
        stocks.removeAll()
        stocks = RealmLoader.downloadStocksFromRealm()
        
        DispatchQueue.main.async {
            self.scrollView.reloadInputViews()
        }
        
    }
    
    @IBAction func addStockButtonPressed(_ sender:Any) {
        //Pass object of self as called controller
        AddStockReceiver.calledUIViewController=self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat=scrollView.frame.width
        let currentPage: CGFloat=floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        self.pagerIndicator.currentPage=Int(currentPage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stocks.count
    }
    
    @IBAction func chartButtonClicked(_ sender:Any) {
        ChartReceiver.passedStock=stocks[(selectedIndex?.row)!].stockSymbol
    }
    
    @IBAction func predictionButtonClicked(_ sender:Any) {
        PredictionReceiver.passedStock=stocks[(selectedIndex?.row)!].stockSymbol
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Hide/reveal StockCell menu when selected/unselected
        if selectedIndex==indexPath {
            selectedIndex=nil
        } else {
            selectedIndex=indexPath
        }
        if let cell = stocksTableView.cellForRow(at: indexPath) as? StockCell{
            if selectedIndex==indexPath {
                cell.stockMenu.isHidden = false
            }else{
                cell.stockMenu.isHidden = true
            }
        }
        stocksTableView.beginUpdates()
        stocksTableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedIndex=selectedIndex, selectedIndex==indexPath {
            return 132
        }
        return 96
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle==UITableViewCellEditingStyle.delete {
            stocksTableView.beginUpdates()
            let stockToDeleteName=stocks[indexPath.row].stockSymbol
            RealmLoader.deleteStockFromRealm(query: "stockSymbol = '\(stockToDeleteName)'")
            stocks.remove(at:indexPath.row)
            stocksTableView.deleteRows(at:[indexPath], with:.fade)
            stocksTableView.endUpdates()
        }
    }
    
    func processCell(indexPath: IndexPath) -> StockCell {
        let cell: StockCell=self.stocksTableView.dequeueReusableCell(withIdentifier:"stockCell2")as!StockCell
        let stock=stocks[indexPath.row]
        cell.selectionStyle = .none
        cell.stockCell.text=stock.stockSymbol
        if stocks[indexPath.row].stockPrice=="" {
            cell.stockPrice.text=""
            cell.stockChange.text=""
        } else {
            cell.loadingIndicator.stopAnimating()
            cell.stockPrice.text=stocks[indexPath.row].stockPrice
            cell.stockName.text=stocks[indexPath.row].stockCompanyName
            if(stocks[indexPath.row].stockChange.contains("-")) {
                cell.stockChange.backgroundColor=MyColors.redColor
            } else {
                cell.stockChange.backgroundColor=MyColors.greenColor
            }
            cell.stockChange.text=" "+stocks[indexPath.row].stockChange+" "
            
        }
        cell.stockChange.layer.masksToBounds=true
        cell.stockChange.layer.cornerRadius=5
        cell.reactionsSummary.config=ReactionSummaryConfig {
            $0.isAggregated=false
        }
        loadReactionsFromFirebase(cell:cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return processCell(indexPath: indexPath)
    }
    
    func loadReactionsFromFirebase(cell: StockCell) {
        let stockName=cell.stockCell.text!
        firebaseDatabase.child(FirebaseValues.firebaseRootRef).child(FirebaseValues.firebaseReactionsRef).observeSingleEvent(of:.value, with: {(snapshot)in
            if !snapshot.hasChild(stockName) {
                let stockReactionSet=[0, 0, 0, 0, 0, 0] //[like,love,haha,wow,sad,angry]
                self.firebaseDatabase.child(FirebaseValues.firebaseRootRef).child(FirebaseValues.firebaseReactionsRef).child(stockName).setValue(stockReactionSet, withCompletionBlock: {(error, _)in
                    if error != nil {
                        showMyAlert(target: self, title: AlertValues.alertTitle, description: AlertValues.alertDescriptionCouldNotConnect, buttonText: AlertValues.alertButtonText)
                    } else {
                        self.firebaseDatabase.child(FirebaseValues.firebaseRootRef).child(FirebaseValues.firebaseReactionsRef).observeSingleEvent(of:.value, with: {(snapshot_)in
                            let reactionStocks=snapshot_.value as?NSDictionary
                            self.loadReactionsFromSnapshot(reactions:reactionStocks!, cell:cell)
                        })
                    }
                })
            } else {
                let reactionStocks=snapshot.value as?NSDictionary
                self.loadReactionsFromSnapshot(reactions:reactionStocks!, cell:cell)
            }
        })
    }
    
    func loadReactionsFromSnapshot(reactions: NSDictionary, cell: StockCell) {
        let stockName=cell.stockCell.text!
        let reactionList=reactions[stockName] as? [Int]
        cell.reactionsSummary.reactions.removeAll()
        
        let like=Int((reactionList?[0])!)
        
        for _ in 0..<like {
            cell.reactionsSummary.reactions.append(Reaction.facebook.like)
        }
        
        let love=Int((reactionList?[1])!)
        
        for _ in 0..<love {
            
            cell.reactionsSummary.reactions.append(Reaction.facebook.love)
        }
        
        let haha=Int((reactionList?[2])!)
        
        for _ in 0..<haha {
            
            cell.reactionsSummary.reactions.append(Reaction.facebook.haha)
        }
        
        let wow=Int((reactionList?[3])!)
        
        for _ in 0..<wow {
            
            cell.reactionsSummary.reactions.append(Reaction.facebook.wow)
        }
        
        let sad=Int((reactionList?[4])!)
        
        for _ in 0..<sad {
            
            cell.reactionsSummary.reactions.append(Reaction.facebook.sad)
        }
        
        let angry=Int((reactionList?[5])!)
        
        for _ in 0..<angry {
            
            cell.reactionsSummary.reactions.append(Reaction.facebook.angry)
        }
        
    }
    
    func receiveStockData(data: [StockModel]) {
        
        self.stocks=data
        
        DispatchQueue.main.async {
            
            self.stocksTableView.reloadData()
        }
        
    }
    
    func receiveNewsData(data: [NewsModel]) {
        
        var newsViews: [NewsView]=[]
        
        let newsOne=NewsView(frame:CGRect(x:0, y:0, width:scrollView.frame.width, height:scrollView.frame.height))
        
        let newsTwo=NewsView(frame:CGRect(x:scrollView.frame.width, y:0, width:scrollView.frame.width, height:scrollView.frame.height))
        
        let newsThree=NewsView(frame:CGRect(x:scrollView.frame.width*2, y:0, width:scrollView.frame.width, height:scrollView.frame.height))
        
        newsViews.append(newsOne)
        
        newsViews.append(newsTwo)
        
        newsViews.append(newsThree)
        
        self.scrollView.contentSize=CGSize(width:self.scrollView.frame.width*3, height:self.scrollView.frame.height)
        
        self.scrollView.delegate=self
        
        self.scrollView.showsHorizontalScrollIndicator=false
        
        self.scrollView.isPagingEnabled=true
        
        self.scrollView.contentSize=CGSize(width:self.scrollView.frame.size.width*CGFloat(newsViews.count), height:self.scrollView.frame.size.height)
        
        for index in 0..<newsViews.count {
            
            let news=newsViews[index]
            
            news.loadingIndicator.startAnimating()
            
            let newsData=data[index]
            
            let imageData=try?Data(contentsOf:newsData.newsImageURI!)
            
            DispatchQueue.main.async {
                
                news.newsImageView.image=UIImage(data:imageData!)
                
                news.newsHeaderLabel.text=newsData.newsHeader
                
                news.journalSourceButton.titleLabel?.text=NewsUrlAPIHeaders.sourceTitle
                
                news.url=newsData.newsArticleURL
                
                news.loadingIndicator.isHidden=true
                
                news.setNeedsDisplay()
                
                self.scrollView.addSubview(news)
                self.scrollView.reloadInputViews()
            }
            
        }
        
    }
    
}
