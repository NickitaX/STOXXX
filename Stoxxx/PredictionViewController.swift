//
//  PredictionViewController.swift
//  Stoxxx
//
//  Created by Nickita on 20/5/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit
import SwiftVideoBackground

struct PredictionReceiver {
    static var passedStock = ""
}

class PredictionViewController: UIViewController, PredictionLoaderDelegate {
    
    @IBOutlet var backgroundVideo: BackgroundVideo!
    
    @IBOutlet weak var EPSNextImage: UIImageView!
    
    @IBOutlet weak var EPSCurrentImage: UIImageView!
    
    @IBOutlet weak var EPSNextQuarterImage: UIImageView!
    
    @IBOutlet weak var EPSCurrentLabel: UILabel!
    
    @IBOutlet weak var EPSNextLabel: UILabel!
    
    @IBOutlet weak var EPSNextQuarterLabel: UILabel!
    
    @IBOutlet weak var currentLoadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var nextLoadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var nextQuarterLoadingIndicator: UIActivityIndicatorView!
    
    var predictionLoader: PredictionLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        predictionLoader = PredictionLoader(delegate:self)
        predictionLoader?.loadStockPredictionData(stockname: PredictionReceiver.passedStock)
        transformCircles()
        backgroundVideo.createBackgroundVideo(name: ResourcesValues.streetBackgroundVideo, type: ResourcesValues.streetBackgroundVideo_format, alpha: 0.5)
    }
    
    func transformCircles() {
        EPSNextImage.layer.cornerRadius = EPSNextImage.frame.size.width/2
        EPSNextImage.clipsToBounds = true
        
        EPSNextImage.layer.borderColor = UIColor.white.cgColor
        EPSNextImage.layer.borderWidth = 5.0
        
        EPSCurrentImage.layer.cornerRadius = EPSCurrentImage.frame.size.width/2
        EPSCurrentImage.clipsToBounds = true
        
        EPSCurrentImage.layer.borderColor = UIColor.white.cgColor
        EPSCurrentImage.layer.borderWidth = 5.0
        
        EPSNextQuarterImage.layer.cornerRadius = EPSNextQuarterImage.frame.size.width/2
        EPSNextQuarterImage.clipsToBounds = true
        
        EPSNextQuarterImage.layer.borderColor = UIColor.white.cgColor
        EPSNextQuarterImage.layer.borderWidth = 5.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) { }
    
    
    func receivePredictionData(data: PredictionModel) {
        DispatchQueue.main.async {
            self.EPSCurrentLabel.text = "$" + data.currentYearEPS
            self.EPSNextLabel.text = "$" + data.nextYearEPS
            self.EPSNextQuarterLabel.text = "$" + data.targetYearPrice
            self.nextLoadingIndicator.stopAnimating()
            self.currentLoadingIndicator.stopAnimating()
            self.nextQuarterLoadingIndicator.stopAnimating()
        }
    }
    
}
