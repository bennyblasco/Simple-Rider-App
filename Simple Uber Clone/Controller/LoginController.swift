//
//  LoginController.swift
//  Uber
//
//  Created by Diego Oruna on 1/9/20.
//  Copyright © 2020 Diego Oruna. All rights reserved.
//

import UIKit
import SwiftUI
import Firebase

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailContainerView:UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView:UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let emailTextField:UITextField = {
        return UITextField().textField(withPlaceHolder: "Email", isSecureTextEntry: false, isAutocorrected: false)
    }()
    
    private let passwordTextField:UITextField = {
        return UITextField().textField(withPlaceHolder: "Password", isSecureTextEntry: true)
    }()
    
    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Auth
    
    @objc func handleLogin(){
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            
            if let err = err{
                print("Failed to log in user", err)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
//            guard let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first as? HomeController else {return}
//            controller.configureUI()
            
        }
    }
    
    //MARK: - Extra Functions
    
    @objc fileprivate func handleShowSignUp(){
        let controller = SignUpController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func setupUI(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
//        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 18
        
        view.addSubview(stackView)
//        stackView.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, paddingTop: 40, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: nil, height: nil)
        stackView.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 40, left: 16, bottom: 0, right: 16))
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
//        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
        dontHaveAccountButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, size: .init(width: 0, height: 32))
        
    }

}

