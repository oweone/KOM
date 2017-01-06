//
//  MapsViewController.swift
//  KOM
//
//  Created by GuoGongbin on 12/28/16.
//  Copyright © 2016 GuoGongbin. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class MapsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var resultSearchController: UISearchController!
    var selectedPin: MKPlacemark!
    
    var locationManager: CLLocationManager!
    
    var center: CLLocation? {
        didSet {
            if center != nil {
                let locationDistance: CLLocationDistance = 4000
                let location = CLLocationCoordinate2D(latitude: center!.coordinate.latitude, longitude: center!.coordinate.longitude)
                let region = MKCoordinateRegionMakeWithDistance(location, locationDistance, locationDistance)
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        

        let locationSearchTable = storyboard?.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController.searchBar
        
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        
        //Setting definesPresentationContext to true is an important but easily overlooked step. By default, the modal overlay will take up the entire screen, covering the search bar. definesPresentationContext limits the overlap area to just the View Controller’s frame instead of the whole Navigation Controller.
        definesPresentationContext = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    
    // MARK: - location manager to authorize user location for Maps app
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        } else {
            if CLLocationManager.authorizationStatus() != .authorizedWhenInUse && CLLocationManager.authorizationStatus() != .notDetermined {
                let alert = UIAlertController(title: "Location Permission denied", message: "you can go to Settings/Privacy/Location Services to enable it", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
}
extension MapsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
//            print("location: \(location)")
            userCurrentLocation = location
            center = location
            locationManager.stopUpdatingLocation()
            
//            print("userCurrentLocation from did update: \(userCurrentLocation)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
        userCurrentLocation = nil
    }
}
extension MapsViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
//        if let thoroughfare = placemark.thoroughfare, let subThoroughfare = placemark.subThoroughfare, let locality = placemark.locality{
//            annotation.subtitle = "\(thoroughfare) \(subThoroughfare), \(locality)"
//        }
        let streetString = [selectedPin?.thoroughfare, selectedPin?.subThoroughfare].flatMap{$0}.joined(separator: " ")
        let locationString = [streetString, selectedPin?.locality].flatMap{$0}.joined(separator: ", ")
        annotation.subtitle = locationString
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}
extension MapsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }else{
            let identifier = "id"
            var view: MKPinAnnotationView!
            if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
                dequeueView.annotation = annotation
                //            dequeueView.canShowCallout = true
                view = dequeueView
            }else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                //            view.canShowCallout = true
            }
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton.init(type: .contactAdd)
            
            //        let leftButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            //        leftButton.setBackgroundImage(UIImage(named: "address"), for: .normal)
            //        view.leftCalloutAccessoryView = leftButton
            
            return view
        }
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if control == view.leftCalloutAccessoryView {
//            print("left button tapped")
//        }
        if control == view.rightCalloutAccessoryView {
//            print("right button tapped")
            let SegueIdentifier = "ShowSegueFromMap"
            performSegue(withIdentifier: SegueIdentifier, sender: view)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if selectedPin == nil {
            let alert = UIAlertController(title: "location of this place error", message: "please search the place", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        if segue.identifier == "ShowSegueFromMap" {
            if let taskCompositionViewController = segue.destination as? TaskCompositionViewController {
                taskCompositionViewController.selectedPin = selectedPin
            }
        }
    }
}




