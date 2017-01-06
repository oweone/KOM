//
//  Task.swift
//  KOM_Project
//
//  Created by GuoGongbin on 11/22/16.
//  Copyright © 2016 GuoGongbin. All rights reserved.
//

import Foundation
import MapKit
import Firebase

class Task: NSObject, MKAnnotation {
    
    // the person who submits the task
    var person: Person
    //
    var summary: String
    
    var time: String
    
    var location: CLLocationCoordinate2D
    //could be nil
    var answers: [Answer]?

    //conforms to the MKAnnotation
    var coordinate: CLLocationCoordinate2D {
        return location
    }
    var taskReference: FIRDatabaseReference?
    //the string that specifies the task online
    var taskKey: String?
    
    var title: String?
    var subtitle: String?
    
    init(person: Person, summary: String, time: String, location: CLLocationCoordinate2D) {
        self.person = person
        self.summary = summary
        self.time = time
        self.location = location
    }
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as! [String: Any]
        
        self.person = Person(name: value["personName"] as! String)
        self.summary = value["summary"] as! String
        self.time = value["time"] as! String
        self.location = CLLocationCoordinate2D(latitude: value["latitude"] as! CLLocationDegrees, longitude: value["longitude"] as! CLLocationDegrees)
        self.taskReference = snapshot.ref
        self.taskKey = snapshot.key
    }
    
    func toAnyObject() -> Any {
        return [
            "personName": person.name,
            "summary": summary,
            "time": time,
            "latitude": location.latitude,
            "longitude": location.longitude
        ]
    }
    
}
