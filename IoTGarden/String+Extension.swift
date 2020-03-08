//
//  String+Extension.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 3/8/20.
//

import Foundation

extension String  {
    var isNumber: Bool { return Int(self) != nil || Double(self) != nil }
}

extension String
{
    func containsNumbers() -> Bool
    {
        let numberRegEx  = ".*[0-9]+.*"
        let testCase     = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return testCase.evaluate(with: self)
    }
}
