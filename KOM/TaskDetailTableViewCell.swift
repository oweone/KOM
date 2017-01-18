//
//  TaskDetailTableViewCell.swift
//  KOM
//
//  Created by GuoGongbin on 12/27/16.
//  Copyright © 2016 GuoGongbin. All rights reserved.
//

import UIKit
import MapKit

class TaskDetailTableViewCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var button: UIButton!
    
    var locationManager: CLLocationManager!
    
    var task: Task!{
        didSet{
            updateUI()
        }
    }
    
    func updateUI() {
        
        userImageView.image = task.person.image
        userNameLabel.text = task.person.name
        summaryLabel.text = task.summary
        timeLabel.text = "asked at \(task.time)" 
//        locationLabel.text = "location not implemented"
        updateLocation()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        
        mapView.delegate = self
        //let region = MKCoordinateRegion(center: task.location, span: <#T##MKCoordinateSpan#>)
        let locationDistance: CLLocationDistance = 1000
        let region = MKCoordinateRegionMakeWithDistance(task!.coordinate, locationDistance, locationDistance)
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotation(task!)
        
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
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
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }else{
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeueView.annotation = annotation
                view = dequeueView
            }else{
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = false
            }
            return view
        }
        
    }
    

}
