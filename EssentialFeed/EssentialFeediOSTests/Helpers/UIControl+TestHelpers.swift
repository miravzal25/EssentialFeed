//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Miravzal Sultonov on 1/14/25.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
