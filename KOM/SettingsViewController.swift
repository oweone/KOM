//
//  SettingsViewController.swift
//  KOM
//
//  Created by GuoGongbin on 1/1/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var logInOrOutButton: UIButton!
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var distanceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var distanceSwitch: UISwitch!
    @IBOutlet weak var timeStepper: UIStepper!
    @IBOutlet weak var timeStepperLabel: UILabel!
    
    
    var buttonTitle: String!
    let logIn = "Log In"
    let LogOut = "Log Out"
    
    let identifier = "ShowUserLocations"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        nameLabel.text = user.name
        imageView.image = user.image
        
        if user.name == "anonymous" {
            logInOrOutButton.setTitle(logIn, for: .normal)
            buttonTitle = logIn
        }else{
            logInOrOutButton.setTitle(LogOut, for: .normal)
            buttonTitle = LogOut
        }
    }
    
    //only one sort descriptor is enable, either timeSwitch or distanceSwitch
    @IBAction func timeSwitchTapped(_ sender: UISwitch) {
        if sender.isOn {
            distanceSwitch.isOn = false
            timeOrder = TimeOrder(rawValue: timeSegmentedControl.selectedSegmentIndex)!
            distanceOrder = nil
        }
        
    }
    
    @IBAction func distanceSwitchTapped(_ sender: UISwitch) {
        if sender.isOn {
            timeSwitch.isOn = false
            distanceOrder = DistanceOrder(rawValue: distanceSegmentedControl.selectedSegmentIndex)!
            timeOrder = nil
        }
    }
    
    @IBAction func timeOrderChanged(_ sender: UISegmentedControl) {
        timeOrder = TimeOrder(rawValue: sender.selectedSegmentIndex)!
    }
    
    @IBAction func distanceOrderChanged(_ sender: UISegmentedControl) {
        distanceOrder = DistanceOrder(rawValue: sender.selectedSegmentIndex)!
    }
    
    @IBAction func timeStepperTapped(_ sender: UIStepper) {
        timeStepperLabel.text = "\(sender.value)"
        dayFilter = sender.value
    }
    
    
    @IBAction func showLocations(_ sender: UIButton) {
        performSegue(withIdentifier: identifier, sender: sender)
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        if buttonTitle == logIn {
            logInOrOutButton.setTitle(LogOut, for: .normal)
            buttonTitle = LogOut
        }else {
            logInOrOutButton.setTitle(logIn, for: .normal)
            buttonTitle = logIn
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == identifier {
//            if let locationsTableViewController = segue.destination as? LocationsTableViewController {
//                //to be implemented
//                
//            }
//        }
//    }

    
    
}
