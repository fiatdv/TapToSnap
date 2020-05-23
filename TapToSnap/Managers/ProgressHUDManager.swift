//
//  ProgressHUDManager.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/21/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//

import UIKit
import SwiftMessages
import SVProgressHUD

class ProgressHUDManager: NSObject {
    
    static func config() {
        SVProgressHUD.setFont(UIFont.snapFont2())
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
    }
    
    static func show() {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    static func showWithStatus(_ message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: message)
        }
    }
    
    static func showErrorWithStatus(title: String, message: String) {
        dismiss()
        
        LoggingManager.LogError("Error Message: \(message)")
        UIAccessibility.post(notification: .screenChanged, argument: message);
        SwiftMessages.show {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureContent(title: title, body: message)
            view.button?.isHidden = true
            view.titleLabel?.font = UIFont.snapFont2()
            view.bodyLabel?.font = UIFont.snapFont2()
            return view
        }
    }

    static func showErrorWithStatus(_ message: String, params: [String : String]?) {
        dismiss()
        
        LoggingManager.LogError("Error Message: \(message)")
        UIAccessibility.post(notification: .screenChanged, argument: message);
        SwiftMessages.show {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureContent(title: "Error".localized, body: message)
            view.button?.isHidden = true
            view.titleLabel?.font = UIFont.snapFont2()
            view.bodyLabel?.font = UIFont.snapFont2()
            return view
        }
    }
    
    static func showInfoWithStatus(_ message: String) {
        dismiss()
        UIAccessibility.post(notification: .announcement, argument: message);
        SwiftMessages.show {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.info)
            view.configureContent(title: "Info".localized, body: message)
            view.button?.isHidden = true
            view.titleLabel?.font = UIFont.snapFont2()
            view.bodyLabel?.font = UIFont.snapFont2()
            return view
        }
    }
    
    static func showSuccessWithStatus(_ message: String) {
        dismiss()
        UIAccessibility.post(notification: .announcement, argument: message);
        SwiftMessages.show {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.success)
            view.configureContent(title: "Success".localized, body: message)
            view.button?.isHidden = true
            view.titleLabel?.font = UIFont.snapFont2()
            view.bodyLabel?.font = UIFont.snapFont2()
            return view
        }
    }
}
