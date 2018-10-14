//
//  GreenViewController.swift
//  VCAnimations
//
//  Created by Igor Grankin on 13/10/2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import UIKit

class GreenViewController: UIViewController {

    @IBOutlet weak var sliderView: UIView!
    
    var slideInteractionController: SlideIntercationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        sliderView.addGestureRecognizer(gesture)
        let blueVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "blueVC")
        slideInteractionController = SlideIntercationController(viewController: self, sliderView: sliderView, toViewController: blueVC)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "blueSegue", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "blueSegue",
            let destinationViewController = segue.destination as? BlueViewController {
            destinationViewController.transitioningDelegate = self
        }
    }

}

extension GreenViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let blueVC = presented as? BlueViewController
            else {
                return nil
        }
        return PresentAnimationController(originFrame: sliderView.frame, interactionController: slideInteractionController)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let blue = dismissed as? BlueViewController
            else {
                return nil
        }
        return DismissAnimationController(originFrame: sliderView.frame)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? PresentAnimationController,
        let interactionController = animator.interactionController,
        interactionController.interactionInProgress
            else {
                return nil
        }
        return interactionController
    }

}
