//
//  LotsViewController.swift
//  ParkShark
//
//  Created by Steven Gerhard on 11/19/14.
//  Copyright (c) 2014 ParkShark. All rights reserved.
//

import UIKit

class LotsViewController: UITableViewController  {

    var lotsToDisplay: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lotsToDisplay = parkingLots.sharedInstance.lotArray
        
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lotsToDisplay.count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = (self.lotsToDisplay[indexPath.row] as parkingLot).name
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let detailView: LotDetailView = mainStoryboard.instantiateViewControllerWithIdentifier("detailView") as LotDetailView
        detailView.setLotForView(self.lotsToDisplay[indexPath.row] as parkingLot)
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
}