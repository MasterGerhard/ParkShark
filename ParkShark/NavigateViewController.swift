//
//  NavigateViewController.swift
//  ParkShark
//
//  Created by Steven Gerhard on 11/12/14.
//  Copyright (c) 2014 ParkShark. All rights reserved.
//

import UIKit
import MapKit

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
        
        self.mapView.camera = GMSCameraPosition.cameraWithLatitude(41.8072, longitude: -72.2525, zoom: 15)
        self.populateMapWithParkingLots()
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
            //mapView.settings.myLocationButton = true

            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            //self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
    
    // converts GeocodeCoordinate to address
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            
            self.addressLabel.unlock()
            if let address = response?.firstResult() {
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
        let placeMarker = marker as ParkingLotMarker
        
     
        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
            infoView.nameLabel.text = placeMarker.lot.name
            if let openSpots = placeMarker.lot.openSpaces {
                if (openSpots == 0) {
                    infoView.numberOfSpotsAvailable.text = "This lot is full"
                }
                if (openSpots == 1) {
                    infoView.numberOfSpotsAvailable.text = "Sorry only 1 spot available"
                }
                if (openSpots > 1) {
                    infoView.numberOfSpotsAvailable.text = "\(openSpots) spots available"
                }
                
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
    
    func populateMapWithParkingLots() {
     
        mapView.clear()
        var app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = true
        parkingLots.sharedInstance.setLotData({
            dataIsSet in
            if dataIsSet {
                for lot in parkingLots.sharedInstance.lotArray {
                    let marker = ParkingLotMarker(lot: lot as parkingLot)
                    marker.map = self.mapView
                }
                app.networkActivityIndicatorVisible = false
            }
        })
    }
    

    @IBAction func centerMap(sender: UIBarButtonItem) {
        self.mapView.camera = GMSCameraPosition.cameraWithLatitude(41.8072, longitude: -72.2525, zoom: 15)

    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        let placeMarker = marker as ParkingLotMarker
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let detailView: LotDetailView = mainStoryboard.instantiateViewControllerWithIdentifier("detailView") as LotDetailView
        detailView.setLotForView(placeMarker.lot)
        self.navigationController?.pushViewController(detailView, animated: true)
        

    }
/* Mark: Adding Custom Button to MarkerInfoView
    
    func replaceCalloutViewForCoordinates(coordinate: CLLocationCoordinate2D, pMapView:GMSMapView) {
        
    }
    
    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
        
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        
    }
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        
    }
  */
}

// MARK: Custom Marker Class
class ParkingLotMarker: GMSMarker {
    let lot: parkingLot!
    init(lot: parkingLot) {
        self.lot = lot
        super.init()
        var cord = CLLocationCoordinate2DMake(lot.Latitude!, lot.Longitude!)
        position = cord
        icon = UIImage(named: "parking_pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = kGMSMarkerAnimationPop

    }
}
