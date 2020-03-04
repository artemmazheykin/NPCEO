//
//  UserModel.swift
//  NPCEO
//
//  Created by  Artem Mazheykin on 02.03.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import Foundation

class UserModel{
    
    let displayName: String?
    let email: String?
    let isEmailVerified: Bool
    let uid: String
    
    init(displayName: String, email: String, isEmailVerified: Bool, uid: String) {
        self.displayName = displayName
        self.email = email
        self.isEmailVerified = isEmailVerified
        self.uid = uid
    }
    

    
}
