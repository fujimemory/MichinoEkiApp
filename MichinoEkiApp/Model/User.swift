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
    var profileImage: String
    var stations : [String]// 道の駅のIDを格納する
}
