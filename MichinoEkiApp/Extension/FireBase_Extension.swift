//
//  FireBase_Extension.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/14.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

extension Auth {
    static func addUser(email:String,pass:String,completion:@escaping (Bool) -> Void){
        auth().createUser(withEmail: email, password: pass) { auth, err in
            if let err {
                // TODO: エラーハンドリングを行う
                print("ユーザ登録に失敗しました",err)
                
            }
            // ユーザ登録に成功した時の処理
            guard let uid = auth?.user.uid else { return }
            Firestore.addUserInfoToFirestore(uid: uid, email: email) { result in
                completion(result)
            }
            
        }
    }
}

extension Firestore {
    static func addUserInfoToFirestore(uid: String,email: String,completion : @escaping (Bool)-> Void){
        // 半角英数字からランダムな文字列を作る
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let name = String((0..<8).map{ _ in letters.randomElement()! })
        
        let doc = [
            "uid" : uid,
            "createdAt" : Timestamp(),
            "email" : email,
            "name" : name
        ] as [String:Any]
        
        firestore().collection("users").document(uid).setData(doc) { err in
            if let err {
                print("ユーザ情報の追加に失敗しました",err)
                completion(false)
            }
            print("ユーザ情報の追加に成功")
            completion(true)
        }
    }
}
