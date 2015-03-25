//
//  LotsViewController.swift
//  ParkShark
//
//  Created by Steven Gerhard on 11/19/14.
//  Copyright (c) 2014 ParkShark. All rights reserved.
//

import UIKit

class LotsViewController: UITableViewController, NSURLConnectionDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var dataProvider = ParkSharkDataProvider()
        //dataProvider.getWebsiteData()
    }
    
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return parkingLots.numberOfLots();
        return 1;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as UITableViewCell
        return cell;
    }
    */
}