//
//  UIColor.swift
//  HeadlineNews
//
//  Created by 김지훈 on 10/8/24.
//

import UIKit

extension UIColor {
    static let main = MainColor()
    static let text = TextColor()
    static let button = ButtonColor()
    static let border = BorderColor()
    static let background = BackGroundColor()
    static let cell = CellColor()
    
    struct MainColor {
        //
    }

    struct TextColor {
        var black = UIColor.black
        var red = UIColor.red
        var darkGray = UIColor.darkGray
    }
    
    struct ButtonColor {
        //
    }
    
    struct BorderColor {
        //
    }
    
    struct BackGroundColor {
        var white = UIColor.white
    }
    
    struct CellColor {
        var lightGray = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
    }
}
