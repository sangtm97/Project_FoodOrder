//
//  WelcomeViewController.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 23/05/2022.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class WelcomeViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resendButtonOutlet: UIButton!
    
    //MARK: Vars
    let hud = JGProgressHUD(style: .dark)
    var activityIdicator: NVActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIdicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse,color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), padding: nil)
    }
    

    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("login")
        
        if textFieldsHaveText(){
            loginUser()
        }
        else{
            hud.textLabel.text = "All fields are required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    @IBAction func registerButtonPressed(_ sender: Any) {
        print("register")
        
        if textFieldsHaveText(){
            registerUser()
        }
        else{
            hud.textLabel.text = "All fields are required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    @IBAction func forgetPasswordButtonPressed(_ sender: Any) {
        print("forget")
        
        if emailTextField.text != ""{
            resetThePassword()
        }else{
            hud.textLabel.text = "Please insert email"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        print("resend")
        Muser.resendVerificationEmail(email: emailTextField.text!) { (error) in
            print("error resending email", error?.localizedDescription)
        }
    }
    
    //MARK: Login User
    private func loginUser(){
        showLoadingIdicator()
        Muser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!){ (error, isEmailVerified) in
            
            if error == nil{
                if isEmailVerified{
                    self.dismissView()
                    print("Email is verified")
                }
                else{
                    self.hud.textLabel.text = "Please verify your email"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    self.resendButtonOutlet.isHidden = false
                }
            }
            else{
                print("error loging in the user", error!.localizedDescription)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            
            self.hideLoadingIdicator()
        }
    }
    
    //MARK: Register User
    private func registerUser(){
        showLoadingIdicator()
        Muser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) {(error) in
            if error == nil{
                self.hud.textLabel.text = "Verification sent email"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            else{
                print("Error register!", error!.localizedDescription)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            
            self.hideLoadingIdicator()
        }
    }
    
    
    //MARK: Helpers
    private func resetThePassword(){
        Muser.resetPasswordFor(email: emailTextField.text!) { (error) in
            if error == nil{
                self.hud.textLabel.text = "Reset password email sent!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            } else  {
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
    
    private func textFieldsHaveText() -> Bool{
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    private func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Activity Indicator
    private func showLoadingIdicator(){
        if activityIdicator != nil{
            self.view.addSubview(activityIdicator!)
            activityIdicator!.startAnimating()
        }
    }
    
    private func hideLoadingIdicator(){
        if activityIdicator != nil{
            activityIdicator!.removeFromSuperview()
            activityIdicator!.stopAnimating()
        }
    }
}
