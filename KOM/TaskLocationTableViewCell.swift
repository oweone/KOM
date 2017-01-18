//
//  TaskLocationTableViewCell.swift
//  KOM
//
//  Created by GuoGongbin on 1/2/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit
import MapKit

class TaskLocationTableViewCell: UITableViewCell {

    var coordinate: CLLocationCoordinate2D! {
        didSet {
            updateUI()
        }
    }

    func updateUI() {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            let placemark = placemarks?.first
            
            let streetString = [placemark?.thoroughfare, placemark?.subThoroughfare].flatMap{$0}.joined(separator: " ")
            let locationString = [streetString, placemark?.locality].flatMap{$0}.joined(separator: ", ")
            
            self.textLabel?.text = locationString
        })
    }
    
}
