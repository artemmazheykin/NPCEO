//
//  Alerts.swift
//  NPCEO
//
//  Created by Artem Mazheykin on 04.03.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import UIKit


class Spinners{

    class func spinnerStart(spinner: UIActivityIndicatorView){
        DispatchQueue.main.async {
            spinner.startAnimating()
        }
    }
    
    class func spinnerStop(spinner: UIActivityIndicatorView){
        DispatchQueue.main.async {
            spinner.stopAnimating()
        }
    }

}
