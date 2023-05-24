//
//  Memory.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import Foundation
import Firebase

struct Memory{
    var id : String
    var createdAt : Timestamp
    var text : String
    var imageURL : String
    var userID : String
    var stationID : String
    
    init(dic : [String : Any]){
        self.id = dic["id"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.text = dic["text"] as? String ?? ""
        self.imageURL = dic["imageURL"] as? String ?? ""
        self.userID = dic["userID"] as? String ?? ""
        self.stationID = dic["stationID"] as? String ?? ""
    }
}
