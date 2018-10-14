//
//  SlideIntercationController.swift
//  VCAnimations
//
//  Created by Igor Grankin on 14/10/2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import UIKit

class SlideIntercationController: UIPercentDrivenInteractiveTransition {
    var interactionInProgress = false
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    private var toVC: UIViewController!
    
    init(viewController: UIViewController, sliderView: UIView, toViewController: UIViewController) {
        super.init()
        self.viewController = viewController
        self.toVC = toViewController
        prepareGestureRecognizer(in: sliderView)
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_ :)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!)
        var progress = -(translation.y / viewController.view.frame.size.height)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController .performSegue(withIdentifier: "blueSegue", sender: self)
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
            print(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
            
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
}
