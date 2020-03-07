//
//  ViewController.swift
//  Navgation
//
//  Created by Jeremy on 2019/2/15.
//  Copyright © 2019 Jeremy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        let sc = UISearchController.init(searchResultsController: nil)
        navigationItem.searchController = sc
        navigationItem.hidesSearchBarWhenScrolling = true
        let tableView = UIScrollView.init(frame: view.bounds)
        tableView.contentSize = CGSize.init(width: tableView.frame.size.width, height: 1000)
        self.view.addSubview(tableView)
        
        sc.delegate = self as UISearchControllerDelegate
        let scb = sc.searchBar
        scb.tintColor = UIColor.white
        scb.barTintColor = UIColor.white
        
        if let textfield = scb.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.blue
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
                
            }
        }
        
        if let navigationbar = self.navigationController?.navigationBar {
            navigationbar.barTintColor = UIColor.blue
        }
    }
}

