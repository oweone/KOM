//
//  TaskCompositionViewController.swift
//  KOM
//
//  Created by GuoGongbin on 12/31/16.
//  Copyright © 2016 GuoGongbin. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class TaskCompositionViewController: UIViewController {

    //locationLabel is only for display purpose, the location information is stored in selectedPin variable
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    var selectedPin: MKPlacemark?
    
    let text = "write your question here"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "compose a task"
        
        textView.text = text
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        
        let streetString = [selectedPin?.thoroughfare, selectedPin?.subThoroughfare].flatMap{$0}.joined(separator: " ")
        
        let locationString = [streetString, selectedPin?.locality].flatMap{$0}.joined(separator: ", ")
        
        locationLabel.text = locationString
        
        button.isEnabled = true
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
    }
    
    //store Person's name, time, task summary, coordinate(latitude, longitude)
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        let time = dateFormatter.string(from: Date())
        
        let summary = textView.text
        
        if summary == "" || summary == nil || summary == text {
            let alert = UIAlertController(title: "Please type something to answer this question.", message: " You haven't answered this question yet!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let location = selectedPin!.coordinate
        
        let task = Task(person: user, summary: summary!, time: time, location: location)
        
        //two methods, one is childByAutoId, the other is child(pathString: String)
        let childReference = tasksReference.childByAutoId()
        childReference.setValue(task.toAnyObject())
        
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addLocation(_ sender: UIButton) {
        
        //assume the user is not anonymous
        if user.uid == nil {
            let alert = UIAlertController(title: "You have to sign in.", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        let userLoationsReference = locationReference.child(user.uid!)
        let coordinate = selectedPin!.coordinate
        if user.locations == nil {
            user.locations = []
        }else{
            if user.locations!.contains(where: { $0.latitude == coordinate.latitude && $0.longitude == coordinate.longitude }) {
                let alert = UIAlertController(title: "This location has already been added to your favorite!", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
//                self.button.isEnabled = false
                return
            }
        }
        
        user.locations!.append(coordinate)
        let locations = user.locations!.map { $0.toAnyObject() }
        
        userLoationsReference.setValue(locations, withCompletionBlock: { error, reference in
            if error == nil {
                let alert = UIAlertController(title: "This location has been successfully added to your favorite!", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        })
        
    }
    
    func coordinateToAnyObject(coordinate: CLLocationCoordinate2D) -> Any{
        return [
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude
        ]
    }
}

extension TaskCompositionViewController: UITextViewDelegate {
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
extension CLLocationCoordinate2D {
    func toAnyObject() -> Any {
        return [
            "latitude": latitude,
            "longitude": longitude
        ]
    }
}

