//
//  ForceTouchGestureRecognizer.swift
//  bachelor
//
//  Created by Philippe Weidmann on 09.07.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//
import AudioToolbox
import UIKit

class DeepPressGestureRecognizer: UIGestureRecognizer
{
    let threshold: CGFloat

    private var deepPressed: Bool = false

    required init(target: AnyObject?, action: Selector, threshold: CGFloat)
    {
        self.threshold = threshold

        super.init(target: target, action: action)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first
        {
            handleTouch(touch: touch)
        }
    }


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first
        {
            handleTouch(touch: touch)
        }
    }


    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)

        state = deepPressed ? UIGestureRecognizer.State.ended : UIGestureRecognizer.State.failed

        deepPressed = false
    }

    private func handleTouch(touch: UITouch)
    {
        if !deepPressed && (touch.force / touch.maximumPossibleForce) >= threshold
        {
            state = UIGestureRecognizer.State.began


            deepPressed = true
        }
        else if deepPressed && (touch.force / touch.maximumPossibleForce) < threshold
        {
            state = UIGestureRecognizer.State.ended

            deepPressed = false
        }
    }
}

// MARK: DeepPressable protocol extension
protocol DeepPressable
{
    var gestureRecognizers: [UIGestureRecognizer]? { get set }

    func addGestureRecognizer(gestureRecognizer: UIGestureRecognizer)
    func removeGestureRecognizer(gestureRecognizer: UIGestureRecognizer)

    func setDeepPressAction(target: AnyObject, action: Selector)
    func removeDeepPressAction()
}

extension DeepPressable
{
    func setDeepPressAction(target: AnyObject, action: Selector)
    {
        let deepPressGestureRecognizer = DeepPressGestureRecognizer(target: target, action: action, threshold: 0.75)

        self.addGestureRecognizer(gestureRecognizer: deepPressGestureRecognizer)
    }

    func removeDeepPressAction()
    {
        guard let gestureRecognizers = gestureRecognizers else
        {
            return
        }

        for recogniser in gestureRecognizers where recogniser is DeepPressGestureRecognizer
        {
            removeGestureRecognizer(gestureRecognizer: recogniser)
        }
    }
}
