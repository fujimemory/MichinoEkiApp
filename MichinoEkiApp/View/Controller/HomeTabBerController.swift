//
//  ViewController.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import UIKit
import FirebaseAuth

class HomeTabBerController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moveToLogin()
    }


}

extension HomeTabBerController{
    // レイアウト
    private func setupLayout(){
        let map = MapViewController()
        map.tabBarItem = UITabBarItem(title: "地図",
                                       image: UIImage(systemName: "mappin.and.ellipse"),
                                       tag: 0)
        
        let search = SearchViewController()
        search.tabBarItem = UITabBarItem(title: "検索",
                                       image: UIImage(systemName: "magnifyingglass"),
                                       tag: 1)
       
        let profile = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profile)
        profileNav.tabBarItem = UITabBarItem(title: "プロフィール",
                                       image:  UIImage(systemName: "person"),
                                       tag: 2)
        
        viewControllers = [map,search,profileNav]
        
        tabBar.tintColor = UIColor(named: "main")
        tabBar.backgroundColor = .systemGray6
    }
    // ログイン画面への遷移
    private func moveToLogin() {
        if Auth.auth().currentUser?.uid == nil {
            let login = LoginViewController()
            let nav = UINavigationController(rootViewController: login)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false)
        }
    }
}

