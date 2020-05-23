//
//  DSFloatingButton+.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/20/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//

import DSFloatingButton

extension DSFloatingButton {

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = .snapPinkDark
        super.touchesBegan(touches, with: event)
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = .snapPink
        super.touchesEnded(touches, with: event)
    }
}
