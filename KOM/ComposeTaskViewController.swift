//
//  ComposeTaskViewController.swift
//  KOM
//
//  Created by GuoGongbin on 1/2/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit
import MapKit

class ComposeTaskViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    
    //return back from TaskLocationViewController, unwind segue
    var coordinate: CLLocationCoordinate2D!
    var locationText: String!
    
    let text = "write your question here"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "compose a task"
        
        textView.text = "write your question here"
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        
        button.isEnabled = true
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
    }

    //store Person's name, time, task summary, coordinate(latitude, longitude)
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
//        dateFormatter.locale = Locale(identifier: "en_US")
        let time = dateFormatter.string(from: Date())
        
        let summary = textView.text
        if summary == "" || summary == nil || summary == text {
            let alert = UIAlertController(title: "Please type something.", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let location = coordinate
        if location == nil {
            let alert = UIAlertController(title: "Please add location information.", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let task = Task(person: user, summary: summary!, time: time, location: location!)
        
        //two methods, one is childByAutoId, the other is child(pathString: String)
        let childReference = tasksReference.childByAutoId()
        childReference.setValue(task.toAnyObject())
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        let identifier = "ShowTaskLocations"
        performSegue(withIdentifier: identifier, sender: nil)
    }
    @IBAction func backFromViewController(segue: UIStoryboardSegue) {
        locationLabel.text = locationText
    }


}

extension ComposeTaskViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text = ""
        textView.textColor = UIColor.black
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count == 0 {
            textView.text = text
            textView.textColor = UIColor.lightGray
            textView.resignFirstResponder()
        }
    }
}
