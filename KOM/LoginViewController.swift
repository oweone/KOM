//
//  LoginViewController.swift
//  KOM
//
//  Created by GuoGongbin on 1/1/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit
import MapKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var spinningIndicator: UIActivityIndicatorView!
    
    let identifier = "ShowMainFromSignIn"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinningIndicator.isHidden = true

//        FIRAuth.auth()?.addStateDidChangeListener { auth, currentUser in
//            if currentUser != nil {
//                print("loginViewController listener happened")
//                self.performSegue(withIdentifier: self.identifier, sender: nil)
//            }
//        }
    }

    @IBAction func login(_ sender: UIButton) {
        
        view.isUserInteractionEnabled = false
        spinningIndicator.isHidden = false
        spinningIndicator.startAnimating()
        
        FIRAuth.auth()?.signIn(withEmail: loginEmail.text!, password: loginPassword.text!, completion: { currentUser, error in
            if error == nil {
                // to be implemented
                
                user.uid = currentUser!.uid
                
                //fetch user information
                let userReference = personReference.child(currentUser!.uid)
                userReference.observe(.value, with: { snapshot in
                    let resultUser = Person(snapshot: snapshot)
                    user.name = resultUser.name
                    user.email = resultUser.email
                    self.spinningIndicator.isHidden = true
                    self.spinningIndicator.stopAnimating()
                    self.performSegue(withIdentifier: self.identifier, sender: nil)
//                    print("user.name: \(user.name), user.email: \(user.email), user.uid: \(user.uid)")
                })
                
                //fetch user locations information
                let userLocationReference = locationReference.child(currentUser!.uid)
                userLocationReference.observe(.value, with: { snapshot in
                    if let value = snapshot.value as? NSArray {
                        let locations = value.map { self.toLocation(value: $0 as! [String : Any]) }
                        user.locations = locations
                    }
                })
                
            }else{
                self.view.isUserInteractionEnabled = true
                self.spinningIndicator.isHidden = true
                self.spinningIndicator.stopAnimating()
                print("sign in error: \(error.debugDescription)")
            }
        })
        
    }
    
    func toLocation(value: [String: Any]) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: value["latitude"] as! CLLocationDegrees, longitude: value["longitude"] as! CLLocationDegrees)
    }

}

//    @IBAction func signUp(_ sender: UIButton) {
//        let alert = UIAlertController(title: "Register", message: "Please type in your email and password!", preferredStyle: .alert)
//        alert.addTextField(configurationHandler: { emailTextField in
//            emailTextField.placeholder = "email"
//        })
//        alert.addTextField(configurationHandler: { passwordTextField in
//            passwordTextField.isSecureTextEntry = true
//            passwordTextField.placeholder = "password"
//        })
//        let saveAction = UIAlertAction(title: "save", style: .default, handler: { action in
//            let email = alert.textFields![0].text!
//            let password = alert.textFields![1].text!
//
//            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { user, error in
//                if error == nil {
//                    print("email:\(email), password: \(password)")
//                    FIRAuth.auth()?.signIn(withEmail: email, password: password)
//                }else{
//                    print("error: \(error.debugDescription)")
//                }
//            })
//        })
//        let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: nil)
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true, completion: nil)
//    }
//
