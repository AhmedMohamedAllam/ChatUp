//
//  RegisterViewController.swift
//  ForYou
//
//  Created by LinuxPlus on 6/9/17.
//  Copyright © 2017 E&S. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController{
    
    @IBOutlet weak var profilePic: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPaswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var LoadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let imagePicker = UIImagePickerController()
    var registerdUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.becomeFirstResponder()
        imagePicker.delegate = self
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 20.0
        registerButton.layer.cornerRadius = 10.0
        cancelButton.layer.cornerRadius = 10.0
        Utiles.circleView(view: profilePic)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerComplete(_ sender: Any) {
        
        guard validateRegisteration() else {
            return
        }
        
        animateActivityMonitor(isAnimating: true)

        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){ user, error in
            self.animateActivityMonitor(isAnimating: false)
            
            if (error != nil) {
                
                let registerationErrorAlert = Utiles.createAlertWithMessage(title: "Registeration Error!", message: error!.localizedDescription)
                self.present(registerationErrorAlert, animated: true, completion: nil)
                
            } else {
                
                let fName = self.firstNameTextField.text!
                let lName = self.lastNameTextField.text!
                let fullName = "\(fName) \(lName)"
                
                let changeRequest = user?.createProfileChangeRequest();
                changeRequest?.displayName = fullName
                changeRequest?.commitChanges(completion: nil)
                
                
                self.registerdUser = User(uid: (user?.uid)!, imgPath: "", fName: fName, lName: lName, Email: self.emailTextField.text!)
                self.saveUserToDatabase(user: self.registerdUser, uid: (user?.uid)!)
                
                self.dismiss(animated: true, completion: nil)

            }
        }
    }
    
    @IBAction func changeProfileImage(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Should use here RXswift to chck validation but I have a problem with CocoaPods
    private func validateRegisteration() -> Bool{
        
        
        guard !Utiles.checkIsEmpty(textFields: firstNameTextField, lastNameTextField,emailTextField, passwordTextField, confirmPaswordTextField) else {
            let validationErrorAlert = Utiles.createAlertWithMessage(title: "This field is required!", message: "Complete all yor personal data!")
            present(validationErrorAlert, animated: true, completion: nil)
            return false
        }
        
        guard passwordTextField.text == confirmPaswordTextField.text else {
            let passwordErrorAlert = Utiles.createAlertWithMessage(title: "Password confirmation error!", message: "confirm your password again!")
            present(passwordErrorAlert, animated: true, completion: nil)
            confirmPaswordTextField.text = ""
            return false
        }
        
        return true
    }
    
    
    func animateActivityMonitor(isAnimating: Bool){
        LoadingView.isHidden = !isAnimating
        if isAnimating {
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
    }
    
    
    func saveUserToDatabase(user:User , uid:String) {
        let ref = Database.database().reference()
        let userDict = User.UserToDictionary(user: user)
        ref.child("users").child(uid).setValue(userDict)
    }
    
    
}


extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profilePic.setImage(pickedImage, for: .normal)
        } else {
            profilePic.setImage(#imageLiteral(resourceName: "anonymous_user_profile"), for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}






