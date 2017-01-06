//
//  TaskLocationsViewController.swift
//  KOM
//
//  Created by GuoGongbin on 1/2/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit
import MapKit

class TaskLocationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var userLocations: [CLLocationCoordinate2D]?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        userLocations = user.locations
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? ComposeTaskViewController  {
            let cell = sender as! TaskLocationTableViewCell
            destination.coordinate = cell.coordinate
            destination.locationText = cell.textLabel!.text
        }
        
    }
 
}

extension TaskLocationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userLocations == nil {
            return 0
        }else{
            return userLocations!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LocationCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TaskLocationTableViewCell
        
        if let location = userLocations?[indexPath.row] {
            cell.coordinate = location
        }
        
        return cell
    }    

}
