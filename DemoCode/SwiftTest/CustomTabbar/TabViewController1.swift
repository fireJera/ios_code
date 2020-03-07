//
//  TabViewController1.swift
//  CustomTabbar
//
//  Created by Jeremy on 2019/1/18.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

import UIKit

class TabViewController1: UITabBarController {

    init() {
        var array = [ViewController]()
        for _ in 0..<3 {
            let view = ViewController()
            view.view.backgroundColor = UIColor.yellow;
            array.append(view)
            view.tabBarItem.image = UIImage.init(named: "liaotian_weixuan")
            view.tabBarItem.selectedImage = UIImage.init(named: "liaotian_xuanzhong")
            view.tabBarItem.title = "111"
        }
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = array
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 0, y: 0, width: 160, height: 160)
        button.setImage(UIImage(named: "fabu"), for: .normal)
        button.center = self.tabBar.center
        button.addTarget(self, action: #selector(add), for: .touchUpInside)
        button.backgroundColor = UIColor.black
        var frame = button.frame
        frame.origin.y -= 10
        button.frame = frame
        self.view.addSubview(button)
    }
    
    @objc func add() {
    
    }
}
