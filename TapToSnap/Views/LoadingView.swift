//
//  LoadingView.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/18/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//

import UIKit

final class LoadingView: UIView {
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .clear
        activityIndicatorView.color = .white

        if activityIndicatorView.superview == nil {
            addSubview(activityIndicatorView)
            
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
    
    public func show() {
        isHidden = false
        animate()
    }
    
    public func hide() {
        isHidden = true
        stopAnimating()
    }

    public func animate() {
        activityIndicatorView.startAnimating()
    }

    public func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
}
