//
//  ProfileViewController.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    let logoutButton = UIButton.createSubButton("ログアウト")


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        view.addSubview(logoutButton)
        logoutButton.anchor(centerY: view.centerYAnchor, centerX: view.centerXAnchor)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
    }
    
    @objc private func logout() {
        do {
           try Auth.auth().signOut()
            moveToLogin()
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    private func moveToLogin() {
        if Auth.auth().currentUser?.uid == nil {
            let login = LoginViewController()
            let nav = UINavigationController(rootViewController: login)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
}
