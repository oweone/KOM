//
//  MapForDisplayingViewController.swift
//  KOM
//
//  Created by GuoGongbin on 1/3/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit
import MapKit

class MapForDisplayingViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let SegueIdentifier = "ShowTaskDetailFromMap"
    var tasks: [Task]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        //get the first tab viewController, then get the first viewController from the naviController
        if let naviController = self.tabBarController?.viewControllers?[0] as? UINavigationController {
            if let controller = naviController.viewControllers[0] as? TasksViewController {
                tasks = controller.tasks
                for (index, item) in tasks.enumerated() {
                    tasks[index].title = "task from \(item.person.name)"
                    
                    let location = CLLocation(latitude: item.location.latitude, longitude: item.location.longitude)
                    let geocoder = CLGeocoder()
                    geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                        let placemark = placemarks?[0]
                        //let locationString = [placemark?.name, placemark?.thoroughfare, placemark?.locality]
                        //put a space between 3 and Heinrichstrasse
                        let streetString = [placemark?.thoroughfare, placemark?.subThoroughfare].flatMap{$0}.joined(separator: " ")
                        
                        let locationString = [streetString, placemark?.locality].flatMap{$0}.joined(separator: ", ")
                        self.tasks[index].subtitle = locationString
                    })
                    
                }
                
                mapView.addAnnotations(tasks)

            }
        }
    }
}

extension MapForDisplayingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "TaskPin"
        let view: MKPinAnnotationView!
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeueView.annotation = annotation
            view = dequeueView
        }else{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure)
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        performSegue(withIdentifier: SegueIdentifier, sender: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier {
            if let task = (sender as? MKAnnotationView)?.annotation as? Task {
                if let taskDetailViewController = segue.destination as? TaskDetailViewController {
                    taskDetailViewController.task  = task
                }
            }
        }
    }
}

extension MapForDisplayingViewController: CLLocationManagerDelegate {
    
}
