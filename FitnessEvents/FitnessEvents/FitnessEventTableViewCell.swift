//
//  FitnessEventTableViewCell.swift
//  FitnessEvents
//
//  Created by Diana Ivascu on 11/17/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import UIKit
import Model
import SDWebImage

class FitnessEventTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var eventImage: UIImageView!
    @IBOutlet private weak var eventLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var innerView: UIView!
    
    private static let imagePlaceholderNames = ["fitness", "gym", "dumbbell", "running"]
    
    func update(with event: FitnessEvent) {
        
        locationLabel.text = event.location.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateLabel.text = dateFormatter.string(from: event.start)
        
        eventLabel.text = event.name
        let randomImagePlaceholder = FitnessEventTableViewCell.imagePlaceholderNames.randomElement()
        eventImage.sd_setImage(with: event.icon, placeholderImage: UIImage(named: randomImagePlaceholder ?? "fitness"))
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
        if highlighted == true {
            
            innerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
            
            innerView.backgroundColor = .white
        }
    }

    override func prepareForReuse() {
        
        eventImage.sd_cancelCurrentImageLoad()
    }
}
