//
//  EnvironmentManager.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/18/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//
import UIKit

class EnvironmentManager: NSObject {
    
    static var shared = EnvironmentManager()
    private(set) var currentEnvironment: Environment
    static let devEnvironment = Dev()
    
    static var appHeader: String {
        get {
            return Bundle.main.object(forInfoDictionaryKey: "appHeader") as! String
        }
    }

    override init() {
        currentEnvironment = EnvironmentManager.devEnvironment // default to dev
        super.init()
    }
    
    private func setEnvironment(to name: String) {
        let env = name.lowercased()
        if (env == "dev") {
            currentEnvironment = EnvironmentManager.devEnvironment
        }
        LoggingManager.Log("Environment is now: \(currentEnvironment.Name)")
    }
}

protocol Environment {
    var Name: String { get }
    var NameFull: String { get }
    var APIBaseUrl: String { get }
    var AppVersionSuffix: String { get }
}

class Dev: Environment {
    let Name = "Dev"
    let NameFull = "Development"
    let APIBaseUrl = "https://hoi4nusv56.execute-api.us-east-1.amazonaws.com"
    let AppVersionSuffix = " Dev"
}
