//
//  SignUpViewController.swift
//  KOM
//
//  Created by GuoGongbin on 1/1/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinningIndicator: UIActivityIndicatorView!
    
    let identifier = "ShowMainFromSignUp"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spinningIndicator.isHidden = true
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        
        view.isUserInteractionEnabled = false
        spinningIndicator.isHidden = false
        spinningIndicator.startAnimating()
        
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { auth, error in
            if error == nil {
                //
                //create this user record online, stores user's name, user's email
                let userReference = personReference.child(auth!.uid)
                
                //update the App's user
                user.name = self.nameTextField.text!
                user.uid = auth!.uid
                user.email = self.emailTextField.text!
                
                //store this user record online
                userReference.setValue(user.toAnyObject())
                
                //sign in
                FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!)
                FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { auth, error in
                    if error == nil {
                        user.name = self.nameTextField.text!
                        user.uid = auth!.uid
                        user.email = self.emailTextField.text!
                        self.spinningIndicator.stopAnimating()
                        self.performSegue(withIdentifier: self.identifier, sender: nil)
                    }else{
                        self.view.isUserInteractionEnabled = true
                        self.spinningIndicator.isHidden = true
                        self.spinningIndicator.stopAnimating()
                        print("error info: \(error.debugDescription)")
                    }
                })
            }else {
                self.view.isUserInteractionEnabled = true
                self.spinningIndicator.isHidden = true
                self.spinningIndicator.stopAnimating()
                print("creating user error: \(error.debugDescription)")
            }
        })
        
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        }
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
