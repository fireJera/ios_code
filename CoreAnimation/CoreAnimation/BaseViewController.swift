//
//  BaseViewController.swift
//  CoreAnimation
//
//  Created by Jeremy on 3/30/17.
//  Copyright © 2017 Jeremy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var operateTitleArray = [String]()
    let controllerTitle = "默认标题"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initData() {
//        self.operateTitleArray
    }
    
    func initView() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
        containerView.backgroundColor = UIColor.cyan
        self.view.addSubview(containerView)
        
        let label = UILabel(frame: CGRect(x: 0, y: 20, width: SCREEN_WIDTH, height: 40))
        label.textAlignment = .center
        label.text = self.controllerTitle
        containerView.addSubview(label)
        
        self.view.backgroundColor = UIColor.white
        
        if operateTitleArray != nil && operateTitleArray.count > 0 {
            let row = self.operateTitleArray.count % 4 == 0 ? self.operateTitleArray.count / 4 : self.operateTitleArray.count / 4 + 1
            let operateView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - CGFloat(row * 50 + 20), width: SCREEN_WIDTH, height: CGFloat(row * 50 + 20)))
            self.view.addSubview(operateView)
            for i in 0..<operateTitleArray.count {
                let btn = TitleButton.init(frame: rectForBtn(index: i, totalNum: self.operateTitleArray.count), title: operateTitleArray[i])
                btn.tag = i
                btn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
                operateView.addSubview(btn)
            }
        }
        
        //注册该页面可以执行滑动切换
//        SWRevealViewController *revealController = self.revealViewController;
//        [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    }
    
    func rectForBtn(index: Int, totalNum: Int) -> CGRect {
        
    }
    
    func clickButton(btn: UIButton) {
        
    }
}
