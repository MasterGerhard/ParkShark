//
//  NavigateViewController.swift
//  ParkShark
//
//  Created by Steven Gerhard on 11/12/14.
//  Copyright (c) 2014 ParkShark. All rights reserved.
//

import UIKit

class NavigateViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet var mapView: GMSMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //
        
        
        
        /*
        self.mapView.myLocationEnabled = true
        self.mapView.mapType = kGMSTypeNormal
        self.mapView.settings.compassButton = true
        self.mapView.settings.myLocationButton = true
        self.mapView.delegate = self
       
       
        var camera : GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.2, zoom: 6)
        self.mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        self.mapView.myLocationEnabled = true
        var marker : GMSMarker = GMSMarker();
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.2)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = self.mapView
         */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func menuButtonPressed() {
        toggleSideMenuView()
    }

}

