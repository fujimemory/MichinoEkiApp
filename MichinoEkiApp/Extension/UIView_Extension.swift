//
//  UIView_Extension.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import UIKit

//MARK: - anchor
extension UIView {
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil,
        centerX: NSLayoutXAxisAnchor? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        topPadding: CGFloat = 0,
        bottomPadding: CGFloat = 0,
        leftPadding: CGFloat = 0,
        rightPadding: CGFloat = 0){
            
            self.translatesAutoresizingMaskIntoConstraints = false
        
            if let top = top {
                self.topAnchor.constraint(equalTo: top,constant: topPadding).isActive = true
            }
            
            if let bottom = bottom {
                // paddingをマイナスにすることで数値を設定する時に整数をセットするだけでよくなる
                self.bottomAnchor.constraint(equalTo: bottom,constant: -bottomPadding).isActive = true
            }
            
            if let left = left {
                self.leftAnchor.constraint(equalTo: left,constant: leftPadding).isActive = true
            }
            
            if let right = right {
                // paddingをマイナスにすることで数値を設定する時に整数をセットするだけでよくなる
                self.rightAnchor.constraint(equalTo: right,constant: -rightPadding).isActive = true
            }
            
            if let centerY = centerY {
                self.centerYAnchor.constraint(equalTo: centerY).isActive = true
            }
            
            if let centerX = centerX {
                self.centerXAnchor.constraint(equalTo: centerX).isActive = true
            }
            
            if let width = width {
                self.widthAnchor.constraint(equalToConstant: width).isActive = true
            }
            
            if let height = height {
                self.heightAnchor.constraint(equalToConstant: height).isActive = true
            }
        
        
    }
}
