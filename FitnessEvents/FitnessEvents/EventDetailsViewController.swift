//
//  EventDetailsViewController.swift
//  FitnessEvents
//
//  Created by Diana Ivascu on 11/24/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import UIKit
import Model
import MapKit
import Logging
import CoreLocation

class EventDetailsViewController: UIViewController {
    
    var event: FitnessEvent!
    
    @IBOutlet private weak var eventLogo: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleLabel.text = event.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy, HH:mm"
        dateLabel.text = dateFormatter.string(from: event.start)
        priceLabel.text = formatted(price: event.price)
        locationLabel.text = event.location.description
        updateMap(withAddress: event.location.description)
        
        guard event.icon != nil else {
            
            stackView.removeArrangedSubview(eventLogo)
            eventLogo.removeFromSuperview()
            return
        }
        
        eventLogo.sd_setImage(with: event.icon, placeholderImage: nil)
        if eventLogo.image == nil {

            stackView.removeArrangedSubview(eventLogo)
            eventLogo.removeFromSuperview()
        }
    }
    
    @IBAction private func websiteButtonAction(_ sender: Any) {
        
        UIApplication.shared.open(event.website, options: [:]) { (success) in
            
            guard success == true else {
                
                log.errorMessage("Could not open url for event website: \(self.event.website)")
                return
            }
        }
    }
    
    private func updateMap(withAddress address: String) {
        
        self.mapView.isHidden = true
        retrieveLocationFrom(address: address) { (location) in
            
            if let location = location {
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                self.mapView.addAnnotation(annotation)
                self.mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate,
                                                          span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)),
                                                          animated: false)
                self.mapView.isHidden = false
            }
        }
    }
    
    private func retrieveLocationFrom(address: String,
                                      completion: @escaping (_ location: CLLocation?) -> Void) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            
            if let error = error {
                
                log.errorMessage("Could not retrieve geolocation for address: \(self.description). Returned with error: \(error.localizedDescription)")
                completion(nil)
            }
            
            if let placemarks = placemarks,
                let location = placemarks.first?.location {
                
                completion(location)
            }
        }
    }
    
    private func formatted(price: Double) -> String {
        
        if price == 0 {
            
            return "Free entrance"
        } else {
            
            let priceLabelText = "Starting from £"
            let formattedPrice = price.truncatingRemainder(dividingBy: 1) == 0 ?
                                 String(format: "%.0f", price) : String(format: "%.2f", price)
            return priceLabelText + formattedPrice
        }
    }
}
