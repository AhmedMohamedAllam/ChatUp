//
//  LoginViewController.swift
//  ForYou
//
//  Created by LinuxPlus on 6/9/17.
//  Copyright © 2017 E&S. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var LoadingView: UIView!
    
    static let identifier = "loginViewControllerIdentifier"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder()
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 20.0
        registerButton.layer.cornerRadius = 10.0
        loginButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func loginPressed(_ sender: Any) {
       
        
        guard  !Utiles.checkIsEmpty(textFields: emailTextField, passwordTextField) else {
            let validationErrorAlert = Utiles.createAlertWithMessage(title: "This field is required!", message: "Please fill email and password fields!")
            present(validationErrorAlert, animated: true, completion: nil)
            return
        }
         animateActivityMonitor(isAnimating: true)
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){
            user, error in
             self.animateActivityMonitor(isAnimating: false)
            
            if (error != nil) {
                let loginErrorAlert = Utiles.createAlertWithMessage(title: "Login Error!", message: error!.localizedDescription)
                self.present(loginErrorAlert, animated: true, completion: nil)
            }else{
                let UsersVC = self.storyboard?.instantiateViewController(withIdentifier: "usersViewControllerIdentifier")
                self.present(UsersVC!, animated: true, completion: nil)
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            }

        }
    }
    
    
    func animateActivityMonitor(isAnimating: Bool){
        LoadingView.isHidden = !isAnimating
        if isAnimating {
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
    }

    
    
}
