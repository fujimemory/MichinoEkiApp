//
//  Station.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import Foundation

struct Station {
    let id : String
    let name : String
    let latitude : Double
    let longitude : Double
    let url : String
    
    init(dic : [String : Any]){
        self.id = dic["id"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.latitude = dic["latitude"] as? Double ?? 0
        self.longitude = dic["longitude"] as? Double ?? 0
        self.url = dic["url"] as? String ?? ""
    }
    
    
//    static func latitudeCaliculate(degrees:Double,minutes:Double,seconds: Double) -> Double{
//        let hoge = seconds / 60 + minutes
//        return hoge / 60 + degrees
//    }
//
//    static func longitudeCaliculate(degrees:Double,minutes:Double,seconds: Double) -> Double {
//        let hoge = seconds / 60 + minutes
//        return hoge / 60 + degrees
//    }
}
