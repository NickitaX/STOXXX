//
//  NewsLoader.swift
//  Stoxxx
//
//  Created by Nickita on 27/5/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit

protocol NewsLoaderDelegate: class {
    func receiveNewsData(data: [NewsModel])
}

class NewsLoader: NSObject {
    var newsList: [NewsModel] = []
    weak var delegate: NewsLoaderDelegate?

    init(delegate: NewsLoaderDelegate) {
        self.delegate = delegate
    }

    func loadNewsData() {

        let url = URL(string: APIValues.newsAPIRawLink)

        URLSession.shared.dataTask(with:url!, completionHandler: {(data, _, error) in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                let articles = json?[NewsUrlAPIHeaders.newsArticlesHeader] as? [[String: Any]]
                for i in 0..<3 {
                    let news = NewsModel()
                    
                    news.newsImageURI=URL(string:((articles?[i])?[NewsUrlAPIHeaders.imageUrlHeader]as!String?)!)
                    news.newsArticleURL=URL(string:((articles?[i])?[NewsUrlAPIHeaders.newsUrlLinkHeader]as!String?)!)
                    news.newsHeader=((articles?[i])?[NewsUrlAPIHeaders.titleHeader]as!String?)!
                    self.newsList.append(news)
                }
                self.delegate?.receiveNewsData(data: self.newsList)
            } catch let error as NSError {
                print(error)
            }
        }).resume()
    }

}
