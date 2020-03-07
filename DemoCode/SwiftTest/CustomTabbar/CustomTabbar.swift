//
//  CustomTabbar.swift
//  CustomTabbar
//
//  Created by Jeremy on 2019/1/18.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

import UIKit

class CustomTabbar: UITabBar {
    var centerBtn = UIButton.init(type:.custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        centerBtn.backgroundColor = UIColor.red
        centerBtn.addTarget(self, action: #selector(click), for: .touchUpInside)
        self.addSubview(centerBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let some = NSClassFromString("UITabBarButton")
        centerBtn.frame = CGRect(x: (self.frame.size.width - 160) / 2, y: -80, width: 160, height: 160)
        var btnIndex = 0
        for btn in self.subviews {
            if btn.isKind(of: some!) {
                var frame = btn.frame
                frame.size.width = (self.frame.size.width - centerBtn.frame.size.width) / 2
                if btnIndex < 1 {
                    frame.origin.x = frame.size.width * CGFloat(btnIndex)
                } else {
                    frame.origin.x = frame.size.width * CGFloat(btnIndex) + centerBtn.frame.size.width
                }
                btn.frame = frame
                btnIndex += 1;
                if btnIndex == 0 {
                    btnIndex += 1
                }
            }
        }
        self.bringSubviewToFront(centerBtn)
    }
    
    @objc func click() {
        
    }
}
