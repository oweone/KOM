//
//  Answer.swift
//  KOM
//
//  Created by GuoGongbin on 12/27/16.
//  Copyright © 2016 GuoGongbin. All rights reserved.
//

import Foundation

class Answer {
    //the person who answers a task
    var person: Person
    // the answer of a task
    var answer: String
    // the time a person answers a task
    var time: String
    
    init(person: Person, answer: String, time: String) {
        self.person = person
        self.answer = answer
        self.time = time
    }
    init(value: [String: Any]) {
        self.person = Person(name: value["personName"] as! String)
        self.answer = value["answer"] as! String
        self.time = value["time"] as! String
    }
    
    func toAnyObject() -> Any {
        return [
            "personName": person.name,
            "answer": answer,
            "time": time
        ]
    }
}
