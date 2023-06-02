//
//  ProfileTableViewCell.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/06/02.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var stationCountLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tappedEdit(_ sender: UIButton) {
        print("編集画面へ")
    }
}
