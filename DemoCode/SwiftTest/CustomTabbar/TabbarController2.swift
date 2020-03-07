//
//  TabbarController2.swift
//  CustomTabbar
//
//  Created by Jeremy on 2019/1/18.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

import UIKit

class TabbarController2: UITabBarController {
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
        self.tabBar.insertSubview(self.drawImage(), at: 0)
        self.viewControllers = array

//        self.setValue(tabBar, forKeyPath: "tabBar")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
    }
    
    func drawImage() -> UIImageView {
        var radius = 30.0
        let topHeight: CGFloat = 12.0
        let temp : Double = Double(topHeight)
        var allFloat = pow(radius, 2) - pow(radius - temp, 2)
        var ww = sqrt(allFloat)
        let width = self.view.frame.size.width
        var x:CGFloat = 0
        let frame = CGRect(x: x, y: -topHeight, width: width, height: self.tabBar.frame.size.height)
        var imageView = UIImageView.init(frame: frame)
        var size = imageView.frame.size
        var layer = CAShapeLayer()
        var path = UIBezierPath()
        path.move(to: CGPoint(x:size.width / 2 - CGFloat(ww), y:topHeight))
        var angleH = 0.5 * ((radius - temp) / radius)
        var startAngle: CGFloat = CGFloat(1 + angleH) * CGFloat(M_PI)
        var endAngle: CGFloat = CGFloat(2 - angleH) * CGFloat(M_PI)
        path.addArc(withCenter: CGPoint.init(x: size.width / 2, y: CGFloat(radius)), radius: CGFloat(radius), startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addLine(to: CGPoint.init(x: size.width / 2 + CGFloat(ww), y: topHeight))
        path.addLine(to: CGPoint.init(x: size.width, y: topHeight))
        path.addLine(to: CGPoint.init(x: size.width, y: size.height))
        path.addLine(to: CGPoint.init(x: 0, y: size.height))
        path.addLine(to: CGPoint.init(x: 0, y: topHeight))
        path.addLine(to: CGPoint.init(x: size.width / 2 - CGFloat(ww), y: topHeight))
        layer.path = path.cgPath
        layer.fillColor = UIColor.white.cgColor
        layer.strokeColor = UIColor.init(white: 0.765, alpha: 1).cgColor
        layer.lineWidth = 0.5
        imageView.layer.addSublayer(layer)
        return imageView
    }
    
    // 画背景的方法，返回 Tabbar的背景
//    - (UIImageView *)drawTabbarBgImageView
//    {
//    NSLog(@"tabBarHeight：  %f" , tabBarHeight);// 设备tabBar高度 一般49
//    CGFloat radius = 30;// 圆半径
//    CGFloat allFloat= (pow(radius, 2)-pow((radius-standOutHeight), 2));// standOutHeight 突出高度 12
//    CGFloat ww = sqrtf(allFloat);
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -standOutHeight,ScreenW , tabBarHeight +standOutHeight)];// ScreenW设备的宽
//    //    imageView.backgroundColor = [UIColor redColor];
//    CGSize size = imageView.frame.size;
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(size.width/2 - ww, standOutHeight)];
//    NSLog(@"ww: %f", ww);
//    NSLog(@"ww11: %f", 0.5*((radius-ww)/radius));
//    CGFloat angleH = 0.5*((radius-standOutHeight)/radius);
//    NSLog(@"angleH：%f", angleH);
//    CGFloat startAngle = (1+angleH)*((float)M_PI); // 开始弧度
//    CGFloat endAngle = (2-angleH)*((float)M_PI);//结束弧度
//    // 开始画弧：CGPointMake：弧的圆心  radius：弧半径 startAngle：开始弧度 endAngle：介绍弧度 clockwise：YES为顺时针，No为逆时针
//    [path addArcWithCenter:CGPointMake((size.width)/2, radius) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
//    // 开始画弧以外的部分
//    [path addLineToPoint:CGPointMake(size.width/2+ww, standOutHeight)];
//    [path addLineToPoint:CGPointMake(size.width, standOutHeight)];
//    [path addLineToPoint:CGPointMake(size.width,size.height)];
//    [path addLineToPoint:CGPointMake(0,size.height)];
//    [path addLineToPoint:CGPointMake(0,standOutHeight)];
//    [path addLineToPoint:CGPointMake(size.width/2-ww, standOutHeight)];
//    layer.path = path.CGPath;
//    layer.fillColor = [UIColor whiteColor].CGColor;// 整个背景的颜色
//    layer.strokeColor = [UIColor colorWithWhite:0.765 alpha:1.000].CGColor;//边框线条的颜色
//    layer.lineWidth = 0.5;//边框线条的宽
//    // 在要画背景的view上 addSublayer:
//    [imageView.layer addSublayer:layer];
//    return imageView;
//    }
//    +(CGFloat)getTabBarHeight
//    {
//
//    // 获取tabBarHeight
//    UITabBarController *tabBarController =[[UITabBarController alloc]init];
//    return CGRectGetHeight(tabBarController.tabBar.bounds);
//    }
}
