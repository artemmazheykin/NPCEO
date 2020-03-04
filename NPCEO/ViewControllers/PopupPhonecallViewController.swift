//
//  PopupPhonecallViewController.swift
//  NPCEO
//
//  Created by  Artem Mazheykin on 01.03.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import UIKit

class PopupPhonecallViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func techUnitDidTapped(_ sender: UIButton) {
        
        guard let number = URL(string: "tel://" + "84953556829") else { return }
        UIApplication.shared.open(number)

    }

    @IBAction func accountantUnitDidTapped(_ sender: UIButton) {
        
        guard let number = URL(string: "tel://" + "84953556879") else { return }
        UIApplication.shared.open(number)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
