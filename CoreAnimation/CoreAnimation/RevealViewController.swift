//
//  RevealViewController.swift
//  CoreAnimation
//
//  Created by Jeremy on 3/31/17.
//  Copyright © 2017 Jeremy. All rights reserved.
//

import UIKit
import QuartzCore

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

@objc enum RevealControllerOperation: NSInteger {
    case none
    case replaceRearController
    case replaceFrontController
    case replaceRightController
}

@objc protocol RevealViewControllerDelegate {
    @objc optional func reveal(controller: RevealViewController, willMoveTo position: FrontViewPosition)
    @objc optional func reveal(controller: RevealViewController, didMoveTo position: FrontViewPosition)
    @objc optional func reveal(controller: RevealViewController, animationTo position: FrontViewPosition)
    @objc optional func panGestureShouldBegin(revealController: RevealViewController)
    @objc optional func tapGestureShouldBegin(revealController: RevealViewController)
    @objc optional func panGestureRecognizerShouldRecognizeSimultaneously(revealController: RevealViewController, otherGestureRecognizer gestureRecognizer: UIGestureRecognizer)
    @objc optional func tapGestureRecognizerShouldRecognizeSimultaneously(revealController: RevealViewController, otherGestureRecognizer gestureRecognizer: UIGestureRecognizer)
    @objc optional func panGestureBegan(revealController: RevealViewController)
    @objc optional func panGestureEnded(revealController: RevealViewController)
    
    @objc optional func panGestureBegan(revealController: RevealViewController, from location: CGFloat, progress: CGFloat, overProgress: CGFloat)
    @objc optional func panGestureMoved(revealController: RevealViewController, from location: CGFloat, progress: CGFloat, overProgress: CGFloat)
    @objc optional func panGestureEnded(revealController: RevealViewController, to location: CGFloat, progress: CGFloat, overProgress: CGFloat)
    
    @objc optional func willAdd(viewController: UIViewController, to revealController: RevealViewController, for operation: RevealControllerOperation, animated: Bool)
    @objc optional func didAdd(viewController: UIViewController, to revealController: RevealViewController, for operation: RevealControllerOperation, animated: Bool)
    
    @objc optional func animation(revealController: RevealViewController, for operation: RevealControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning
    
    @objc optional func panGestureBegan(revealController: RevealViewController, from location: CGFloat, progress: CGFloat)
    @objc optional func panGestureMoved(revealController: RevealViewController, to location: CGFloat, progress: CGFloat)
    @objc optional func panGestureEnded(revealController: RevealViewController, to location: CGFloat, progress: CGFloat)
}

extension RevealViewController {
//    private var revealViewController: RevealViewController {
//        return RevealViewController(coder: <#NSCoder#>)!
//    }
}

class RevealViewControllerSegueSetConttroller: UIStoryboardSegue {
    
}

class RevealViewControllerSeguePushConttroller: UIStoryboardSegue {
    
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
        
    }
    
    func set(frontViewController: UIViewController, animated: Bool) {
        
    }
    
    func set(rightViewController: UIViewController, animated: Bool) {
        
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
    
    func get(revealWidht: CGFloat, revealOverDraw: CGFloat, for symstry: Int) {
        
    }
    
    func get(bounceBack: Bool, stableDrag: Bool, for symetry: Int) {
        
    }
    
    func get(adjusted frontViewPosition: FrontViewPosition, for symetry: Int) {
        
    }
}

func statusBarAdjustment(view: UIView) -> CGFloat {
    var adjustment: CGFloat = 0
    let app = UIApplication.shared
    let viewFrame = view.convert(view.bounds, to: app.keyWindow)
    let statusBarFrame = app.statusBarFrame
    if viewFrame.intersects(statusBarFrame) == true {
        adjustment = CGFloat(fminf(Float(statusBarFrame.size.width), Float(statusBarFrame.size.height)))
    }
    return adjustment
}

class revealView: UIView {
    weak var c: RevealViewController?
    private(set) var revealView: UIView?
    private(set) var rightView: UIView?
    private(set) var frontView: UIView?
    var disableLayout: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, controller: RevealViewController) {
        super.init(frame: frame)
        self.c = controller
        let bounds = self.bounds
        self.frontView = UIView.init(frame: bounds)
        self.frontView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.reloadShow()
        self.addSubview(self.frontView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func scaledValue(v1: CGFloat, min2: CGFloat, max2: CGFloat, min1: CGFloat, max1: CGFloat) -> CGFloat {
        let result = min2 + (v1 - min1) * ((max2 - min2) / (max1 - min1))
        if result != result {
            return min2
        }
        if result < min2 {
            return min2
        }
        if result > max2 {
            return max2
        }
        return result
    }
    
    func reloadShow() {
        let frontViewLayer = frontView?.layer
        frontViewLayer?.shadowColor = self.c?.frontViewShadowColor?.cgColor
        frontViewLayer?.shadowOpacity = Float((self.c?.frontViewShadowOpacity)!)
        frontViewLayer?.shadowOffset = (self.c?.frontViewShadowOffset)!
        frontViewLayer?.shadowRadius = (self.c?.frontViewShadowRadius)!
    }
}
