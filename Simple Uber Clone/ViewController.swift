//
//  ViewController.swift
//  Simple Uber Clone
//
//  Created by Benjamin Inemugha on 07/06/2020.
//  Copyright © 2020 Techelopers. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var riderLabel: UILabel!
    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var riderDriverSwitch: UISwitch!
    
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var topButton: UIButton!
    
    
    var signUpMode = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func topTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func bottomTapped(_ sender: Any) {
        if signUpMode {
            topButton .setTitle("Log in", for: .normal)
            bottomButton .setTitle("sign up", for: .normal)
            riderLabel.isHidden = true
            driverLabel.isHidden = true
            riderDriverSwitch.isHidden = true
            signUpMode = false
        }else {
            topButton .setTitle("Sign up", for: .normal)
            bottomButton .setTitle("log in", for: .normal)
            riderLabel.isHidden = false
            driverLabel.isHidden = false
            riderDriverSwitch.isHidden = false
            signUpMode = true
        }
    }
}

