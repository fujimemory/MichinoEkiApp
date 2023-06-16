//
//  ProfileTableViewCell.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/06/02.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ProfileTableViewCell: UITableViewCell {
    //MARK: - Properties
    var viewController : UIViewController?
    
    var user : User?{
        didSet{
            guard let user else{ return }
            userNameLabel.text = user.name
            descriptionLabel.text = user.introduction
            stationCountLabel.text = String(user.stationIDs.count)
            // 取得したurlをプロフィール画像に反映させる
            if let url = URL(string: user.profileImageURL){
                profileImage.sd_setImage(with: url)
            }
        }
    }
    
    //MARK: - UIViews
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var stationCountLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func tappedEdit(_ sender: UIButton) {
        print("編集画面へ")
        let editView = ProfileEditViewController()
        editView.user = self.user
        editView.modalPresentationStyle = .fullScreen
        viewController?.present(editView, animated: true)
    }
    
    
    @IBAction func tappedLogout(_ sender: UIButton) {
        print("ログアウトします")
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
            viewController?.present(nav, animated: true)
        }
    }
    
    func setupCell(){
        self.backgroundColor = .white
        userNameLabel.textColor = .black
        descriptionLabel.textColor = .black
        stationCountLabel.textColor = .black
        userNameLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        profileImage.layer.cornerRadius = 40
       
    }
}
