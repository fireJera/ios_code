//
//  RightViewController.swift
//  CoreAnimation
//
//  Created by Jeremy on 3/30/17.
//  Copyright © 2017 Jeremy. All rights reserved.
//

import UIKit

class RightViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        let label = UILabel.init(frame: CGRect(x: SCREEN_WIDTH / 2 - 100, y: 100, width: 200, height: 100))
        label.text = "右边侧滑栏"
        label.font = UIFont.systemFont(ofSize: 22)
        label.textAlignment = .center
        self.view.addSubview(label)
    }
}
