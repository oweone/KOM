//
//  TaskAnswerTableViewCell.swift
//  KOM
//
//  Created by GuoGongbin on 12/27/16.
//  Copyright © 2016 GuoGongbin. All rights reserved.
//

import UIKit

class TaskAnswerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    var task: Task!{
        didSet{
            updateUI()
        }
    }
    var answer: Answer? {
        didSet{
            updateUI()
        }
    }
    
    func updateUI() {
        userImageView.image = answer?.person.image
        userNameLabel.text = answer?.person.name
        if answer?.time != nil {
            timeLabel.text = "answered at: \(answer!.time)"
        }
        
        answerLabel.text = answer?.answer
    }

}
