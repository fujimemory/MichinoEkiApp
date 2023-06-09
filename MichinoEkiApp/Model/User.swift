//
//  User.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import Foundation
import Firebase

struct User {
    var uid : String
    var email: String
    var createdAt:Timestamp
    var name: String
    var profileImageURL: String
    var introduction : String
    var stationIDs : [String]
    
    init(dic : [String : Any]){
        self.uid = dic["uid"] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.name = dic["name"] as? String ?? ""
        self.profileImageURL = dic["profileImageURL"] as? String ?? ""
        self.introduction = dic["introduction"] as? String ?? ""
        self.stationIDs = dic["stationIDs"] as? [String] ?? []
    }
}
