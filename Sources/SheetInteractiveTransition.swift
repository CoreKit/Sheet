//
//  SheetInteractiveTransition.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 03. 24..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

import UIKit

class SheetInteractiveTransition: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {

    private var currentPercentage: CGFloat = -1
    private var panRecognizer: UIPanGestureRecognizer?
    private weak var viewController: SheetViewController!

    init(viewController: SheetViewController) {
        super.init()

        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.gestureRecognized(_:)))
        recognizer.maximumNumberOfTouches = 1
        recognizer.cancelsTouchesInView = false
        recognizer.delegate = self

        self.panRecognizer = recognizer
        self.viewController = viewController
        self.viewController.contentView.addGestureRecognizer(recognizer)
    }

    @objc func gestureRecognized(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.currentPercentage = -1
        case .changed:
            let translation = recognizer.translation(in: self.viewController.contentView)
            let height = self.viewController.contentView.bounds.height
            let percent = translation.y / height
            var y = height * percent
            if percent < 0 {
                y = 20 * atan(translation.y / 120) + translation.y / 10
            }
            self.currentPercentage = percent
            self.viewController.overlayView.alpha = 1 - self.currentPercentage
            self.viewController.contentView.transform = CGAffineTransform(translationX: 0, y: y)

            self.update(self.currentPercentage)
        case .ended:
            if self.currentPercentage > 0.05 {
                self.viewController.dismiss(animated: true, completion: nil)
                self.finish()
            }
            else {
                self.viewController.contentView.transform = .identity
                self.cancel()
            }
            self.currentPercentage = -1
        default:
            break
        }
    }
}
