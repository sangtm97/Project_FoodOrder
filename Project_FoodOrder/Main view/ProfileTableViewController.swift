//
//  ProfileTableViewController.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 23/05/2022.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    
    @IBOutlet weak var finishRegistrationButtonOutlet: UIButton!
    @IBOutlet weak var purchaseHistoryButtonOutlet: UIButton!
    
    //MARK: Vars
    var editBarButtonOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLoginStatus()
        checkOnboardingStatus()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Helpers
    private func checkOnboardingStatus(){
        if Muser.currentUser() != nil {
            if Muser.currentUser()!.onboard{
                finishRegistrationButtonOutlet.setTitle("Account is Active", for: .normal)
                finishRegistrationButtonOutlet.isEnabled = false
            }
            else{
                finishRegistrationButtonOutlet.setTitle("Finish registration", for: .normal)
                finishRegistrationButtonOutlet.isEnabled = true
                finishRegistrationButtonOutlet.tintColor = .red
            }
            purchaseHistoryButtonOutlet.isEnabled = true
        }
        else{
            finishRegistrationButtonOutlet.setTitle("logged out", for: .normal)
            finishRegistrationButtonOutlet.isEnabled = false
            purchaseHistoryButtonOutlet.isEnabled = false
        }
    }
    private func checkLoginStatus(){
        if Muser.currentUser() == nil{
            createRightBarButton(title: "Login")
        }
        else{
            createRightBarButton(title: "Edit")
        }
    }
    
    
    private func createRightBarButton(title: String){
        editBarButtonOutlet = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonItemPressed))
        self.navigationItem.rightBarButtonItem = editBarButtonOutlet
    }
    
    //MARK: IBAction
    @objc func rightBarButtonItemPressed(){
        if editBarButtonOutlet.title == "Login"{
            showLoginView()
        }
        else{
            gotoEditProfile()
        }
    }
    
    private func showLoginView(){
        print("login view")
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        self.present(loginView, animated: true, completion: nil)
    }
    
    private func gotoEditProfile(){
        performSegue(withIdentifier: "profileToEditSeg", sender: self)
        
    }

//    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }

}
