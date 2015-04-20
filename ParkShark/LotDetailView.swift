//
//  lotDetailView.swift
//  ParkShark
//
//  Created by Steven Gerhard on 3/25/15.
//  Copyright (c) 2015 ParkShark. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LotDetailView: UIViewController {
    
    var lot: parkingLot!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var totalNumSpacesLabel: UILabel!
    
    @IBOutlet weak var availableSpacesLabel: UILabel!
    
    @IBOutlet weak var permitsAcceptedLabel: UILabel!
    
    
    // *IMPORTANT*
    // I would have lot set in an initializer but
    // must use specific initializer for storyboard.
    // Call this function before presenting the view
    func setLotForView(lotForView:parkingLot) {
        self.lot = lotForView
    }
    
    override func viewDidLoad() {
        if let name = self.lot.name {
                setLotNameLabel(name)
        }
        if (self.lot.isOpen!) {
            if let totalSpots = self.lot.numberOfSpaces {
                setTotalSpotsLabel(String(totalSpots))
            }
            if let availableSpots = self.lot.numberOfFreeSpaces {
                setAvailableSpotsLabel(String(availableSpots))
            }
            if let permitsAvailable = self.lot.permitsAccepted {
                setPermitsAvailableText(permitsAvailable)
            }
        }
            else {
                self.setLotClosed()
            }
        }

    
    @IBAction func startNavigation(sender: UIButton) {
        if let coordinate = self.lot?.getCLLocation() {
            var placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            var mapitem = MKMapItem(placemark: placemark)
            mapitem.name = self.lot?.name!
            mapitem.openInMapsWithLaunchOptions(nil)
        }
        
    }
    
    func setLotNameLabel(name:String) {
        self.nameLabel.text = name
    }
    
    func setTotalSpotsLabel(totalSpots:String) {
        var text = "Total parking spots: " + totalSpots
        self.totalNumSpacesLabel.text = text
    }
    
    func setAvailableSpotsLabel(available:String) {
        var text = "Number of free spots: " + available
        self.availableSpacesLabel.text = text
    }
    
    func setPermitsAvailableText(permits:Array<String>) {
        var textLabel = "Parking permits accepted:"
        for pass in permits {
            textLabel = textLabel + "\n" + pass
        }
        self.permitsAcceptedLabel.text = textLabel
    }
    
    func setLotClosed() {
        self.totalNumSpacesLabel.text = "Sorry this lot is closed"
        self.availableSpacesLabel.text = ""
        self.permitsAcceptedLabel.text = ""
    }
    
    
    
    
    
    
    
    
}