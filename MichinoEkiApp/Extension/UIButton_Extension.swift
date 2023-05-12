//
//  UIButton_Extension.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/12.
//

import UIKit

extension UIButton {
    static func createButton(_ placeholder : String) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(named: "sub")
        button.setTitle(placeholder, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func createSubButton(_ text : String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleLabel?.textColor = UIColor(named: "sub")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
