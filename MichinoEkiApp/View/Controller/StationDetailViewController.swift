//
//  StationDetailViewController.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import UIKit

class StationDetailViewController: UIViewController {
    
    //MARK: - Properties
    // 道の駅情報格納
    var station : Station? {
        didSet{
            // 各UIViewに反映させる
            titleLabel.text = station?.name
        }
    }
    
    //ユーザ情報の格納
    private var user : User?
    
    private let cellID = "cellID"
    
    //MARK: - UIViews
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "なんとかかんとかの里"// 仮
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var dismissButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = UIColor(named: "main")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var networkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "globe"), for: .normal)
        button.tintColor = UIColor(named: "main")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var checkInButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check In", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "main")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        dismissButton.addTarget(self, action: #selector(back), for: .touchUpInside)

    }
    
}

//MARK: - Extensions
extension StationDetailViewController{
    private func setupLayout() {
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews:[dismissButton,networkButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        tableView.addSubview(checkInButton)

        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor ,
                         centerX: view.centerXAnchor,
                         width: view.bounds.width - 20,
                         height: 50)
        
        titleLabel.anchor(top: stackView.bottomAnchor,
                          centerX: view.centerXAnchor,
                          width: view.bounds.width - 20,
                          topPadding: 10)
        
        tableView.anchor(top: titleLabel.bottomAnchor ,
                         bottom: view.bottomAnchor,
                         centerX: view.centerXAnchor,
                         width: view.bounds.width - 20,
                         topPadding: 10)
        
        checkInButton.anchor(bottom: view.bottomAnchor,
                             right: view.rightAnchor,
                             width: 80,
                             height: 40,
                             bottomPadding: view.bounds.height / 3,
                             rightPadding: 10)
        
        
    }
    @objc private func back(){
        self.dismiss(animated: true)
    }
   
}

extension StationDetailViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = station?.name
        cell.backgroundColor = .cyan
        return cell
    }
    
    
}
