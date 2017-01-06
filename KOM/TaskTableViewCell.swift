//
//  TaskTableViewCell.swift
//  KOM
//
//  Created by GuoGongbin on 12/27/16.
//  Copyright © 2016 GuoGongbin. All rights reserved.
//

import UIKit
import MapKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var task: Task! {
        didSet{
            updateUI()
        }
    }
    func updateUI() {
        userImageView.image = task.person.image
        userNameLabel.text = task.person.name
        summaryLabel.text = task.summary
        timeLabel.text = "asked at: \(task.time)"
        
        //task.person.location
        updateLocation()
    }
    
    func updateLocation() {
        
        // locationString = name + thoroughfare + locality
        
        let location = CLLocation(latitude: task.location.latitude, longitude: task.location.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            let placemark = placemarks?[0]
            //let locationString = [placemark?.name, placemark?.thoroughfare, placemark?.locality]
            //put a space between 3 and Heinrichstrasse
            let streetString = [placemark?.thoroughfare, placemark?.subThoroughfare].flatMap{$0}.joined(separator: " ")
            
            let locationString = [streetString, placemark?.locality].flatMap{$0}.joined(separator: ", ")
            self.locationLabel.text = locationString
            //            print("placemark information: \(placemark?.addressDictionary)")
        })
    }
}
