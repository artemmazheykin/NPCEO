//
//  UserInfoViewController.swift
//  NPCEO
//
//  Created by  Artem Mazheykin on 04.03.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController{

    @IBOutlet weak var profileTableview: UITableView!
    var nameOrganizationCell: ProfileTableViewNameOrganizationOrEmailCell!
    var emailCell: ProfileTableViewNameOrganizationOrEmailCell!
    var changePasswordCell: ProfileTableViewResetPasswordOrExitCell!
    var exitButtonCell: ProfileTableViewResetPasswordOrExitCell!
    var isNameEditing = false
    var isEmailVerified: Bool!
    
    var currentUser: User!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableview.delegate = self
        profileTableview.dataSource = self
        profileTableview.separatorStyle = .none
        currentUser = Auth.auth().currentUser
        isEmailVerified = currentUser.isEmailVerified
        
        // Do any additional setup after loading the view.
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

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0,1:
            return 30
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3{
            return 0
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Имя организации"
        case 1:
            let text = isEmailVerified ? "" : " (не подтверждена)"
            return "Электронная почта" + text
        default:
            return nil
        }
    }
    
    @objc func changeName (sender: UIButton){
        if isNameEditing{
            Spinners.spinnerStart(spinner: spinner)
            nameOrganizationCell.nameOrganizationOrEmailTextField.isUserInteractionEnabled = false
            nameOrganizationCell.nameOrganizationOrEmailTextField.resignFirstResponder()
            if let user = Auth.auth().currentUser{
                let request = user.createProfileChangeRequest()
                request.displayName = nameOrganizationCell.nameOrganizationOrEmailTextField.text
                request.commitChanges { (error) in
                    if let error = error{
                        Alerts.specialAlert(viewcontroller: self, title: "Alert", message: error.localizedDescription)
                        Spinners.spinnerStop(spinner: self.spinner)
                        return
                    }
                    self.nameOrganizationCell.changeButton.setTitle("Изменить", for: .normal)
                    self.isNameEditing = false
                    Spinners.spinnerStop(spinner: self.spinner)
                    if let mainvc = self.navigationController?.viewControllers.first as? MainViewController{
                        mainvc.checkState()
                    }
                }
            }else{
                Alerts.specialAlert(viewcontroller: self, title: "Внимание", message: "Пользователь не найден")
                Spinners.spinnerStop(spinner: spinner)
            }
        }else{
            nameOrganizationCell.nameOrganizationOrEmailTextField.isUserInteractionEnabled = true
            nameOrganizationCell.nameOrganizationOrEmailTextField.becomeFirstResponder()
            nameOrganizationCell.changeButton.setTitle("Сохранить", for: .normal)
            isNameEditing = true
        }
    }
    
    @objc func sendVerificationOneMoreTime(sender: UIButton){
        Spinners.spinnerStart(spinner: self.spinner)
        currentUser.sendEmailVerification { (error) in
            if let error = error{
                Alerts.specialAlert(viewcontroller: self, title: "Alert", message: error.localizedDescription)
                Spinners.spinnerStop(spinner: self.spinner)
                return
            }
            Spinners.spinnerStop(spinner: self.spinner)
        }
    }
    
    @objc func changePassword(sender: UIButton){
        Spinners.spinnerStart(spinner: self.spinner)

        Auth.auth().sendPasswordReset(withEmail: currentUser.email!) { (error) in
            if let error = error{
                Alerts.specialAlert(viewcontroller: self, title: "Alert", message: error.localizedDescription)
                Spinners.spinnerStop(spinner: self.spinner)
                return
            }
            Spinners.spinnerStop(spinner: self.spinner)
        }
    }
    
    @objc func exit(sender: UIButton){
        do {
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        } catch let signOutError as NSError {
            Alerts.specialAlert(viewcontroller: self, title: "Alert", message: signOutError.localizedDescription)
        } catch {
            Alerts.specialAlert(viewcontroller: self, title: "Alert", message: "Unknown error")
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewNameOrganizationOrEmailCell") as! ProfileTableViewNameOrganizationOrEmailCell
            nameOrganizationCell = cell
            nameOrganizationCell.nameOrganizationOrEmailTextField.isUserInteractionEnabled = false
            nameOrganizationCell.nameOrganizationOrEmailTextField.text = currentUser.displayName
            nameOrganizationCell.changeButton.addTarget(self, action: #selector(changeName(sender:)), for: .touchUpInside)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewNameOrganizationOrEmailCell") as! ProfileTableViewNameOrganizationOrEmailCell
            emailCell = cell
            emailCell.nameOrganizationOrEmailTextField.isUserInteractionEnabled = false
            emailCell.nameOrganizationOrEmailTextField.text = currentUser.email
            if isEmailVerified{
                self.emailCell.changeButton.isHidden = true
                let constrs = emailCell.contentView.constraints
                for constr in constrs{
                    if constr.identifier == "trailingSpace"{
                        constr.constant = 0
                    }
                }
            }else{
                emailCell.changeButton.titleLabel?.numberOfLines = 2
                emailCell.changeButton.titleLabel?.adjustsFontForContentSizeCategory = true
                emailCell.changeButton.setTitle("Отправить еще раз", for: .normal)
                emailCell.changeButton.addTarget(self, action: #selector(sendVerificationOneMoreTime(sender:)), for: .touchUpInside)
            }
            
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewResetPasswordOrExitCell") as! ProfileTableViewResetPasswordOrExitCell
            changePasswordCell = cell
            changePasswordCell.resetPasswordOrExitButton.addTarget(self, action: #selector(changePassword(sender:)), for: .touchUpInside)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewResetPasswordOrExitCell") as! ProfileTableViewResetPasswordOrExitCell
            exitButtonCell = cell
            exitButtonCell.resetPasswordOrExitButton.setTitle("ВЫЙТИ", for: .normal)
            exitButtonCell.resetPasswordOrExitButton.addTarget(self, action: #selector(exit(sender:)), for: .touchUpInside)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    
    
    
    
}
