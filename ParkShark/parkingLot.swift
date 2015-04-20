//
//  parkingLot.swift
//  ParkShark
//
//  Created by Steven Gerhard on 12/1/14.
//  Copyright (c) 2014 ParkShark. All rights reserved.
//

import Foundation

class parkingLot {
    
    var Latitude : CLLocationDegrees?
    var Longitude : CLLocationDegrees?
    var carsInLot : Int?
    var id : Int?
    var name : String?
    var numberOfSpaces : Int?
    var numberOfFreeSpaces : Int?
    var isOpen : Bool?
    var permitsAccepted : Array<String>?
    
    init(){}
    
    func printLot() {
        println()
        println(Latitude)
        println(Longitude)
        println(carsInLot)
        println(id)
        println(name)
        println(isOpen)
        println(numberOfSpaces)
        println(numberOfFreeSpaces)
        println(permitsAccepted)
        println()
    }
    

    func getCLLocation() -> CLLocationCoordinate2D? {
        if let lat = Latitude {
            if let long = Longitude {
                var cord = CLLocationCoordinate2DMake(self.Latitude!, self.Longitude!)
                return cord
            }
        }
        
        return nil
    }
}





