//
//  NewsView.swift
//  Stoxxx
//
//  Created by Nickita on 13/5/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit

class NewsView: UIView {

    @IBOutlet weak var newsHeaderLabel: UILabel!

    @IBOutlet weak var newsImageView: UIImageView!

    @IBOutlet weak var journalSourceButton: UIButton!

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var view: UIView!

    var url: URL!

    var nibName = "NewsView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    @IBAction func journalSourceButtonClicked(_ sender: Any) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view!
    }

}
