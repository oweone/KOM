//
//  TaskDetailViewController.swift
//  KOM
//
//  Created by GuoGongbin on 12/27/16.
//  Copyright © 2016 GuoGongbin. All rights reserved.
//

import UIKit
import MapKit

class TaskDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var task: Task!
    
    let headerHeight: CGFloat = 30

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let childAnswerReference = answerReference.child(task.taskKey!)
        task.answers = []
//        print("task.taskKey: \(task.taskKey)")
        
        childAnswerReference.observe(.value, with: { snapshot in
            if let value = snapshot.value as? NSArray {
                let answers = value.map { Answer(value: $0 as! [String : Any]) }
                self.task.answers = answers
            }
         self.tableView.reloadData()
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = "AnswerSegue"
        if segue.identifier == identifier {
            if let answerViewController = segue.destination as? AnswerViewController {
                answerViewController.task = task
            }
        }
    }
    
}
extension TaskDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        return tableView.rowHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            // return the number of answers
            if task.answers == nil {
                return 0
            }else{
                return task.answers!.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskDetailCellIdentifier = "TaskDetailCell"
        let taskAnswerCellIdentifier = "TaskAnswerCell"
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: taskDetailCellIdentifier, for: indexPath) as! TaskDetailTableViewCell
            cell.task = task
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: taskAnswerCellIdentifier, for: indexPath) as! TaskAnswerTableViewCell
            cell.task = task
            cell.answer = task.answers?[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            
            let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: headerHeight)
            let view = UIView(frame: rect)
            
            let label = UILabel(frame: view.frame)
            if task.answers?.count == 0 {
                label.text = "  no answers"
            }else{
                label.text = "  \(task.answers!.count) answers"
            }
            
            label.clipsToBounds = true
            label.backgroundColor = UIColor.lightGray
            label.layer.cornerRadius = 15
            view.addSubview(label)
            
            return view
        }else {
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return headerHeight
        }
    }

}
