//
//  UICollectionView+SWPedia.swift
//  SWPedia
//
//  Created by Emilio Pavia on 18/02/21.
//

import UIKit

extension UICollectionView {
    func scrollToTop(animated: Bool = false) {
        let inset = adjustedContentInset.top
        setContentOffset(CGPoint(x: 0, y: -inset), animated: animated)
    }
}
