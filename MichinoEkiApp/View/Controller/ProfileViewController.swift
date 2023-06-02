//
//  ProfileViewController.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    //MARK: - Properties
    let profileCellID = "profileID"
    let memoryCellID = "MemoryID"
    
    //MARK: - UIViews
    let tableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    


    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configulation()
        
    }
}

extension ProfileViewController{
    func configulation(){
        setupLayout()
        setupTableView()
    }
    
    func setupLayout(){
        title = "ユーザ名"
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor ,
                         bottom: view.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor)
    }
    
    func setupTableView(){
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil),
                                forCellReuseIdentifier: profileCellID)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: memoryCellID)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY > 40 {
            print("スクロールした")
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            print("戻った")
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}

//MARK: - DelegateMethods
extension ProfileViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: profileCellID, for: indexPath) as! ProfileTableViewCell
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: memoryCellID, for: indexPath)
            cell.textLabel?.text = "こんにちは"
            return cell
        }
    }
    
     
    
    
}
