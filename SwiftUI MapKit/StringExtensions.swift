//
//  StringExtensions.swift
//  SwiftUI MapKit
//
//  Created by Alexander Katzfey on 5/18/22.
//

import SwiftUI

extension String {
    func image(fontSize: Int = 40, padding: Int = 5) -> UIImage? {
        let size = CGSize(width: fontSize + padding, height: fontSize + padding)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: CGFloat(fontSize))])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
