//
//  DismissAnimationController.swift
//  VCAnimations
//
//  Created by Igor Grankin on 14/10/2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import UIKit

class DismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
        let fromVC = transitionContext.viewController(forKey: .from),
        let snapshot = fromVC.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        let containerView = transitionContext.containerView
        var finalFrame = transitionContext.finalFrame(for: fromVC)
        finalFrame.origin.y = finalFrame.size.height
        var slider: UIView!
        for subview in toVC.view.subviews {
            if subview.tag == 123 {
                slider = subview
                break
            }
        }
        if slider == nil {
            return
        }
        
        containerView.insertSubview(toVC.view, at: 0)
        containerView.addSubview(snapshot)
        containerView.addSubview(slider)
        fromVC.view.isHidden = true
        slider.frame.origin.y = -slider.frame.size.height
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                slider.frame = self.originFrame
                snapshot.frame = finalFrame
            })
        }) { _ in
            toVC.view.isHidden = false
            snapshot.removeFromSuperview()
            toVC.view.addSubview(slider)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    

}
