//
//  parkingLots.swift
//  ParkShark
//
//  Created by Steven Gerhard on 2/11/15.
//  Copyright (c) 2015 ParkShark. All rights reserved.
//

import Foundation

class parkingLots {
    
    var data = BackendData()
    var lotArray: NSMutableArray = []
    var dataRetrieved = false
    
    func setLotData(completionBlock:((Bool)->())?) {
       
        if (self.dataRetrieved) {
            completionBlock!(true)
            return
        }
        
        // lotData is a MutableArray of NSDictionaries
        data.getParkingLotData() { lotData in
            
            self.dataRetrieved = true
            
            for parklot in lotData {
                
                var lot = parkingLot()
                lot.Latitude = (parklot["Latitude"] as NSString).doubleValue as CLLocationDegrees
                lot.Longitude = (parklot["Longitude"] as NSString).doubleValue as CLLocationDegrees
                lot.carsInLot = (parklot["carsInLot"] as String).toInt()
                lot.id = (parklot["id"] as String).toInt()
                lot.name = (parklot["name"] as String)
                lot.numberOfSpaces = (parklot["numSpaces"] as String).toInt()
                lot.openSpaces = (parklot["open"] as String).toInt()
                lot.permitsAccepted = (parklot["permits"] as String).componentsSeparatedByString(",")
                self.lotArray.addObject(lot)
            }
            
            completionBlock!(true)
        }
        
    }
    
    struct Static {
        
        static let instance = parkingLots()
        
    }
    
    class var sharedInstance: parkingLots {
        return Static.instance
    }
    
    
}
