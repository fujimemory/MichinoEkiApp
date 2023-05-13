//
//  String_Extension.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/13.
//

import Foundation

extension String {
//    // 文字列から空白を除いたものを渡す
//    var deleteWhiteSpace : String {
//        let withoutSpaces = String(self.filter { !$0.isWhitespace })
//        return withoutSpaces
//    }
    
    // 文字列に空白が含まれているか確認する
    var checkWhiteSpace : Bool {//有：true, 無：false
        let whitespaceSet = CharacterSet.whitespaces
        let range = self.rangeOfCharacter(from: whitespaceSet)
        let containsWhitespace = range != nil
        return containsWhitespace
    }
    
    // メールアドレス制約
    var validEmail : Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailPredicate.evaluate(with: self)
    }
    // パスワード制約
    var validPassword : Bool {
        let characterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")
        let invertedSet = characterSet.inverted
        let range = self.rangeOfCharacter(from: invertedSet)
        
        return range == nil && self.count >= 8
    }
    
}
