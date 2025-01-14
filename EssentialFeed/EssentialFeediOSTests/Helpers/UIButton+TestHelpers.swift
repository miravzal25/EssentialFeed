//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Miravzal Sultonov on 1/14/25.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
