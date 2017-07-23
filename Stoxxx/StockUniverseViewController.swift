//
//  StockUniverseViewController.swift
//  Stoxxx
//
//  Created by Nickita on 4/6/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit
import Hexacon
import RealmSwift
import SwiftVideoBackground
import JDropDownAlert

class StockUniverseViewController: UIViewController, StockLoaderDelegate {

    @IBOutlet weak var closeButton: UIButton!

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var stockLoader: StockLoader?

    var dataArray = [UniverseItemView]()

    var stocks: [StockModel] = []

    @IBAction func unwindToMain(segue: UIStoryboardSegue) { }

    private lazy var hexagonalView: HexagonalView = { [unowned self] in
        let view = HexagonalView(frame: self.view.bounds)
        view.hexagonalDataSource = self
        view.hexagonalDelegate = self
        return view
        }()

    override func viewDidLoad() {

        super.viewDidLoad()

        startStockLoader()

        configureMainView()

        configureHEXView()

        startVideoBackground()

        alignViews()

    }

    func alignViews() {
        view.addSubview(hexagonalView)
        view.bringSubview(toFront: closeButton)
        view.bringSubview(toFront: loadingIndicator)
    }

    func startVideoBackground() {
        let video_view = BackgroundVideo(frame: self.view.bounds)
        video_view.createBackgroundVideo(name: ResourcesValues.spaceBackgroundVideo, type: ResourcesValues.spaceBackgroundVideo_format, alpha: 0.5)
        view.addSubview(video_view)
        view.sendSubview(toBack: video_view)
    }

    func configureMainView() {
        view.backgroundColor = MyColors.hexColor
    }

    func configureHEXView() {
        hexagonalView.itemAppearance = HexagonalItemViewAppearance(

            needToConfigureItem: false,
            itemSize: 80,
            itemSpacing: 50,
            itemBorderWidth: 5,
            itemBorderColor: UIColor.gray,

            animationType: .Spiral,
            animationDuration: 0.2)
    }

    func startStockLoader() {
        stockLoader = StockLoader(delegate:self)

        stockLoader!.loadStockData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func receiveStockData(data: [StockModel]) {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            if data.count <= 1 {
                showMyAlert(target: self, title: AlertValues.alertTitle, description: AlertValues.alertDescriptionMinimumTwoStocks, buttonText: AlertValues.alertButtonText)
            }
            for i in 0..<data.count {

                self.stocks.append(data[i])

                let u = UniverseItemView(frame: CGRect(x:0, y:0, width:250, height:250))

                u.stockNameLabel.text = data[i].stockSymbol
                if(data[i].stockChange.contains("-")) {

                    u.circleBackground.backgroundColor = MyColors.redColor
                } else {
                    u.circleBackground.backgroundColor = MyColors.greenColor
                }
                self.dataArray.append(u)
            }
            self.hexagonalView.reloadData()
        }
    }

}

extension StockUniverseViewController: HexagonalViewDataSource {

    func hexagonalView(hexagonalView: HexagonalView, viewForIndex index: Int) -> UIView? {
        return dataArray[index]
    }

    func numberOfItemInHexagonalView(hexagonalView: HexagonalView) -> Int {
        print(dataArray.count)
        return dataArray.count - 1
    }
}

extension StockUniverseViewController: HexagonalViewDelegate {

    func hexagonalView(hexagonalView: HexagonalView, didSelectItemAtIndex index: Int) {
        let alert = JDropDownAlert(position: .top, direction: .toLeft)
        alert.alertWith(stocks[index].stockSymbol, message: AlertValues.priceHeader + stocks[index].stockPrice)
    }

}
