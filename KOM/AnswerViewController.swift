//
//  AnswerViewController.swift
//  KOM
//
//  Created by GuoGongbin on 1/1/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {

    
    @IBOutlet weak var textView: UITextView!
    var task: Task!
    let text = "write your answer here"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text
        textView.textColor = UIColor.lightGray
        textView.delegate = self
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let answerText = textView.text
        
        if answerText == "" || answerText == nil {
            let alert = UIAlertController(title: "Please type something to answer this question.", message: " You haven't answered this question yet!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let answeringTime = dateFormatter.string(from: Date())
        
        let answer = Answer(person: user, answer: answerText!, time: answeringTime)
        
        let childAnswerReference = answerReference.child(task.taskKey!)
        if task.answers == nil {
            task.answers = []
        }
        task.answers!.append(answer)
//        let answer2 = task.answers?.first?.toAnyObject()
        let answers = task.answers!.map { $0.toAnyObject() }
        
        childAnswerReference.setValue(answers)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension AnswerViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text = ""
        textView.textColor = UIColor.black
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count == 0 {
            textView.text = text
            textView.textColor = UIColor.lightGray
            textView.resignFirstResponder()
        }
    }
}
