//
//  String+Snap.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/18/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//

import UIKit
import Foundation

extension String {
    public func length() -> Int {
        return self.count
    }
    
    var localized: String {
        return self.localized(withComment: "")
    }
    
    func localized(withComment comment: String) -> String {
        return NSLocalizedString(self, bundle: Bundle(for: CrossTargetReference.self), comment: comment)
    }
    
    var isEmptyStr:Bool{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
    
    func isNumber() -> Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

}

class CrossTargetReference {
    
}
