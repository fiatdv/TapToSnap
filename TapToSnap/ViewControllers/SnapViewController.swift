//
//  SnapViewController.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/17/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//

import UIKit
import SwiftMessages

protocol TapToSnapDelegate {
    func takeSnap(view: SnapView)
    func checkSuccess()
}

struct Item: Decodable {
    let id: Int
    let name: String
}

class SnapViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TapToSnapDelegate {
    
    private var snapTitle = UILabel()
    private var snapTL = SnapView()
    private var snapTR = SnapView()
    private var snapBL = SnapView()
    private var snapBR = SnapView()
    private var snapViews: [String:SnapView] = [:]
    private var snapController = UIImagePickerController()
    
    private lazy var timerLabel: UITextField = {
        let label = UITextField()
        label.text = ""
        label.font = UIFont.snapFont1()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.snapBGGrayDark
        label.contentVerticalAlignment = .top
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private var timer = Timer()
    private var countDownSecs = ConstantsManager.game.countDownTimerInSecs
    private var timerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        snapTL.parent = self
        snapTR.parent = self
        snapBL.parent = self
        snapBR.parent = self

        countDownSecs = ConstantsManager.game.countDownTimerInSecs
        startTimer()
        registerLocalNotification()

        UserDefaults.standard.removeObject(forKey: ConstantsManager.notifications.timeEnteredBackground)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredBackground), name: NSNotification.Name(rawValue: ConstantsManager.notifications.appEnteredBackground), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredForeground), name: NSNotification.Name(rawValue: ConstantsManager.notifications.appEnteredForeground), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupViews() {
        snapTitle.text = "Tap to snap".localized
        snapTitle.textAlignment = .center
        snapTitle.font = UIFont.snapFont2()
        snapTitle.textColor = UIColor.white
        
        view.add(subviews: [snapTitle, snapTL,snapTR,snapBL,snapBR, timerLabel])
        view.backgroundColor = UIColor.snapBgGray

        setupLayout()
    }
    
    private func setupLayout() {
        let center = (UIScreen.main.bounds.width - 40)/2
        snapTitle.snp.makeConstraints { (make) in
            make.top.equalTo(76)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        snapTL.snp.makeConstraints { (make) in
            make.top.equalTo(138)
            make.left.equalTo(20)
            make.height.equalTo(263)
            make.width.equalTo(center-7.5)
        }
        snapTR.snp.makeConstraints { (make) in
            make.top.equalTo(138)
            make.right.equalTo(-20)
            make.height.equalTo(263)
            make.width.equalTo(center-7.5)
        }
        snapBL.snp.makeConstraints { (make) in
            make.top.equalTo(snapTL.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.height.equalTo(263)
            make.width.equalTo(center-7.5)
        }
        snapBR.snp.makeConstraints { (make) in
            make.top.equalTo(snapBL.snp.top)
            make.right.equalTo(-20)
            make.height.equalTo(263)
            make.width.equalTo(center-7.5)
        }
        timerLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(83)
            make.bottom.equalToSuperview()
        }
    }
    
    func takeSnap(view: SnapView) {
        snapController.sourceType = .camera
        snapController.allowsEditing = true
        snapController.delegate = self
        snapController.title = view.name
        //camController.cameraOverlayView = todo for v2: tictactoeview
        self.present(snapController, animated: true) {
            view.setStatus(to: .initialized)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        snapController = UIImagePickerController()
        guard let image = info[.editedImage] as? UIImage else {
            LoggingManager.LogError("No image found")
            return
        }
        
        let name = picker.title ?? ""
        if let view = snapViews[name] {
            view.setImage(image: image)
        }
        
        let data = image.jpegData(compressionQuality: 0.8)
        let imageStr = data?.base64EncodedString() ?? ""
        
        verifySnap(name: name, image: imageStr)
    }
    
    func verifySnap(name: String, image: String) {
        
        guard let view = snapViews[name] else {
            LoggingManager.LogError("Missing Snap View?")
            return
        }
        view.setStatus(to: .verifying)

        RequestManager.shared.verifyItem(label: name, image: image, responseClosure: { (response) in
            view.setStatus(to: (response["matched"] ?? false) ? .correct : .incorrect)
        }) { (error) in
            view.setStatus(to: .incorrect)
            LoggingManager.LogError(error.localizedDescription)
        }
    }

    @objc func updateTime() {
        countDownSecs -= 1

        let seconds = countDownSecs % 60
        let minutes = (countDownSecs / 60) % 60
        let hours = countDownSecs / 3600
        let strHours = hours > 9 ? String(hours) : "0" + String(hours)
        let strMinutes = minutes > 9 ? String(minutes) : "0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds) : "0" + String(seconds)
        if hours > 0 {
            timerLabel.text = "\(strHours):\(strMinutes):\(strSeconds)"
        }
        else {
            timerLabel.text = "\(strMinutes):\(strSeconds)"
        }
        if countDownSecs < 1 {
            stopTimer()
            showError()
        }
    }

    func startTimer() {
        timerRunning = true
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        LoggingManager.LogWarning("start timer")
    }
    
    func registerLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Game Over!".localized
        content.body = "Better luck next time!".localized
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "Game-Over"

        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(ConstantsManager.game.countDownTimerInSecs), repeats: false)
        let request = UNNotificationRequest.init(identifier: "Game-Over", content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.add(request)
        
    }

    func stopTimer() {
        timer.invalidate()
        timerRunning = false
        countDownSecs = 0
        LoggingManager.LogWarning("stop timer")
    }
    
    @objc func appEnteredBackground() {
        if timerRunning {
            LoggingManager.LogWarning("Back: timer \(timerRunning), count: \(countDownSecs)")
            timer.invalidate()
            timerLabel.text = ""
            UserDefaults.standard.set(Date(), forKey: ConstantsManager.notifications.timeEnteredBackground)
        }
    }
    
    @objc func appEnteredForeground() {
        if timerRunning {
            LoggingManager.LogWarning("Fore: timer \(timerRunning), count: \(countDownSecs)")
            if let savedDate = UserDefaults.standard.object(forKey: ConstantsManager.notifications.timeEnteredBackground) as? Date {
                UserDefaults.standard.removeObject(forKey: ConstantsManager.notifications.timeEnteredBackground)
                if countDownSecs > 0 {
                    let components = Calendar.current.dateComponents([.hour, .minute, .second], from: savedDate, to: Date())
                    countDownSecs -= components.second ?? 0
                    countDownSecs -= (components.minute ?? 0) * 60
                    countDownSecs -= (components.hour ?? 0) * 3600
                    if countDownSecs > 1 {
                        startTimer()
                        return
                    }
                }
                stopTimer()
                showError()
            }
        }
    }
    
    func showError() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UtilityManager.shared.showError()
        snapController.dismiss(animated: false, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func showSuccess() {
        stopTimer()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 250)
        messageView.configureContent(title: "🏆 WINNER 🏆".localized, body: "Good Job!".localized, iconImage: nil, iconText: "👏👏👏👏", buttonImage: nil, buttonTitle: "Continue".localized) { _ in
            SwiftMessages.hide()
            self.dismiss(animated: true, completion: nil)
            
            
        }
        messageView.backgroundView.backgroundColor = UIColor.white
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: messageView)
    }

    func checkSuccess() {
        if snapTL.isSuccess() && snapTR.isSuccess() && snapBL.isSuccess() && snapBR.isSuccess() {
            showSuccess()
        }
    }

    func setItems(items: [Item]) {
        
        if items.count != 4 {
            return
        }
        
        snapTL = SnapView(name: items[0].name)
        snapTL.parent = self
        snapViews[items[0].name] = snapTL

        snapTR = SnapView(name: items[1].name)
        snapTR.parent = self
        snapViews[items[1].name] = snapTR

        snapBL = SnapView(name: items[2].name)
        snapBL.parent = self
        snapViews[items[2].name] = snapBL

        snapBR = SnapView(name: items[3].name)
        snapBR.parent = self
        snapViews[items[3].name] = snapBR
    }
}

