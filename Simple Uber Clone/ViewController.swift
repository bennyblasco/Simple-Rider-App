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
        func displayAlert(title:String, message:String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title:"OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        @IBAction func topTapped(_ sender: Any) {
            if emailTextField.text == "" || passwordTextField.text == ""{
                displayAlert(title: "Missing Information", message: "You must provide Email address or Password")
            }else{
                if let email = emailTextField.text{
                    if let password = passwordTextField.text{
                        if signUpMode{
                            //Sign up
                            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                                if error != nil{
                                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                                }else {
                                    print ("Sign up successfully")
                                    self.performSegue(withIdentifier: "riderSegue", sender: nil)
                                }
                            }
                            
                        }else{
                            // LOG IN
                            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                                if error != nil{
                                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                                }else {
                                    print ("Sign in successfully")
                                    self.performSegue(withIdentifier: "riderSegue", sender: nil)
                                }
                                
                                
                            }
                        }
                    }
                }
                
            }
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



    
    

    
