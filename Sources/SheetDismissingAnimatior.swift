//
//  SheetPopAnimatior.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 03. 24..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

protocol SheetPopAnimatorDelegate {
    func sheetPopAnimations()
}

class SheetPopAnimatior: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from)
                as? UIViewController & SheetPopAnimatorDelegate
        else {
            return transitionContext.completeTransition(false)
        }

        let animations = {
            fromViewController.sheetPopAnimations()
        }

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveEaseOut,
                       animations: animations) { _ in
            let isCancelled = transitionContext.transitionWasCancelled

            if !isCancelled {
                fromViewController.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!isCancelled)
        }
    }
}
