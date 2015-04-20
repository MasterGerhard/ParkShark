//
//  AboutViewController.swift
//  ParkShark
//
//  Created by Steven Gerhard on 11/19/14.
//  Copyright (c) 2014 ParkShark. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, navMenuBarButtionItem {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var menuTitle : String? = "Menu"
        var menuButton = UIBarButtonItem(title: menuTitle, style: UIBarButtonItemStyle.Plain, target: self, action: "menuButtonPressed")
        
        navigationItem.leftBarButtonItem = menuButton
    }
    
    func menuButtonPressed() {
        toggleSideMenuView()
    }

}