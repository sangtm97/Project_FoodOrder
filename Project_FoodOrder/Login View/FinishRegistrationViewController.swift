//
//  FinishRegistrationViewController.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 23/05/2022.
//

import UIKit
import JGProgressHUD

class FinishRegistrationViewController: UIViewController {
    
    

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    //MARK: Vars
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        surnameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        addressTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    //MARK: IBAction
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        finishOnboarding()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        updateDoneButtonStatus()
    }
    
    //MARK: Helper
    private func updateDoneButtonStatus(){
        if nameTextField.text != "" && surnameTextField.text != "" && addressTextField.text != ""{
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
            doneButtonOutlet.isEnabled = true
        }
        else{
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            doneButtonOutlet.isEnabled = false
        }
    }
    
    private func finishOnboarding(){
        let withValues = [KFIRSTNAME : nameTextField.text!, KLASTNAME : surnameTextField.text!, KONBOARD : true, KFULLADDRESS: addressTextField.text!, KFULLNAME : (nameTextField.text! + "" + surnameTextField.text!)] as [String : Any]
        
        updateCurrentUserInFirestore(withValues: withValues) { (error) in
            if error == nil{
                self.hud.textLabel.text = "Update!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                self.dismiss(animated: true, completion: nil)
            }
            else{
                print("error updating user \(error!.localizedDescription)")
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
}
