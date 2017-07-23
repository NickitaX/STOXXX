//
//  Alert.swift
//  Stoxxx
//
//  Created by Nickita on 8/6/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import UIKit

func showMyAlert(target: UIViewController, title: String, description: String, buttonText: String) {
    let alert = UIAlertController(title: title, message: description, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.default, handler: nil))
    target.present(alert, animated: true, completion: nil)

}
