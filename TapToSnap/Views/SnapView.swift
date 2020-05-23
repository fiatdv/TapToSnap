//
//  SnapView.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/17/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//

import UIKit
import SnapKit

class SnapView: UIView {

    enum Status {
        case initialized
        case verifying
        case incorrect
        case correct
    }
    
    private var status = Status.initialized
    public var parent: TapToSnapDelegate? = nil
    public var name = ""

    private lazy var snapImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "fgSnap"))
        image.contentMode = .scaleAspectFill
        return image
    }()

    private lazy var overlay: UIView = {
        let image = UIView()
        image.backgroundColor = .snapBGGrayDark
        image.alpha = 0.7
        image.isHidden = true
        return image
    }()

    private lazy var errorText: UILabel = {
        let label = UILabel()
        label.text = "Tap to try again"
        label.font = UIFont.snapFont4()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.isHidden = true
        return label
    }()

    private lazy var text: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.snapFont3()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.snapTileGrayDark
        return label
    }()

    private lazy var loading: LoadingView = {
        let loading = LoadingView()
        loading.isHidden = true
        return loading
    }()

    private lazy var snapButton: GradientBorderButton = {
        let button = GradientBorderButton()
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        return button
    }()

    init() {
        super.init(frame: CGRect())
        self.setupViews()
    }

    init(name: String) {
        super.init(frame: CGRect())
        self.setupViews()
        self.name = name
        text.text = name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        self.backgroundColor =  UIColor.snapTileGray
        self.layer.cornerRadius = 14
        self.clipsToBounds = true

        add(subviews: [snapImage,overlay,errorText,text,loading,snapButton])
        setupLayout()
        setStatus()
    }
    
    private func setupLayout() {
        snapImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(209)
        }
        overlay.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-54)
        }
        errorText.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(-27)
        }
        text.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(54)
            make.bottom.equalToSuperview()
        }
        loading.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        snapButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func setStatus(to: Status = Status.initialized) {
        self.status = to
        switch status {
        case .initialized:
            snapButton.configure(with: GradientButtonOptions(direction: .vertical, borderWidth: 3, colors: [UIColor.snapGradientTop, UIColor.snapGradientBot], cornerRadius: 14))
            overlay.isHidden = true
            errorText.isHidden = true
            loading.hide()
        case .verifying:
            snapButton.configure(with: GradientButtonOptions(direction: .vertical, borderWidth: 3, colors: [UIColor.snapGradientTop, UIColor.snapGradientBot], cornerRadius: 14))
            overlay.isHidden = false
            errorText.isHidden = true
            loading.show()
        case .incorrect:
            snapButton.configure(with: GradientButtonOptions(direction: .vertical, borderWidth: 3, colors: [UIColor.snapRed, UIColor.snapRed], cornerRadius: 14))
            overlay.isHidden = true
            errorText.isHidden = false
            loading.hide()
        case .correct:
            snapButton.configure(with: GradientButtonOptions(direction: .vertical, borderWidth: 3, colors: [UIColor.snapGreen, UIColor.snapGreen], cornerRadius: 14))
            overlay.isHidden = true
            errorText.isHidden = true
            loading.hide()
            parent?.checkSuccess()
        }
    }
    
    @objc func buttonPressed(sender: UIButton) {
        if UtilityManager.shared.isSimulator() {
            switch status {
            case .initialized:
                status = .verifying
            case .verifying:
                status = .incorrect
            case .incorrect:
                status = .correct
            case .correct:
                status = .initialized
            }
            setStatus(to: status)
        } else {
            parent?.takeSnap(view: self)
        }
    }
    
    func setImage(image: UIImage) {
        snapImage.image = image
    }

    func setText(to: String) {
        text.text = to
    }
    
    func isSuccess() -> Bool {
        return status == .correct
    }
}
