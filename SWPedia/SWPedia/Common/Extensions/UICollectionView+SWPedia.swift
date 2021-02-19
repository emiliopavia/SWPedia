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
    
    func deselectItems(transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        let selectedIndexPaths = indexPathsForSelectedItems ?? []

        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { context in
                selectedIndexPaths.forEach {
                    self.deselectItem(at: $0, animated: context.isAnimated)
                }
            }, completion: { context in
                if context.isCancelled {
                    selectedIndexPaths.forEach {
                        self.selectItem(at: $0, animated: false, scrollPosition: .top)
                    }
                }
            })
        } else {
            selectedIndexPaths.forEach {
                self.deselectItem(at: $0, animated: false)
            }
        }
    }
}
