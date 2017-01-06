//
//  User.swift
//  KOM
//
//  Created by GuoGongbin on 12/31/16.
//  Copyright © 2016 GuoGongbin. All rights reserved.
//

import Foundation
import Firebase
import MapKit

// the person across the app
// for now, the user's name is anonymous, may be changed later
var user = Person(name: "anonymous")

struct Settings {
    static let user = Person(name: "anonymous")
}

enum TimeOrder: Int {
    case ascending = 0
    case descending
}

enum DistanceOrder: Int {
    case near = 0
    case far
}

let tasksReference = FIRDatabase.database().reference(withPath: "Tasks")
let answerReference = FIRDatabase.database().reference(withPath: "Answers")
let personReference = FIRDatabase.database().reference(withPath: "Person")
let locationReference = FIRDatabase.database().reference(withPath: "Locations")


var timeOrder: TimeOrder? = .ascending
var distanceOrder: DistanceOrder? = .near

var userCurrentLocation: CLLocation?
var dayFilter: Double = 0
