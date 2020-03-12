//
//  AppDelegate.swift
//  NPCEO
//
//  Created by Artem Mazheykin on 21.02.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var fabric: Fabric!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        fabric = FabricImpl()
        
        // Override point for customization after application launch.
        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .clear
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = true
        Thread.sleep(forTimeInterval: 3.0)
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        if let navVC = window?.rootViewController as? UINavigationController, let mainVC = navVC.viewControllers.first as? MainViewController{
            
            mainVC.checkState { user in
                
                for (i,vc) in navVC.viewControllers.enumerated(){
                    if i == 1{
                        if let profilevc = vc as? UserProfileViewController{
                            profilevc.isEmailVerified = user.isEmailVerified
                            profilevc.profileTableview.reloadSections(IndexSet(integer: 1), with: .automatic)
                        }
                    }
                }
                
//                for (i,vc) in navVC.viewControllers.enumerated(){
//                    if i == 1{
//                        if let profilevc = vc as? UserProfileViewController{
//                            profilevc.emailCell.changeButton.isHidden = true
//                            let constrs = profilevc.emailCell.contentView.constraints
//                            for constr in constrs{
//                                if constr.identifier == "trailingSpace"{
//                                    constr.constant = 0
//                                }
//                            }
//                        }
//                    }
//                }
            }
        }
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

