//
//  ProfileTableViewCell.swift
//  NPCEO
//
//  Created by Artem Mazheykin on 05.03.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import UIKit

class ProfileTableViewNameOrganizationOrEmailCell: UITableViewCell {

    @IBOutlet weak var nameOrganizationOrEmailTextField: UITextField!
    
    @IBOutlet weak var changeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
