//
//  GradientBorderButton.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/18/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//

import UIKit

enum GradientButtonState {
    case none, border, fill
    
    var title: String {
        switch self {
        case .none:             return "None"
        case .border:           return "Border"
        case .fill:             return "Fill"
        }
    }
}

struct GradientButtonOptions {
    let borderWidth: CGFloat?
    let colors: [UIColor]
    let cornerRadius: CGFloat?
    let direction: CALayer.GradientDirection?
    
    init(direction: CALayer.GradientDirection? = nil, borderWidth: CGFloat? = nil, colors: [UIColor] = [], cornerRadius: CGFloat? = nil) {
        self.direction = direction
        self.borderWidth = borderWidth
        self.colors = colors
        self.cornerRadius = cornerRadius
    }
}

class GradientBorderButton: UIButton {
    
    //MARK: - UI Properties
    private var gradientBorderWidth: CGFloat = 1
    private var colors: [UIColor] = [.green, .yellow]
    private var cornerRadius: CGFloat = 0
    private var gradientDirection: CALayer.GradientDirection = .horizontal
    
    //MARK: - Layers
    private var gradientBorderLayer: CAGradientLayer?
    private var gradientLayer: CAGradientLayer?
    
    //MARK: - Button State
    fileprivate var gradientState: GradientButtonState = .border {
        didSet {
            updateStateVisually()
        }
    }
    
    //MARK: - Open State changer
    func update(state: GradientButtonState) {
        gradientState = state
    }
    
    func configure(with options: GradientButtonOptions) {
        gradientBorderWidth = options.borderWidth ?? gradientBorderWidth
        colors = options.colors.isEmpty ? colors : options.colors
        cornerRadius = options.cornerRadius ?? cornerRadius
        gradientDirection = options.direction ?? gradientDirection
        updateStateVisually()
    }
    
    //MARK: - View cycles
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStateVisually()
    }
    
    //MARK: - redraw according state
    private func updateStateVisually() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = !(cornerRadius == 0)
        removeAllGradientLayers()
        switch gradientState {
        case .border:
            gradientBorderLayer = layer.addGradientBorder(direction: gradientDirection, lineWidth: gradientBorderWidth, colors: colors)
        case .fill:
            gradientLayer = layer.addFillGradient(direction: gradientDirection, colors: colors)
        case .none:
            removeAllGradientLayers()
        }
    }
    
    private func removeAllGradientLayers() {
        gradientBorderLayer?.removeFromSuperlayer()
        gradientBorderLayer = nil
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
    }
    
}
