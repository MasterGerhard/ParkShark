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
        
        
        data.getParkingLotData() { lotData in
            
            self.dataRetrieved = true
            
            for parklot in lotData {
                
                var lot = parkingLot()
                lot.Latitude = (parklot["Latitude"] as! NSString).doubleValue as CLLocationDegrees
                lot.Longitude = (parklot["Longitude"] as! NSString).doubleValue as CLLocationDegrees
                lot.carsInLot = (parklot["carsInLot"] as! String).toInt()
                lot.id = (parklot["id"] as! String).toInt()
                lot.name = (parklot["name"] as! String)
                lot.numberOfSpaces = (parklot["numSpaces"] as! String).toInt()
                
                var freeSpaces : Int = lot.numberOfSpaces! - lot.carsInLot!
                if (freeSpaces < 0) {
                    freeSpaces = 0
                }
                lot.numberOfFreeSpaces = freeSpaces
                if( (parklot["open"] as! String) == "1" ) {
                    lot.isOpen = true
                }
                else {
                    lot.isOpen = false
                }
                lot.permitsAccepted = (parklot["permits"] as! String).componentsSeparatedByString(",")
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
