//
//  ConstantsManager.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/18/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//

import UIKit

struct ConstantsManager {
    struct userDefault {
        static let allowCameraAccess = "kALSAllowCameraAccess"
    }
    struct notifications {
        static let appEnteredBackground = "kAppEnteredBackground"
        static let appEnteredForeground = "kappEnteredForeground"
        static let timeEnteredBackground = "ktimeEnteredBackground"
    }
    struct game {
        static let countDownTimerInSecs = 45 // LENGTH OF GAME IN SECS
    }
}
