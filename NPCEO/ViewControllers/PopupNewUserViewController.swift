//
//  PopupNewUserViewController.swift
//  NPCEO
//
//  Created by Artem Mazheykin on 28.02.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import UIKit
import Firebase

class PopupNewUserViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var nameOrganizationTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var addUserButton: UIButton!
    
    @IBOutlet weak var checkMarkIcon: UIImageView!
    @IBOutlet weak var checkMarkSecondIcon: UIImageView!
    
    @IBAction func passwordTextFieldEditingChanged(_ sender: UITextField) {
        
        if passwordHaveSixCharactersOrMore(){
            UIView.animate(withDuration: 0.5) {
                self.checkMarkIcon.alpha = 1
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.checkMarkIcon.alpha = 0
            }
        }
        repeatPasswordTextFieldEditingChanged(repeatPasswordTextField)
    }
    
    @IBAction func repeatPasswordTextFieldEditingChanged(_ sender: UITextField) {
        if repeatingPasswordHaveTheSame() {
            UIView.animate(withDuration: 0.5) {
                self.checkMarkSecondIcon.alpha = 1
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.checkMarkSecondIcon.alpha = 0
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkMarkIcon.alpha = 0
        checkMarkSecondIcon.alpha = 0        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func passwordHaveSixCharactersOrMore() -> Bool{
        
        if let text = passwordTextField.text{
            if text.count >= 6{
                return true
            }
        }
        return false
    }
    
    func repeatingPasswordHaveTheSame() -> Bool{
        
        if passwordHaveSixCharactersOrMore() && passwordTextField.text == repeatPasswordTextField.text{
            return true
        }
        return false
    }
    
    
    
    func allTextFieldsAreCompleted () -> Bool{
        
        if nameOrganizationTextField.text != "" && nameOrganizationTextField.text != " ",
            emailTextField.text != "" && emailTextField.text != " ",
            passwordTextField.text != "" && passwordTextField.text != " ",
            repeatPasswordTextField.text != "" && repeatPasswordTextField.text != " "{
            return true
        }
        return false
    }
    
//    func alert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
//        self.present(alert, animated: true, completion: nil)
//    }
    
    
    @IBAction func addUserButtonDidTapped(_ sender: UIButton) {
        
        if allTextFieldsAreCompleted() && passwordTextField.text == repeatPasswordTextField.text{
            
            var tempUid = ""
            
            Spinners.spinnerStart(spinner: spinner)
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
                
                if let error = error{
                    Spinners.spinnerStop(spinner: self.spinner)
                    switch error.localizedDescription {
                    case "The email address is badly formatted.":
                        Alerts.specialAlert(viewcontroller: self, title: "Внимание", message: "Неверный формат электронной почты")
                    case "The password must be 6 characters long or more.":
                        Alerts.specialAlert(viewcontroller: self, title: "Внимание", message: "Длина пароля должна быть 6 или более символов")
                    case "The email address is already in use by another account.":
                        Alerts.specialAlert(viewcontroller: self, title: "Внимание", message: "Данная электронная почта уже используется")
                    default:
                        Alerts.specialAlert(viewcontroller: self, title: "Alert", message: error.localizedDescription)
                    }
                    return
                }
                
                print("authResult = \(authResult)")
                //The email address is badly formatted.
                //The password must be 6 characters long or more.
                //The email address is already in use by another account.
                
                
                
                if let id = authResult?.user.uid{
                    tempUid = id
                    print("_____________tempUid = \(tempUid)")
                }
                Auth.auth().languageCode = "ru"
                if let user = Auth.auth().currentUser, user.uid == tempUid{
                    user.sendEmailVerification { (error) in
                        if let err = error{
                            Alerts.specialAlert(viewcontroller: self, title: "Alert", message: err.localizedDescription)
                            Spinners.spinnerStop(spinner: self.spinner)
                            return
                        }
                        let request = user.createProfileChangeRequest()
                        request.displayName = self.nameOrganizationTextField.text
                        request.commitChanges { (error) in
                            if let err = error{
                                Alerts.specialAlert(viewcontroller: self, title: "Alert", message: err.localizedDescription)
                                Spinners.spinnerStop(spinner: self.spinner)
                                return
                            }
                            print("user name = \(user.displayName)")
                            Alerts.specialAlert(viewcontroller: self, title: "Добро пожаловать, \(self.nameOrganizationTextField.text!)!", message: "Вам осталось подтвердить адрес электронной почты") { _ in
                                if let mainVC = self.popoverPresentationController?.delegate as? MainViewController{
                                    mainVC.checkState()
                                    mainVC.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                        Spinners.spinnerStop(spinner: self.spinner)
                    }
                }
            }
        }else{
            Alerts.specialAlert(viewcontroller: self, title: "Внимание", message: "Все поля должны быть заполнены соответствующим образом")
        }
    }
}

