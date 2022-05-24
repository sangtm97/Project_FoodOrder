//
//  EditProfileViewController.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 23/05/2022.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController {

    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    //MARK: Vars
    let hud = JGProgressHUD(style: .dark)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: IBAction
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        dismissKeyboard()
        if textFieldsHaveText() {
            let withValues = [KFIRSTNAME : nameTextField.text!, KLASTNAME : surnameTextField.text!, KFULLNAME : (nameTextField.text! + "" + surnameTextField.text!), KFULLADDRESS : addressTextField.text!, KPHONE : phoneTextField.text!]
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
                if error == nil{
                    self.hud.textLabel.text = "Update!"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay:  2.0)
                }
                else{
                    print("error updating user", error!.localizedDescription)
                    self.hud.textLabel.text = error!.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay:  2.0)
                }
            }
        }
        else{
            hud.textLabel.text = "All field required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay:  2.0)
        }
        
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        logOutUser()
    }
    
    
    //MARK: UpdateUI
    private func loadUserInfor(){
        if Muser.currentUser() != nil {
            let currentUser = Muser.currentUser()
            nameTextField.text = currentUser?.firstName
            surnameTextField.text = currentUser?.lastName
            addressTextField.text = currentUser?.fullAddress
            phoneTextField.text = currentUser?.phone
        }
    }
    
    //MARK: Helper func
    private func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    private func textFieldsHaveText() -> Bool{
        return (nameTextField.text != "" && surnameTextField.text != "" && addressTextField.text != "" && phoneTextField.text != "")
    }
    
    private func logOutUser(){
        Muser.logOutCurrentUser{ (error) in
            if error == nil{
                print("logged out")
                self.navigationController?.popViewController(animated: true)
            } else{
                print("error login out", error!.localizedDescription)
            }
        }
    }
}
