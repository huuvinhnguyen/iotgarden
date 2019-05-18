//
//  UIFont+Extension.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 5/13/19.
//

import UIKit

extension UIFont {
    
    class var typo22W6WhiteLeftStyle: UIFont {
        return UIFont(name: "HiraginoSans-W6", size: 22.0)!
    }
}

extension UIFont {
    enum HiraginoSansStyle {
        case w3
        case w6
        var name: String {
            switch self {
            case .w3:
                return "HiraginoSans-W3"
            case .w6:
                return "HiraginoSans-W6"
            }
        }
        
        var systemFontWeight: UIFont.Weight {
            switch self {
            case .w3: return .regular
            case .w6: return .bold
            }
        }
    }
    
    static func hiraginoSans(style: HiraginoSansStyle = .w3, size: CGFloat) -> UIFont {
        guard
            let font = UIFont(name: style.name, size: size),
            Int.bitWidth != 32 else {
                return UIFont.systemFont(ofSize: size, weight: style.systemFontWeight)
        }
        return font
        //        return font.then {
        //            $0.ensureCorrectAlignment()
        //        }
    }
}
