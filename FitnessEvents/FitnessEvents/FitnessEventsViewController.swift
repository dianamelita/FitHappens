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

    var service: Service!
    
    private var filteredLocations = [String]()
    private var originalFitnessEvents: [FitnessEvent] = []
    private var filteredFitnessEvents = [FitnessEvent]()
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var filterButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getAllFitnessEvents), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.beginRefreshing()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        getAllFitnessEvents()
    }

    @objc private func getAllFitnessEvents() {
        
        filterButton.isEnabled = false
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
                
                self.filteredLocations = []
                self.originalFitnessEvents = events?.sorted(by: { $0.start < $1.start }) ?? []
                self.filteredFitnessEvents = self.originalFitnessEvents
                self.filterButton.isEnabled = true
                self.filterButton.setImage(UIImage(named: "filter_off_white"), for: .normal)
                self.tableView.reloadData()
            }
        })
    }
    
    private func numberOfEventsAt(locations: [String]) -> [String:Int] {
        
        var locationOccurences: [String:Int] = [:]
        for item in locations {
            
            locationOccurences[item] = (locationOccurences[item] ?? 0) + 1
        }
        return locationOccurences
    }
}

extension FitnessEventsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "eventDetailsSegue" else {
            
            if  let filterViewController = segue.destination.children.first as? FilterEventsViewController {
                
                filterViewController.delegate = self
                let eventsAtLocations = numberOfEventsAt(locations: originalFitnessEvents.map{ $0.location.city })
                filterViewController.fitnessEventsLocations = eventsAtLocations
                filterViewController.selectedLocations = filteredLocations
            }
            return
        }
        
        if  let detailsViewController = segue.destination as? EventDetailsViewController,
            let selectedIndex = tableView.indexPathForSelectedRow {
            
            let selectedEvent = filteredFitnessEvents[selectedIndex.row]
            detailsViewController.event = selectedEvent
            tableView.deselectRow(at: selectedIndex, animated: false)
        }
    }
}

extension FitnessEventsViewController: FilterDelegate {
    
    func didSelectLocations(_ filterViewController: FilterEventsViewController, _ selectedLocations: [String]) {
        
        if selectedLocations.isEmpty {
            
            filteredLocations = selectedLocations
            filteredFitnessEvents = originalFitnessEvents
            filterButton.setImage(UIImage(named: "filter_off_white"), for: .normal)
        } else {
            
            filteredLocations = selectedLocations
            filterButton.setImage(UIImage(named: "filter_on_white"), for: .normal)
            
            filteredFitnessEvents = originalFitnessEvents.filter({ (event) -> Bool in
                return filteredLocations.contains(event.location.city)
            })
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func didCancel(_ filterViewController: FilterEventsViewController) {
        
        dismiss(animated: true, completion: nil)
    }
}

extension FitnessEventsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredFitnessEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier:
            "fitnessEventCell", for: indexPath) as? FitnessEventTableViewCell else {
                
                return UITableViewCell()
        }
        
        let event = filteredFitnessEvents[indexPath.row]
        tableCell.update(with: event)
        return tableCell
    }
}

extension FitnessEventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if filteredLocations.isEmpty {
            
            return nil
        } else if filteredLocations.count == 1 {
            
            return "Active filter for \(filteredLocations.count) location."
        }
        return "Active filter for \(filteredLocations.count) locations."
    }
}
