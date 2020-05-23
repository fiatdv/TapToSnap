//
//  UtilityManager.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/18/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//

import UIKit
import SwiftMessages
import DeviceKit

class UtilityManager: NSObject {
    
    static var shared = UtilityManager()
    var nextErrorMessage = ""
    
    override init() {
    }

    func isSimulator() -> Bool {
        let device = Device.current
        return device.isSimulator
    }

    func showError() {
        showError(title: "Game Over".localized, body: "Better luck next time!".localized)
    }

    func showError(title: String, body: String) {
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.error)
        error.configureContent(title: title, body: body)
        error.button?.isHidden = true
        error.backgroundView.backgroundColor = UIColor.snapRed
        SwiftMessages.show(view: error)
    }
}

public enum SnapError: Error {
    case custom
}

extension SnapError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .custom:
            return NSLocalizedString(UtilityManager.shared.nextErrorMessage, comment: "")
        }
    }
}

