//
//  UITextField_Extension.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/12.
//

import UIKit

extension UITextField {
    static func createTextField(_ placeholder: String) -> UITextField {
        let field = UITextField(frame: .zero)
        field.textColor = .darkText
//        field.placeholder = placeholder
        field.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.backgroundColor = .white
        field.layer.cornerRadius = 10
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }
}
