//
//  AddStockViewController.swift
//  Stoxxx
//
//  Created by Nickita on 15/5/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseDatabase

struct AddStockReceiver {
    
    static var calledUIViewController: MainUIViewController?
}

class AddStockViewController: UIViewController, AddStockPerformerDelegate {
    
    @IBOutlet weak var addStockButton: UIButton!
    
    @IBOutlet weak var addStockInput: UITextField!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let realm = try! Realm()
    
    var ref: DatabaseReference!
    
    var addStockPerformer: AddStockPerformer?
    
    override func viewDidLoad() {
        loadingIndicator.isHidden=true
        addStockPerformer = AddStockPerformer(delegate:self)
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func finishedAddingStocks(result: [String]?) {
        loadingMode(beforeLoad: false)
        guard result != nil else {
            showMyAlert(target: self, title: AlertValues.alertTitle, description: AlertValues.alertDescriptionCouldNotFindStock, buttonText: AlertValues.alertButtonText)
            return
        }
        notifyMainViewAboutChanges()
        showMyAlert(target: self, title: AlertValues.alertSuccessTitle, description:
            AlertValues.createDescriptionAddedSuccessfuly(companyName: (result?[1])!, symbol: (result?[0])!),
                    buttonText: AlertValues.alertButtonText)
    }
    
    @IBAction func addStocksButtonPressed(_ sender:Any) {
        if let text=addStockInput.text, !text.isEmpty {
            loadingMode(beforeLoad: true)
            let stockName=addStockInput.text!.uppercased().replacingOccurrences(of:" ", with:"", options:NSString.CompareOptions.literal, range:nil)
            if RealmLoader.getSetFromRealm().contains(stockName) {
                showMyAlert(target: self, title: AlertValues.alertTitle, description: AlertValues.alertDescriptionStockAlreadyExists, buttonText: AlertValues.alertButtonText)
                loadingMode(beforeLoad: false)
                return
            }
            addStockPerformer?.addStock(stockSymbol: stockName)
        } else {
            showMyAlert(target: self, title: AlertValues.alertTitle, description: AlertValues.alertDescriptionCheckInput, buttonText: AlertValues.alertButtonText)
            loadingMode(beforeLoad: false)
        }
    }
    
    func notifyMainViewAboutChanges(){
        AddStockReceiver.calledUIViewController?.loadStocks()
        AddStockReceiver.calledUIViewController?.stockLoader?.loadStockData()
    }
    
    func loadingMode(beforeLoad:Bool){
        DispatchQueue.main.async {
            if beforeLoad {
                self.loadingIndicator.isHidden=false
                self.addStockInput.endEditing(true)
                self.addStockButton.isEnabled=false
                self.addStockInput.isEnabled=false
            }else{
                self.loadingIndicator.isHidden=true
                self.addStockButton.isEnabled=true
                self.addStockInput.isEnabled=true
            }
        }
        
    }
    
}
