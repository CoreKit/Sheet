//
//  SheetViewController.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 03. 24..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

import UIKit

open class SheetViewController: UIViewController, UIGestureRecognizerDelegate {

    public weak var contentView: ContinuousCornerView!
    public weak var stackView: UIStackView!
    public weak var overlayView: UIView!
    public var margin: CGFloat = 6
    public var padding: CGFloat = 16

    fileprivate var contentBottomConstraint: NSLayoutConstraint!

    public var isCloseableByTap = true
    public var isClosableBySwipe = true
    public var isKeyboardAvoiding = true

    fileprivate var swipeInteractiveTransition: SheetInteractiveTransition!

    convenience init() {
        self.init(nibName: nil, bundle: nil)

        self.modalPresentationCapturesStatusBarAppearance = true
        self.modalPresentationStyle = .overFullScreen
        self.transitioningDelegate = self
    }

    deinit {
        if self.isKeyboardAvoiding {
            self.removeKeyboardAvoiding()
        }
    }

    open override func loadView() {
        super.loadView()

        let overlayView = UIView()
        self.view.addSubview(overlayView)
        self.overlayView = overlayView
        self.overlayView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.overlayView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.overlayView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.overlayView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.overlayView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])

        let contentView = ContinuousCornerView()
        self.view.addSubview(contentView)
        self.contentView = contentView
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        //TODO: on iPad fixed with & center X & Y
        self.contentBottomConstraint = self.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                                                constant: UIScreen.main.bounds.height)
        NSLayoutConstraint.activate([
            self.contentView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: self.margin),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -self.margin),
            contentBottomConstraint
        ])

        let stackView = UIStackView()
        self.contentView.addSubview(stackView)
        self.stackView = stackView
        self.stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: self.padding * 2),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -self.padding * 2),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -self.padding * 2),
            self.contentView.topAnchor.constraint(equalTo: self.stackView.topAnchor, constant: -self.padding * 2)
        ])
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.overlayView.alpha = 0
        self.overlayView.backgroundColor = UIColor(white: 0, alpha: 0.6)

        self.stackView.axis = .vertical
        self.stackView.alignment = .fill
        self.stackView.distribution = .fill
        self.stackView.spacing = self.padding

        if self.isCloseableByTap {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.close))
            recognizer.delegate = self
            recognizer.cancelsTouchesInView = false
            recognizer.delaysTouchesEnded = false
            self.overlayView.addGestureRecognizer(recognizer)
        }

        if self.isClosableBySwipe {
            self.swipeInteractiveTransition = SheetInteractiveTransition(viewController: self)
        }

        if self.isKeyboardAvoiding {
            self.addKeyboardAvoiding()
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
        self.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }

    @objc public func close() {
        let original = self.isClosableBySwipe
        self.isClosableBySwipe = false
        self.dismiss(animated: true, completion: nil)
        self.isClosableBySwipe = original
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.contentView) == true {
            return false
        }
        return true
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    open override var prefersStatusBarHidden: Bool {
        return false
    }
    
    open override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
}

extension SheetViewController: UIViewControllerTransitioningDelegate,
                                  SheetPushAnimatorDelegate,
                                  SheetPopAnimatorDelegate {

    open func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SheetPushAnimator()
    }

    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SheetPopAnimatior()
    }

    func sheetPushAnimations() {
        self.overlayView.alpha = 1
        self.contentBottomConstraint.constant = -self.margin
        self.view.layoutIfNeeded()
    }

    func sheetPopAnimations() {
        self.overlayView.alpha = 0
        self.contentBottomConstraint.constant = UIScreen.main.bounds.height
        self.view.layoutIfNeeded()
    }

    open func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard self.isClosableBySwipe else {
            return nil
        }
        return self.swipeInteractiveTransition
    }
}

extension SheetViewController {

    func addKeyboardAvoiding() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onKeyboardShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onKeyboardHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    func removeKeyboardAvoiding() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func onKeyboardShow(_ notification: Notification) {
        guard self.isKeyboardAvoiding, let userInfo = notification.userInfo,
            let keyboardFrameFinal = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveInt = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int
        else {
            return
        }

        let animationCurve = UIView.AnimationCurve(rawValue: curveInt) ?? .linear
        let animationOptions = UIView.AnimationOptions(rawValue: UInt(animationCurve.rawValue << 16))

        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
            let bottomSpacing = -(keyboardFrameFinal.size.height + self.margin)
            self.contentBottomConstraint.constant = bottomSpacing
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc func onKeyboardHide(_ notification: Notification) {
        guard self.isKeyboardAvoiding, let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveInt = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int
        else {
            return
        }

        let animationCurve = UIView.AnimationCurve(rawValue: curveInt) ?? .linear
        let animationOptions = UIView.AnimationOptions(rawValue: UInt(animationCurve.rawValue << 16))

        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
            self.contentBottomConstraint.constant = -self.margin
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
