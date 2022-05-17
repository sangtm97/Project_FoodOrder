//
//  WelcomeController.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 17/05/2022.
//

import UIKit

class WelcomeController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonStarted_Tapped(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeUITabController", sender: nil)
    }
    
}
