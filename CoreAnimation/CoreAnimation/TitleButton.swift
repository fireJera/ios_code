//
//  TitleButton.swift
//  CoreAnimation
//
//  Created by Jeremy on 3/30/17.
//  Copyright © 2017 Jeremy. All rights reserved.
//

import UIKit
class TitleButton: UIButton {
//    var title: String?
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.backgroundColor = UIColor.gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
