//
//  SheetPushAnimator.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 03. 24..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

protocol SheetPushAnimatorDelegate {
    func sheetPushAnimations()
}

class SheetPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to)
                as? UIViewController & SheetPushAnimatorDelegate,
            let rootView = toViewController.view
        else {
            return transitionContext.completeTransition(false)
        }

        let containerView = transitionContext.containerView

        rootView.frame = containerView.frame
        containerView.addSubview(rootView)
        rootView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            rootView.topAnchor.constraint(equalTo: containerView.topAnchor),
            rootView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        rootView.layoutIfNeeded()
        let animations = {
            toViewController.sheetPushAnimations()
        }
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveEaseOut,
                       animations: animations) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
