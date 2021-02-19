//
//  RootViewController.swift
//  SWPedia
//
//  Created by Emilio Pavia on 19/02/21.
//

import UIKit

class RootViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredDisplayMode = .oneBesideSecondary
        delegate = self
    }

    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        guard !isCollapsed else { return false }
        viewControllers = [viewControllers.first!, NavigationController(rootViewController: vc)]
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        guard let navigationController = primaryViewController as? UINavigationController else {
            return nil
        }

        guard let viewControllers = navigationController.popToRootViewController(animated: false) else {
            return nil
        }
        
        let secondaryViewController = NavigationController()
        secondaryViewController.viewControllers = viewControllers
        
        return secondaryViewController
    }
    
    override func collapseSecondaryViewController(_ secondaryViewController: UIViewController, for splitViewController: UISplitViewController) {
        guard let navigationController = viewControllers.first as? UINavigationController else {
            return
        }
        
        navigationController.viewControllers.append(secondaryViewController)
    }
}
