//
//  KeyboardController.swift
//  SWPedia
//
//  Created by Emilio Pavia on 20/02/21.
//

import UIKit

class KeyboardController {
    let scrollView: UIScrollView

    private var keyboardObserver: KeyboardObserver?

    init(scrollView: UIScrollView) {
        self.scrollView = scrollView

        self.keyboardObserver = KeyboardObserver(frameChangeHandler: { [weak self] rect in
            self?.handleKeyboard(rect: rect)
        })
    }

    private lazy var defaultContentInsets: UIEdgeInsets = self.scrollView.contentInset
    private lazy var defaultScrollIndicatorInsets: UIEdgeInsets = self.scrollView.verticalScrollIndicatorInsets

    private func handleKeyboard(rect: CGRect?) {
        guard let superview = scrollView.superview else { return }

        guard let keyboardFrame = rect else {
            scrollView.contentInset.bottom = defaultContentInsets.bottom
            scrollView.verticalScrollIndicatorInsets.bottom = defaultScrollIndicatorInsets.bottom
            return
        }

        let intersection = scrollView.bounds.intersection(scrollView.convert(keyboardFrame, from: nil))

        scrollView.contentInset.bottom = defaultContentInsets.bottom + intersection.height
        scrollView.verticalScrollIndicatorInsets.bottom = defaultScrollIndicatorInsets.bottom + intersection.height

        if scrollView.frame.maxY >= superview.bounds.height - superview.safeAreaInsets.bottom {
            scrollView.verticalScrollIndicatorInsets.bottom -= superview.safeAreaInsets.bottom
        }
    }
}
