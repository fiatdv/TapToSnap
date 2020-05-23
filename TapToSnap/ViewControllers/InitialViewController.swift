//
//  InitialViewController.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/20/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//

import UIKit
import DSFloatingButton

class InitialViewController: UIViewController {

    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "bg"))
        image.contentMode = .scaleToFill
        return image
    }()

    private lazy var welcomeImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "logo"))
        image.contentMode = .scaleAspectFit
        return image
    }()

    private lazy var goButton: DSFloatingButton = {
        let go = DSFloatingButton(type: .custom)
        go.setTitle("LET'S GO!", for: .normal)
        go.backgroundColor = UIColor.snapPink
        go.shadowColor = .black
        go.useCornerRadius = true
        go.cornerRadius = 10.0
        go.titleLabel?.font = UIFont.snapFont2();
        go.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        return go
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, error in
        })
    }

    private func setupViews() {
        view.add(subviews: [backgroundImage,welcomeImage,goButton])
        setupLayout()
    }

    private func setupLayout() {
        backgroundImage.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        welcomeImage.snp.makeConstraints { (make) in
            make.top.equalTo(175)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(326)
        }
        goButton.snp.makeConstraints { (make) in
            let ht = 60
            make.bottom.equalTo(-83)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(ht)
        }
    }

    @objc func buttonPressed(sender: UIButton) {
        
        ProgressHUDManager.show()

        RequestManager.shared.getItems(responseClosure: { (items) in

            ProgressHUDManager.dismiss()
            
            if items.count != 4 {
                UtilityManager.shared.showError(title: "Server Error", body: "Missing Items")
                return
            }

            let vc = SnapViewController()
            vc.setItems(items: items)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)

        }) { (error) in
            LoggingManager.LogError(error.localizedDescription)
            ProgressHUDManager.dismiss()
        }
    }
}
