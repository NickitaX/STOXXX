//
//  StockCell.swift
//  Stoxxx
//
//  Created by Nickita on 13/6/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit
import Reactions

class StockCell: UITableViewCell {
    
    @IBOutlet weak var stockCell: UILabel!
    
    @IBOutlet weak var stockPrice: UILabel!
    
    @IBOutlet weak var stockChange: UILabel!
    
    @IBOutlet weak var stockMenu: UIView!
    
    @IBOutlet weak var stockName: UILabel!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var reactionsSummary: ReactionSummary!
    
}
