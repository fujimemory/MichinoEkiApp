//
//  ProfileEditViewController.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import UIKit
import FirebaseAuth

class ProfileEditViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        let label = UILabel()
        label.text = "プロフィール編集画面"
        
        view.addSubview(label)
        label.anchor(centerY: view.centerYAnchor, centerX: view.centerXAnchor)
       
    }
    
    
    

}
