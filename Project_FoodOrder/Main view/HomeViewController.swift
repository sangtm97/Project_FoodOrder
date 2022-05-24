//
//  HomeViewController.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 24/05/2022.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var startedButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func startedButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "homeUI", sender: nil)    }
    
}
