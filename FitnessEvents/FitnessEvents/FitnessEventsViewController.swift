//
//  FitnessEventsViewController.swift
//  FitnessEvents
//
//  Created by Diana Ivascu on 11/1/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import UIKit
import Service
import Model
import Logging

class FitnessEventsViewController: UIViewController {

    private var fitnessEvents: [FitnessEvent] = []
    var service: Service!
    
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getAllFitnessEvents), for: .valueChanged)
        
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.beginRefreshing()
        getAllFitnessEvents()
    }

    @objc private func getAllFitnessEvents() {
        
        self.service.fitnessEvent.retrieveEvents(from: Date(),
                                                 completion: { (events, error) in
            DispatchQueue.main.async {
                
                self.tableView.refreshControl?.endRefreshing()
                if let error = error {

                    self.tableView.displayMessage("No Fitness events found. Please try again later.")
                    log.errorMessage("No Fitness events found. The following error occured: \(error.localizedDescription)")
                    return
                }
                self.tableView.hideMessageLabel()
                self.fitnessEvents = events?.sorted(by: { $0.start < $1.start}) ?? []
                self.tableView.reloadData()
            }
        })
    }
}

extension FitnessEventsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fitnessEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier:
            "fitnessEventCell", for: indexPath) as? FitnessEventTableViewCell else {
                
                return UITableViewCell()
        }
        
        let event = fitnessEvents[indexPath.row]
        tableCell.update(with: event)
        return tableCell
    }
}

extension FitnessEventsViewController {
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        
        guard segue.identifier == "eventDetailsSegue" else { return }
        if  let detailsViewController = segue.destination as? EventDetailsViewController,
            let selectedIndex = tableView.indexPathForSelectedRow {
 
            let selectedEvent = fitnessEvents[selectedIndex.row]
            detailsViewController.event = selectedEvent
            tableView.deselectRow(at: selectedIndex, animated: false)
        }
    }
}
