//
//  Fabric.swift
//  NPCEO
//
//  Created by  Artem Mazheykin on 12.03.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import UIKit

enum VCIdentifiers:String{
    case userProfileViewController = "UserProfileViewController",
    popupNewUser = "PopupNewUser",
    popupPhoneCall = "PopupPhoneCall",
    burnerCollectionViewController = "BurnerCollectionViewController",
    navigationController = "NavigationController"
}

class FabricImpl: Fabric{
    
    private var storyboard: UIStoryboard!
    private var data: RealtimeDatabase!
    private var navigator: Navigator!

    init() {
        let navigator = NavigatorImpl(fabric: self)
        self.navigator = navigator
        self.storyboard = UIStoryboard.init(name: "Master", bundle: Bundle.main)
        initDAL()
        navigator.showFirstViewController()
    }
    
    func initDAL(){
        data = RealtimeDatabase.shared
    }
    
    func mainViewController() -> UIViewController{
        
        if let navc = storyboard.instantiateViewController(withIdentifier: VCIdentifiers.navigationController.rawValue) as? UINavigationController{
            if navc.viewControllers.count > 0{
                if let mainViewController = navc.viewControllers[0] as? MainViewController{
                    mainViewController.navigator = navigator
                }
            }
            return navc
        }
        return UIViewController()
        
    }

    func createVC(name: VCIdentifiers) -> UIViewController {
        let vc = storyboard.instantiateViewController(withIdentifier: name.rawValue)
        return vc
    }
}
