//
//  UILabel_Extension.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/12.
//

import UIKit

extension UILabel {
    //MARK: - ログイン・登録画面で併用
    //  タイトルラベル
    static func createTitleLabel(_ title : String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // サブタイトルラベル
    static func createSubTitleLabel(_ title : String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
