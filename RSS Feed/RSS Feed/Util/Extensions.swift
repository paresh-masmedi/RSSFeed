//
//  Extensions.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 01/12/23.
//

import UIKit
import SwiftUI

extension UIColor {
    //UIColor to hex value
    var hex: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return String(
            format: "#%02lX%02lX%02lX%02lX",
            lroundf(Float(red * 255)),
            lroundf(Float(green * 255)),
            lroundf(Float(blue * 255)),
            lroundf(Float(alpha * 255))
        )
    }
}

extension Theme {
    //Based on default theme its colors
    static let `default` = Theme(
        textPrimary: .label,
        textSecondary: .secondaryLabel,
        textInteractive: .systemBlue
    )
}

extension URL {
    //Know URL is directory or not
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}

