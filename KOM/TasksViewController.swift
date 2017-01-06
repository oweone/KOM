//
//  TasksViewController.swift
//  KOM
//
//  Created by GuoGongbin on 12/27/16.
//  Copyright © 2016 GuoGongbin. All rights reserved.
//

import UIKit
import MapKit

class TasksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tasks = [Task]()
    var timeOrderOriginal: TimeOrder!
    var distanceOrderOriginal: DistanceOrder!
    var storedTasks = [Task]()
    
    lazy var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TasksViewController.updateDataSource(refreshControl:)), for: .valueChanged)
        return refreshControl
    }()
    
//    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(refreshControl)
        
        
        // Do any additional setup after loading the view.
        tasksReference.observe(.value, with: { snapshot in
            self.tasks.removeAll(keepingCapacity: false)
            for item in snapshot.children {
                let task = Task(snapshot: item as! FIRDataSnapshot)
                self.tasks.append(task)
            }
            self.tableView.reloadData()
        })
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // set this two variables from Settings
//        timeOrderOriginal = timeOrder
//        distanceOrderOriginal = distanceOrder
        
    }
    
    // pull to refresh the tableView
    func updateDataSource(refreshControl: UIRefreshControl) {
        tasksReference.observeSingleEvent(of: .value, with: { snapshot in
            self.tasks.removeAll(keepingCapacity: false)
            for item in snapshot.children {
                let task = Task(snapshot: item as! FIRDataSnapshot)
                self.tasks.append(task)
            }
            
            if dayFilter > 0 {
                self.filterTasks(filter: dayFilter)
            }
            
            if timeOrder != nil {
                self.sortTasks(timeDescriptor: timeOrder!)
            }
            
            if userCurrentLocation != nil {
                if distanceOrder != nil {
                    self.sortTasks(distanceDescriptor: distanceOrder!)
                }
            }
            
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
        })
    }
    // pull down to triger the filter action, because the tableView needs to connect to the server to get the snapshot. It is done in this way because of scalability and performance.
    // Reordering the data in the tableView doesn't need to reconnect to the server, so, the two actions can be put in the viewWillAppear method.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // filter tasks first, if not, result is not correct
//        if dayFilter > 0 {
//            filterTasks(filter: dayFilter)
//            tableView.reloadData()
//        }
        
        if timeOrder != nil {
            sortTasks(timeDescriptor: timeOrder!)
        }

        //testing userCurrentLocation
//        userCurrentLocation = CLLocation(latitude: 50.9726913, longitude: 50.9726913)
        if userCurrentLocation != nil {
            if distanceOrder != nil {
                sortTasks(distanceDescriptor: distanceOrder!)
            }
        }
        
        tableView.reloadData()
    }
    
    func sortTasks(timeDescriptor: TimeOrder) {
        
        //currently the locale is set to en_US
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        
        //sort the tasks array in time Ascending order
        let sortedTasks = tasks.sorted(by: { (task1, task2) -> Bool in
            
            let date1 = dateFormatter.date(from: task1.time)
            let date2 = dateFormatter.date(from: task2.time)
            
            if date1 != nil && date2 != nil {
                let result = date1!.compare(date2!)
                switch result {
                case .orderedAscending:
                    return true
                case .orderedSame:
                    return true
                case .orderedDescending:
                    return false
                }
            }else{
                return false
            }

        })
        if timeDescriptor == .ascending {
            tasks = sortedTasks
        }else{
            tasks = sortedTasks.reversed()
        }
    }
    
    // compare each of the  locations in array tasks to the userCurrentLocation
    //sort the tasks array in distance Ascending order
    func sortTasks(distanceDescriptor: DistanceOrder) {
        let sortedTasks = tasks.sorted(by: { (task1, task2) -> Bool in
            
            let location1 = CLLocation(latitude: task1.coordinate.latitude, longitude: task1.coordinate.longitude)
            let location2 = CLLocation(latitude: task2.coordinate.latitude, longitude: task2.coordinate.longitude)
            
            let distance1 = location1.distance(from: userCurrentLocation!)
            let distance2 = location2.distance(from: userCurrentLocation!)
            
            if distance1 <= distance2 {
                return true
            }else{
                return false
            }
        })
        if distanceDescriptor == .near {
            tasks = sortedTasks
        }else{
            tasks = sortedTasks.reversed()
        }
    }

    func filterTasks(filter: Double) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let filteredTasks = tasks.filter({ task -> Bool in
            let date = dateFormatter.date(from: task.time)
            let dateBeforeToday = Date(timeInterval: -60 * 60 * 24 * filter, since: Date())
            
            if date != nil {
                let result = date!.compare(dateBeforeToday)
                
                switch result {
                case .orderedAscending:
                    return false
                case .orderedSame:
                    return true
                case .orderedDescending:
                    return true
                }
            }else{
                return false
            }
            
        })
        tasks = filteredTasks
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTaskDetail", let taskDetailViewController = segue.destination as? TaskDetailViewController {
            let cell = sender as! TaskTableViewCell
            taskDetailViewController.task = cell.task
        }
    }
}

extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "TaskCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TaskTableViewCell
        
        cell.task = tasks[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}


