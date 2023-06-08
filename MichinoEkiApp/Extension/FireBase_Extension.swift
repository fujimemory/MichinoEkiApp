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
    // ユーザ情報の保存
    static func addUserInfoToFirestore(uid: String,email: String,completion : @escaping (Bool)-> Void){
        // 半角英数字からランダムな文字列を作る
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let name = String((0..<8).map{ _ in letters.randomElement()! })
        
        let doc = [
            "uid" : uid,
            "createdAt" : Timestamp(),
            "email" : email,
            "name" : name,
            "profileImageURL" : "https://firebasestorage.googleapis.com/v0/b/michinoekiapp-a5e41.appspot.com/o/defaultUserImage.png?alt=media&token=cb1ca16c-cf60-4521-a5ae-e53af5c7f339",
            "introduction" : ""
            
        ] as [String:Any]
        
        /*
         struct User {
             var uid : String
             var email: String
             var createdAt:Timestamp
             var name: String
             var profileImageURL: String
             var introduction : String
         }
         */
        
        firestore().collection("users").document(uid).setData(doc) { err in
            if let err {
                print("ユーザ情報の追加に失敗しました",err)
                completion(false)
            }
            print("ユーザ情報の追加に成功")
            completion(true)
        }
    }
    
    // 道の駅情報の取得
    static func fetchStationFromFirestore(completion: @escaping (Result<Station,Error>) -> Void){
        let ref = Firestore.firestore()
        ref.collection("stations").getDocuments { snapshots, err in
            if let err {
                print("ユーザ情報の取得に失敗しました。",err)
                completion(.failure(err))
            }
            snapshots?.documents.forEach({ snapshot in
                let dic = snapshot.data()
                let station = Station(dic: dic)
                completion(.success(station))
            })
        }
    }
    
    // ユーザ情報の取得
    static func fetchUserFromFirestore(uid : String,completion: @escaping (User) -> Void){
        let ref = Firestore.firestore().collection("users").document(uid)
//        ref.getDocument { snapshot, error in
//            if let document = snapshot,document.exists{
////                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
////                print("Document data: \(dataDescription)")
//                guard let data = document.data() else { return }
//                let user = User(dic: data)
//                completion(user)
////                print(user)
//            } else {
//                print("Document does not exist")
//            }
//        }
        
        ref.addSnapshotListener { snapshot, error in
            if let document = snapshot,document.exists{
                guard let data = document.data() else { return }
                let user = User(dic: data)
                print(user)
                completion(user)
            }else {
                print("ドキュメントが存在しません")
            }
        }
        
        
    }
}
