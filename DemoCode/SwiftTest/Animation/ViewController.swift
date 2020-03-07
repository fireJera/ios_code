//
//  ViewController.swift
//  Animation
//
//  Created by Jeremy on 2019/1/18.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {

    var label : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UILabel.init(frame: CGRect.init(x: 10, y: 100, width: self.view.frame.size.width, height: 30))
        label!.text = "这是个测试，现在时间北京时间23点30分"
        label!.textColor = UIColor.black
        self.view.addSubview(label!)
        
        let button = UIButton.init(type:.custom)
        button.frame = CGRect(x: 100, y: 200, width: 100, height: 100)
        self.view.addSubview(button)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(animate), for: .touchUpInside)
        
//        let string = NSAttributedString(string: "123456789", attributes: [kCTFontAttributeName as String : UIFont.systemFont(ofSize: 15)])
//        let line = CTLineCreateWithAttributedString(string)
//        let runArray = CTLineGetGlyphRuns(line)
//
//        for runIndex in 0..<CFArrayGetCount(runArray) {
////            let runFont =
//        }
    }
    @objc func animate() {
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.duration = 1.0
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.delegate = self
        label!.layer.add(animation, forKey: "strokeEnd")
    }
}

