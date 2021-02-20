//
//  KeyboardObserver.swift
//  SWPedia
//
//  Created by Emilio Pavia on 20/02/21.
//

import UIKit

public class KeyboardObserver {
    public typealias FrameChangeHandler = (CGRect?) -> Void
    
    public let notificationCenter: NotificationCenter
    public let frameChangeHandler: FrameChangeHandler
    
    public init(notificationCenter: NotificationCenter = NotificationCenter.default, frameChangeHandler: @escaping FrameChangeHandler) {
        self.notificationCenter = notificationCenter
        self.frameChangeHandler = frameChangeHandler
        
        addObservers(to: notificationCenter)
    }
    
    deinit {
        removeObservers(from: notificationCenter)
    }
    
    private func addObservers(to notificationCenter: NotificationCenter) {
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeObservers(from notificationCenter: NotificationCenter) {
        notificationCenter.removeObserver(self)
    }
    
    @objc
    private func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo else { return }
        
        let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue

        let animationCurve = UIView.AnimationCurve(rawValue: curve)!
        let animator = UIViewPropertyAnimator(duration: duration, curve: animationCurve) {
            self.frameChangeHandler(frame)
        }
        animator.startAnimation()
    }
    
    @objc
    private func keyboardWillHide(_ sender: Notification) {
        guard let userInfo = sender.userInfo else { return }
        
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue

        let animationCurve = UIView.AnimationCurve(rawValue: curve)!
        let animator = UIViewPropertyAnimator(duration: duration, curve: animationCurve) {
            self.frameChangeHandler(nil)
        }
        animator.startAnimation()
    }
}
