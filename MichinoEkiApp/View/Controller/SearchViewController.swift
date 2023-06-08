//
//  SearchViewController.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import UIKit
import FirebaseFirestore

class SearchViewController: UIViewController {
    
    var stations  = [Station]()
    
    var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "駅名を検索しよう"
        sb.showsCancelButton = true
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    var tableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         height: 60,
                         leftPadding: 10,
                         rightPadding: 10)
        tableView.anchor(top: searchBar.bottomAnchor ,
                         bottom: view.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
    }
       
}

extension SearchViewController : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // キーボードしまう
        searchBar.endEditing(true)
        stations.removeAll()// 配列をクリア
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        stations.removeAll()// 配列をクリア
        guard let keyword = searchBar.text else { return }
//        print(keyword)
        Firestore.firestore().collection("stations").order(by: "name").start(at: [keyword]).end(at: [keyword + "\u{f8ff}"])
            .getDocuments { snapshot, error in
                if let error = error {
                    print("取得失敗")
                }
                guard let snapshot = snapshot else { return }
                let documents = snapshot.documents
                for docuent in documents {
                    let data = docuent.data()
                    let station = Station(dic: data)
                    self.stations.append(station)
                }
                self.tableView.reloadData()
            }
    }
}

extension SearchViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = stations[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = StationDetailViewController()
        detailVC.station = self.stations[indexPath.row]
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true)
    }
}
