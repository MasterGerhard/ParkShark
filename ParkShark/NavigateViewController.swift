//
//  NavigateViewController.swift
//  ParkShark
//
//  Created by Steven Gerhard on 11/12/14.
//  Copyright (c) 2014 ParkShark. All rights reserved.
//

import UIKit


class NavigateViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //
        
        mapView.delegate = self
        
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization()
        
        
        
    }

    @IBAction func menuButtonPressed() {
        toggleSideMenuView()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            NSLog("authorized")
            locationManager.startUpdatingLocation()
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            NSLog("new loc")
    
            self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            locationManager.stopUpdatingLocation()
        }
    }
    

    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            
            //Add this line
            self.addressLabel.unlock()
            if let address = response.firstResult() {
                let lines = address.lines as [String]
                self.addressLabel.text = join("\n", lines)
                
                let labelHeight = self.addressLabel.intrinsicContentSize().height
                self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
                UIView.animateWithDuration(0.25) {
                    self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 2)
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
        self.addressLabel.lock()
        
    }
    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        reverseGeocodeCoordinate(position.target)
    }
}

