
//
//  TabBarController.swift
//  CustomTabbar
//
//  Created by Jeremy on 2019/1/19.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    init() {
        var array = [ViewController]()
        for _ in 0..<2 {
            let view = ViewController()
            view.view.backgroundColor = UIColor.yellow;
            array.append(view)
            view.tabBarItem.image = UIImage.init(named: "liaotian_weixuan")
            view.tabBarItem.selectedImage = UIImage.init(named: "liaotian_xuanzhong")
            view.tabBarItem.title = "111"
        }
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = array
        let tabbar = CustomTabbar()
        self.setValue(tabbar, forKeyPath: "tabBar")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
    }
}
