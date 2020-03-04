//
//  MainViewController.swift
//  NPCEO
//
//  Created by  Artem Mazheykin on 21.02.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import UIKit
import WebKit
import FrostedSidebar
import Firebase

class MainViewController: UIViewController, WKUIDelegate, FrostedSidebarDelegate, UIPopoverPresentationControllerDelegate {
    
    
    // You need to adopt a FUIAuthDelegate protocol to receive callback
    //    authUI.delegate = self
    
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let burgerButton = UIButton()
    let userInformationButton = UIButton()
    var currentUser: UserModel!
    var isSignInModeActive: Bool = false{
        didSet{
            if isSignInModeActive{
                signInView.isHidden = false
                userInformationButton.isEnabled = false
            }else{
                signInView.isHidden = true
                userInformationButton.isEnabled = true
            }
        }
    }
    
    var webView: WKWebView!
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 44))

    let image1:[UIImage] = [UIImage(named: "Icon-1024")!, UIImage(named: "internetIcon.jpeg")!]
    var burgerButtonDidTappedIsTapped: Bool = false
    var frostedSidebar: FrostedSidebar!
    var tappedBurgerIndex:Int = 0
    @IBOutlet weak var okSigninButton: UIButton!
    @IBOutlet weak var newUserButton: UIButton!
        
    
    //    override func loadView() {
    //        let webConfiguration = WKWebViewConfiguration()
    //        webView = WKWebView(frame: .zero, configuration: webConfiguration)
    //        webView.uiDelegate = self
    //        view = webView
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        label.numberOfLines = 2
        label.textAlignment = .center
        navigationItem.titleView = label

        if let user = Auth.auth().currentUser{
            currentUser = UserModel(displayName: user.displayName!, email: user.email!, isEmailVerified: user.isEmailVerified, uid: user.uid)
        }
        checkState()
        print("currentuser = \(currentUser)")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let imView = UIImageView(image: UIImage(named: "232639-frederika.jpg"))
        imView.frame = view.bounds
        imView.contentMode = .scaleAspectFill
        //        view.addSubview(imView)
        
        frostedSidebar = FrostedSidebar(itemImages: image1, colors: nil, selectionStyle: .none)
        frostedSidebar.delegate = self
        
        burgerButton.setImage(UIImage(named: "Hamburger-Menu")!, for: .normal)
        burgerButton.addTarget(self, action: #selector(burgerButtonDidTapped), for: .touchUpInside)
        let barBurgerButton = UIBarButtonItem(customView: burgerButton)
        self.navigationItem.leftBarButtonItem = barBurgerButton
        newUserButton.addTarget(self, action: #selector(newUserButtonDidTapped), for: .touchUpInside)
        
        userInformationButton.setImage(UIImage(named: "signInIcon")!, for: .normal)
        userInformationButton.addTarget(self, action: #selector(userInformationButtonDidTapped), for: .touchUpInside)
        let barUserInformationButton = UIBarButtonItem(customView: userInformationButton)
        self.navigationItem.rightBarButtonItem = barUserInformationButton

        //        burgerButton.translatesAutoresizingMaskIntoConstraints = false
        burgerButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        burgerButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        userInformationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        userInformationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        if let user = Auth.auth().currentUser{
            user.reload(completion: nil)
            
            print("user is signed in!!!")
            print("Auth.auth().currentUser.debugDescription = \(Auth.auth().currentUser.debugDescription)")
            print("Auth.auth().currentUser?.email = \(Auth.auth().currentUser?.email)")
            print("Auth.auth().currentUser?.isEmailVerified = \(Auth.auth().currentUser?.isEmailVerified)")
            print("Auth.auth().currentUser?.displayName = \(Auth.auth().currentUser?.displayName)")
            
            
        } else {
            // No user is signed in.
            // ...
        }
    }

    func checkState(){
        
        Spinners.spinnerStart(spinner: spinner)
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if let user = user{
                user.reload { (error) in
                    if let error = error{
                        self.navigationItem.title = ""
                        Alerts.specialAlert(viewcontroller: self, title: "Alert", message: error.localizedDescription)
                        Spinners.spinnerStop(spinner: self.spinner)
                        return
                    }
                    if user.isEmailVerified{
                        self.currentUser = UserModel(displayName: user.displayName!, email: user.email!, isEmailVerified: user.isEmailVerified, uid: user.uid)
                        self.label.text = "Здравствуйте, \(self.currentUser.displayName!)."
                        self.isSignInModeActive = false
                        Spinners.spinnerStop(spinner: self.spinner)
                    }else{
                        self.label.text = "Подтвердите адрес электронной почты"
                        self.isSignInModeActive = true
                        Spinners.spinnerStop(spinner: self.spinner)
                    }
                }
            }else{
                self.label.text = "Авторизируйтесь"
                Spinners.spinnerStop(spinner: self.spinner)
                self.isSignInModeActive = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle)
    }
    @IBAction func okSigninButtonDidTapped(_ sender: UIButton) {
        if emailTextfield.text == ""{
            Alerts.specialAlert(viewcontroller: self, title: "Внимание", message: "Введите адрес электронной почты")
        }else{
            if passwordTextfield.text == ""{
                Alerts.specialAlert(viewcontroller: self, title: "Внимание", message: "Введите пароль")
            }else{
                Spinners.spinnerStart(spinner: spinner)
                Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (result, error) in
                    if let error = error{
                        Alerts.specialAlert(viewcontroller: self, title: "Alert", message: error.localizedDescription){action in
                            DispatchQueue.main.async {
                                self.dismissKeyboard()
                            }
                        }
                        self.checkState()
                        Spinners.spinnerStop(spinner: self.spinner)
                        return
                    }else{
                        if let res = result{
                            if !res.user.isEmailVerified{
                                Alerts.specialAlert(viewcontroller: self, title: "Внимание", message: "Адрес электронной почты пока не подтвержден")
                                Spinners.spinnerStop(spinner: self.spinner)
                            }else{
                                self.dismissKeyboard()
                                self.checkState()
                                Spinners.spinnerStop(spinner: self.spinner)
                            }
                        }
                    }
                }
            }
        }
    }
        
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func burgerButtonDidTapped(_ sender: UIButton) {
        if !burgerButtonDidTappedIsTapped{
            frostedSidebar.showInViewController( self, animated: true )
            burgerButtonDidTappedIsTapped = true
            sender.alpha = 0.0
        } else{
            
        }
    }
    
    @objc func userInformationButtonDidTapped(_ sender: UIButton) {
        
        print("userInformationButtonDidTapped")
        
    }

    @objc func newUserButtonDidTapped(_ sender: UIButton) {
        
        self.ref.child("users").child("131323").setValue(["capacity": 500,
                                                          "pressure": 234,
                                                          "flowrate": 4500,
                                                          "airexc": 1.2,
                                                          "contentOdCO": 0.05])
        //        self.ref.child("users").child("131323").setValue(["pressure": 234])
        //        self.ref.child("users").child("131323").setValue(["flowrate": 4500])
        //        self.ref.child("users").child("131323").setValue(["airexc": 1.2])
        //        self.ref.child("users").child("131323").setValue(["contentOdCO": 0.05])
        
        guard let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "popupNewUser") else {
            return
        }
        
        popoverContent.modalPresentationStyle = .popover
        
        if let popover = popoverContent.popoverPresentationController {
            
            let viewForSource = sender// as! UIView
            popover.sourceView = viewForSource
            
            // the position of the popover where it's showed
            popover.sourceRect = viewForSource.bounds
            
            // the size you want to display
            popoverContent.preferredContentSize = CGSize(width: 300, height: 200)
            popover.delegate = self
            self.present(popoverContent, animated: true, completion: nil)
            
        }
        
        
    }
    
    @IBAction func phonecallButonDidTapped(_ sender: UIButton) {
        
        guard let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "popupPhoneCall") else {
            return
        }
        
        popoverContent.modalPresentationStyle = .popover
        
        if let popover = popoverContent.popoverPresentationController {
            
            let viewForSource = sender// as! UIView
            popover.sourceView = viewForSource
            
            // the position of the popover where it's showed
            popover.sourceRect = viewForSource.bounds
            
            // the size you want to display
            popoverContent.preferredContentSize = CGSize(width: 200, height: 100)
            popover.delegate = self
            self.present(popoverContent, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    func sidebar(_ sidebar: FrostedSidebar, willShowOnScreenAnimated animated: Bool) {
        
    }
    
    func sidebar(_ sidebar: FrostedSidebar, didShowOnScreenAnimated animated: Bool) {
        
    }
    
    func sidebar(_ sidebar: FrostedSidebar, willDismissFromScreenAnimated animated: Bool) {
        
    }
    
    func sidebar(_ sidebar: FrostedSidebar, didDismissFromScreenAnimated animated: Bool) {
        burgerButton.alpha = 1.0
        burgerButtonDidTappedIsTapped = false
    }
    
    func sidebar(_ sidebar: FrostedSidebar, didTapItemAtIndex index: Int) {
        burgerButton.isHidden = false
        burgerButtonDidTappedIsTapped = false
        frostedSidebar.dismissAnimated(true) { (result) in
            if self.tappedBurgerIndex != index{
                self.tappedBurgerIndex = index
                switch index {
                case 0:
                    self.navigationItem.title = "НПЦЭО"
                    for view in self.view.subviews{
                        if view.tag == 1{
                            view.removeFromSuperview()
                        }
                    }
                case 1:
                    for view in self.view.subviews{
                        if view.tag == 1{
                            view.removeFromSuperview()
                        }
                    }
                    self.navigationItem.title = "сайт организации"
                    let webConfiguration = WKWebViewConfiguration()
                    self.webView = WKWebView(frame: self.view.frame, configuration: webConfiguration)
                    self.webView.tag = index
                    self.webView.uiDelegate = self
                    self.view.addSubview(self.webView)
                    print("number of views = \(self.view.subviews.count)")
                    for (i,view) in self.view.subviews.enumerated(){
                        print("view #\(i): \(view.tag)")
                    }
                    let myURL = URL(string:"http://npceo.ru")
                    let myRequest = URLRequest(url: myURL!)
                    self.webView.load(myRequest)
                    
                default:
                    break
                }
            }
        }
        
    }
    
    func sidebar(_ sidebar: FrostedSidebar, didEnable itemEnabled: Bool, itemAtIndex index: Int) {
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
