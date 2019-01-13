//
//  FilterEventsViewController.swift
//  FitnessEvents
//
//  Created by Diana Ivascu on 12/4/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import UIKit

protocol FilterDelegate: class {
    
    func didSelectLocations(_ filterViewController: FilterEventsViewController, _ selectedLocations: [String])
    func didCancel(_ filterViewController: FilterEventsViewController)
}

class FilterEventsViewController: UIViewController {
    
    weak var delegate: FilterDelegate?
    var fitnessEventsLocations = [String:Int]()
    var selectedLocations = [String]()
    
    private var sortedLocations = [String]()
    
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        
        sortedLocations = Array(fitnessEventsLocations.keys).sorted()
    }
    
    @IBAction private func didTapDone(_ sender: UIButton) {
        
        delegate?.didSelectLocations(self, selectedLocations)
    }
    
    @IBAction private func didTapCancel(_ sender: UIBarButtonItem) {
        
        delegate?.didCancel(self)
    }
    
    @IBAction private func didTapClear(_ sender: UIBarButtonItem) {
        
        selectedLocations.removeAll()
        tableView.reloadData()
    }
}

extension FilterEventsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fitnessEventsLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        let location = sortedLocations[indexPath.row]
        let numberOfLocations = fitnessEventsLocations[location]
        
        tableCell.textLabel?.text = "\(location) (\(numberOfLocations ?? 0))"
        
        if selectedLocations.contains(location) {
        
            tableCell.accessoryType = .checkmark
        } else {
            
            tableCell.accessoryType = .none
        }
        return tableCell
    }
}

extension FilterEventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .checkmark
        selectedLocations.append(sortedLocations[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .none
        selectedLocations = selectedLocations.filter{ $0 != sortedLocations[indexPath.row] }
    }
}
