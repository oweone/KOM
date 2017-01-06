//
//  Person.swift
//  KOM
//
//  Created by GuoGongbin on 12/27/16.
//  Copyright © 2016 GuoGongbin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Person: NSObject {
    
    //currently only 3 properties, may be added in the future
    
    var name: String // as account name and display name
    var locations: [CLLocationCoordinate2D]?
    var image: UIImage?
    var uid: String?
    var email: String?
    //photo stores the person's image file online, currently not implemented
//    var photo: URL?
    
    
    // image of the person defauls to the image Inspiration-1, location defauls to nil, later may be updated by the person
    init(name: String, image: UIImage = UIImage(named: "Inspiration-1")!, locations: [CLLocationCoordinate2D]? = nil){
        self.name = name
        self.locations = locations
        self.image = image
    }
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as! [String: Any]
        self.name = value["personName"] as! String
        self.email = value["email"] as! String!
    }
    
    func toAnyObject() -> Any {
        return [
            "personName": name,
            "email": email
        ]
    }
    
}
