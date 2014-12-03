//
//  NavigateViewController.swift
//  ParkShark
//
//  Created by Steven Gerhard on 11/12/14.
//  Copyright (c) 2014 ParkShark. All rights reserved.
//

import UIKit

class NavigateViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    // MARK: Instance Variables
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
    
    // What google places API is queried for
    var searchedTypes = ["parking"]

    let locationManager = CLLocationManager()
    let dataProvider = GoogleDataProvider()

    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization()
        
        
        
    }
    // MARK: ViewController Navigation
    
    @IBAction func menuButtonPressed() {
        toggleSideMenuView()
    }
    
    // MARK: LocationManagerDelegate functions
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            fetchNearbyPlaces(mapView.camera.target)

            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            fetchNearbyPlaces(location.coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
    
    // converts GeocodeCoordinate to address
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            
            self.addressLabel.unlock()
            if let address = response.firstResult() {
                let lines = address.lines as [String]
                
                /*  Don't want address label currently
                
                self.addressLabel.text = join("\n", lines)
                let labelHeight = self.addressLabel.intrinsicContentSize().height
                self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
                UIView.animateWithDuration(0.25) {
                    self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 2)
                    self.view.layoutIfNeeded()
                }
                */
            
            }
        }
    }

    // MARK: GSMMapViewDelegate Functions
    
    func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
        self.addressLabel.lock()
        
    }
    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        reverseGeocodeCoordinate(position.target)
    }
   
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        let placeMarker = marker as PlaceMarker
        
        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
            infoView.nameLabel.text = placeMarker.place.name
            
            if let photo = placeMarker.place.photo {
                infoView.placePhoto.image = photo
            } else {
                infoView.placePhoto.image = UIImage(named: "generic")
            }
            
            return infoView
        } else {
            return nil
        }
    }
    
    var mapRadius: Double {
      get {
        let region = mapView.projection.visibleRegion()
        let center = mapView.camera.target
     
        let north = CLLocation(latitude: region.farLeft.latitude, longitude: center.longitude)
        let south = CLLocation(latitude: region.nearLeft.latitude, longitude: center.longitude)
        let west = CLLocation(latitude: center.latitude, longitude: region.farLeft.longitude)
        let east = CLLocation(latitude: center.latitude, longitude: region.farRight.longitude)
     
        let verticalDistance = north.distanceFromLocation(south)
        let horizontalDistance = west.distanceFromLocation(east)
        return max(horizontalDistance, verticalDistance)*0.5
      }
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
     
        mapView.clear()
     
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:mapRadius, types: searchedTypes) { places in
            for place: GooglePlace in places {
                
                let marker = PlaceMarker(place: place)
                
                marker.map = self.mapView
            }
        }
    }
    
    // Refreshes the on screen displayed markers
    // Eventually should not need a button for this
    @IBAction func refreshPlaces(sender: AnyObject) {
        fetchNearbyPlaces(mapView.camera.target)
    }
}

// MARK: Custom Marker Class
class PlaceMarker: GMSMarker {
    let place: GooglePlace!
    init(place: GooglePlace) {
        self.place = place
        super.init()
        
        position = place.coordinate
        icon = UIImage(named: place.placeType+"_pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = kGMSMarkerAnimationPop
    }
}