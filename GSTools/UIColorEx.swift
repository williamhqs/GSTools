//
//  UIColorEx.swift
//  GSTools
//
//  Created by 胡秋实 on 3/11/2015.
//  Copyright © 2015 William Hu. All rights reserved.
//

import UIKit

extension UIColor {
    class func RGB(red: CGFloat, _ green:CGFloat, _ blue:CGFloat, alpha: CGFloat = 1.0) -> UIColor{
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}