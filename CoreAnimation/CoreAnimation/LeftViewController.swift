//
//  LeftViewController.swift
//  CoreAnimation
//
//  Created by Jeremy on 3/30/17.
//  Copyright © 2017 Jeremy. All rights reserved.
//

import Foundation
import UIKit

public let SCREEN_WIDTH = UIScreen.main.bounds.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.height

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView?
    var menus = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initView()
    }
    
    func initData() {
        menus = ["基础动画", "关键帧动画", "组动画", "过度动画", "仿射变换", "综合案例"]
    }
    
    func initView() {
        self.view.backgroundColor = UIColor.lightGray
        self.tableView = UITableView(frame: CGRect(x: 0, y: 20, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 20), style: .grouped)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.view.addSubview(tableView!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menus[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
