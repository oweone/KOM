//
//  UserLocationsViewController.swift
//  KOM
//
//  Created by GuoGongbin on 1/2/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit
import MapKit

class UserLocationsViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    var userLocations: [CLLocationCoordinate2D]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        userLocations = user.locations
        
//        let userLocationsReference = locationReference.child(user.uid!)
//        userLocationsReference.observe(.value, with: { snapshot in
//            
//            //location format: [("latitude": "111", "longitude": "111"), ("latitude": "111", "longitude": "111")]
//            if let value = snapshot.value as? NSArray {
//                let locations = value.map { self.toLocation(value: $0 as! [String : Any]) }
//                self.userLocations = locations
//            }
//        })

    }
    
    func toLocation(value: [String: Any]) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: value["latitude"] as! CLLocationDegrees, longitude: value["longtitude"] as! CLLocationDegrees)
    }

    @IBAction func addLocation(_ sender: UIBarButtonItem) {
        
        // to be implemented
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
extension UserLocationsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userLocations == nil {
            return 0
        }else{
            return userLocations!.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LocationCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
//        cell.textLabel?.text = "\(userLocations?[indexPath.row])"
        if let location = userLocations?[indexPath.row] {
            let coordinate = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(coordinate, completionHandler: { placemarks, error in
                let placemark = placemarks?.first
                
                let streetString = [placemark?.thoroughfare, placemark?.subThoroughfare].flatMap{$0}.joined(separator: " ")
                let locationString = [streetString, placemark?.locality].flatMap{$0}.joined(separator: ", ")
                
                cell.textLabel?.text = locationString
                cell.detailTextLabel?.text = "\(placemark?.location?.coordinate.latitude), \(placemark?.location?.coordinate.longitude)"
            })
        }
        

        return cell
    }
    
    
}
