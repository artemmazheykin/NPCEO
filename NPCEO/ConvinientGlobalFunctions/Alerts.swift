//
//  Alerts.swift
//  NPCEO
//
//  Created by Artem Mazheykin on 04.03.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import UIKit


class Alerts{

    class func specialAlert(viewcontroller: UIViewController, title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        viewcontroller.present(alert, animated: true, completion: nil)
    }
  
}
