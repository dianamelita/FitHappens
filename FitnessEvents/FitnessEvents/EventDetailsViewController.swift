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
import SafariServices

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
        
        let dateFormatter = DateFormatter()
        let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(locationTapped))
        
        locationLabel.isUserInteractionEnabled = true
        locationLabel.addGestureRecognizer(locationTapGesture)
        locationLabel.text = event.location.description
        
        dateFormatter.dateFormat = "MMMM dd yyyy, HH:mm"
        titleLabel.text = event.name
        dateLabel.text = dateFormatter.string(from: event.start)
        priceLabel.text = formatted(price: event.price)
        updateMap(withAddress: event.location.description)
        mapView.delegate = self
        
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
    
    @objc private func locationTapped(sender: UITapGestureRecognizer) {
        
        openMap(withAddress: event.location.description)
    }
    
    @IBAction private func websiteButtonAction(_ sender: Any) {
        
        let safariViewController = SFSafariViewController(url: event.website)
        present(safariViewController, animated: true, completion: nil)
    }
    
    private func updateMap(withAddress address: String) {
        
        self.mapView.isHidden = true
        retrieveLocationFrom(address: address) { (location) in
            
            if let location = location {
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotation.title = self.event.name
                
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
    
    private func openMap(withAnnotation annotation: MKAnnotation) {
        
        let selectedCoordinate = annotation.coordinate
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: mapView.region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: mapView.region.span)
        ]
        let placemark = MKPlacemark(coordinate: selectedCoordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = event.location.description
        mapItem.openInMaps(launchOptions: options)
    }
    
    private func openMap(withAddress address: String) {
        
        guard let addressBaseUrl = URL(string: "https://maps.apple.com") else { return }
        let addressElement = URLQueryItem(name: "address", value: address)
        var urlComponents = URLComponents(url: addressBaseUrl,
                                          resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [addressElement]
        if let addressUrl = urlComponents?.url {
            
            UIApplication.shared.open(addressUrl)
        }
    }
}

extension EventDetailsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "location")
        view.canShowCallout = true
        view.leftCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return view
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        if let annotation = view.annotation {
        
            openMap(withAnnotation: annotation)
        } else {
            
            openMap(withAddress: event.location.description)
        }
    }
}
