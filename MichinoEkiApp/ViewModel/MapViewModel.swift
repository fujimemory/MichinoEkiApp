//
//  MapViewModel.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/24.
//

import Foundation
import FirebaseFirestore

class MapViewModel {
    func fetchStations(completion: @escaping (Station?) -> Void){
        Firestore.fetchStationFromFirestore { result in
            switch result {
            case .success(let station):
                print(station)
                completion(station)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
