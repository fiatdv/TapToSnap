//
//  UIView+Snap.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/18/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//

import UIKit

extension UIView {
    
    func add(subviews: [UIView]) {
        for subview in subviews {
            self.addSubview(subview)
        }
    }

}
