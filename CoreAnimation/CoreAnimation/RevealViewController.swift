//
//  RevealViewController.swift
//  CoreAnimation
//
//  Created by Jeremy on 3/31/17.
//  Copyright © 2017 Jeremy. All rights reserved.
//

import UIKit

@objc enum FrontViewPosition: NSInteger {
    case leftSideMostRemoved
    case leftSideMost
    case leftSide
    case left
    case right
    case rightMost
    case rightMostRemoved
}

@objc enum RevealToggleAnimationType: NSInteger {
    case spring
    case easeOut
}

enum RevealControllerOperation {
    case none
    case replaceRearController
    case replaceFrontController
    case replaceRightController
}

@objc protocol RevealViewControllerDelegate {
    @objc optional func reveal(controller: RevealViewController, willMoveTo position: FrontViewPosition)
    @objc optional func reveal(controller: RevealViewController, didMoveTo position: FrontViewPosition)
    @objc optional func reveal(controller: RevealViewController, animationTo position: FrontViewPosition)
    
}

class RevealViewController: UIViewController {
    var rearViewRevealWidth: CGFloat?
    var rightViewRevealWidth: CGFloat?
    var rearViewRevealOverdraw: CGFloat?
    var rightViewRevealOverdraw: CGFloat?
    var rearViewRevealDisplacement: CGFloat?
    var rightViewRevealDisplacement: CGFloat?
    var draggableBorederWidth: CGFloat?
    var bounceBackOnOverdraw: Bool?
    var bounceBackOnLeftOverDraw: Bool?
    var stableDragOnOverdraw: Bool?
    var stableDragOnOverLeftOverdraw: Bool?
    var presentFronViewHierarchically: Bool?
    var quickFlickVelocity: CGFloat?
    var toggleAnimationDuration: TimeInterval?
    var toggleAnimationType: RevealToggleAnimationType?
    var springDampingRatio: CGFloat?
    var replaceViewAnimationDuration: TimeInterval?
    var frontViewShadowRadius: CGFloat?
    var frontViewShadowOffset: CGSize?
    var frontViewShadowOpacity: CGFloat?
    var frontViewShadowColor: UIColor?
    var clipsViewsToBounds: Bool?
    var extendsPointInsideHit: Bool?
    var delegate: RevealViewControllerDelegate?
    
    var rearViewController: UIViewController?
    var rightViewController: UIViewController?
    var frontViewController: UIViewController?
    
    var panGestureRecognizer: UIPanGestureRecognizer?
    var tapGestureRecognizer: UITapGestureRecognizer?
//    init(rearViewController: UIViewController, frontViewController: UIViewController) {
//        
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func set(rearViewController: UIViewController, animated: Bool) {
        <#function body#>
    }
    
    func set(frontViewController: UIViewController, animated: Bool) {
        <#function body#>
    }
    
    func set(rightViewController: UIViewController, animated: Bool) {
        <#function body#>
    }
    
    func push(frontViewController: UIViewController, animated: Bool) {
        
    }
    
    func set(frontViewPosition: FrontViewPosition, animated: Bool) {
        
    }
    
    @IBAction func revealToggle(_ sender: UIButton) {
        
    }
    
    @IBAction func rightRevealToggle(_ sender: UIButton) {
        
    }
    
    func revealToggle(animated: Bool) {
        
    }
    
    func rightRevealToggle(animated: Bool) {
        
    }
    
    
}
