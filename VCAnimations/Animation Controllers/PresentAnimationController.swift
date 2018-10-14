//
//  PresentAnimationController.swift
//  VCAnimations
//
//  Created by Igor Grankin on 13/10/2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import UIKit

class PresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let originFrame: CGRect
    let interactionController: SlideIntercationController?
    
    init(originFrame: CGRect, interactionController: SlideIntercationController?) {
        self.originFrame = originFrame
        self.interactionController = interactionController
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
        let fromVC = transitionContext.viewController(forKey: .from),
        let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        var slider: UIView!
        for subview in fromVC.view.subviews {
            if subview.tag == 123 {
                slider = subview
                break
            }
        }
        if slider == nil {
            return
        }
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        containerView.addSubview(slider)
        toVC.view.isHidden = true
        snapshot.frame.origin.y = snapshot.frame.size.height
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                                        slider.frame.origin.y = -slider.frame.size.height
                                        snapshot.frame = finalFrame
                                    })
            
        }) { _ in
            toVC.view.isHidden = false
            snapshot.removeFromSuperview()
            slider.frame = self.originFrame
            slider.removeFromSuperview()
            fromVC.view.addSubview(slider)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    

}
