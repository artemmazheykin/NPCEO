//
//  Navigator.swift
//  NPCEO
//
//  Created by  Artem Mazheykin on 13.03.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import UIKit

class NavigatorImpl: Navigator{
    private weak var fabric: Fabric!
    var router = RouterImpl()
    
    init(fabric: Fabric){
        self.fabric = fabric
    }

    func showFirstViewController() {
        let vc = fabric.mainViewController()
        _ = router.presentViewController(nextViewController: vc)

    }
    
    
}
