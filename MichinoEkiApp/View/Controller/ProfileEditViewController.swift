//
//  ProfileEditViewController.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage
import RxSwift
import RxCocoa
import FirebaseStorage

class ProfileEditViewController: UIViewController {
    var disposeBag = DisposeBag()
    var viewModel = ProfileEditViewModel()
    var imageIsChanged  = false
    var name = ""
    var introduction = ""
    var user : User? {
        didSet{
            if let user = user {
                nameTextfield.text = user.name
                name = user.name // 変数に格納
                introductionTextView.text = user.introduction
                introduction = user.introduction // 変数に格納
                // プロフィールの画像をセット
                if let url = URL(string: user.profileImageURL){
                    profileImage.sd_setImage(with: url)
                }
            }
        }
    }
    
    //MARK: - UIViews
    let dismissButton : UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitle("キャンセル", for: .normal)
        button.tintColor = UIColor(named: "main")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.setTitle("保存", for: .normal)
        button.tintColor = UIColor(named: "main")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        // このViewにaddSubViewするボタンを押せるようにするために必要
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let changeImageButton : UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .thin)
        button.setImage(UIImage(systemName: "photo",withConfiguration: imageConfig), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black.withAlphaComponent(0.2)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "名前"
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let introductionLabel : UILabel = {
        let label = UILabel()
        label.text = "自己紹介"
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextfield : UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        // textField内部にスペースを設ける
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 36))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 36))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let introductionTextView : UITextView = {
        let textView = UITextView(frame: .zero)
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 10
        textView.font = .systemFont(ofSize: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
        dismissButton.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
        changeImageButton.addTarget(self, action: #selector(tappedChangeImageButton), for: .touchUpInside)
    }
}

extension ProfileEditViewController {
    private func setupLayout(){
        view.backgroundColor = .white
        
        let topStackView = UIStackView(arrangedSubviews: [dismissButton,saveButton])
        topStackView.axis = .horizontal
        topStackView.distribution = .equalCentering
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViews = [[nameLabel,nameTextfield],[introductionLabel,introductionTextView]].map { views in
            let stackView = UIStackView(arrangedSubviews: views)
            stackView.axis = .vertical
            stackView.spacing = 5
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }
        
        let infomationStackView = UIStackView(arrangedSubviews: stackViews)
        infomationStackView.axis = .vertical
        infomationStackView.spacing = 20
        infomationStackView.translatesAutoresizingMaskIntoConstraints = false
      
        view.addSubview(topStackView)
        view.addSubview(profileImage)
        profileImage.addSubview(changeImageButton)
        view.addSubview(infomationStackView)
        
        topStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor ,
                            centerX: view.centerXAnchor,
                            width: view.bounds.width - 20,
                            height: 50)
        
        nameTextfield.anchor(height: 36)
        
        profileImage.anchor(top: topStackView.bottomAnchor ,
                            centerX: view.centerXAnchor,
                            width: view.bounds.width / 2.5,
                            height: view.bounds.width / 2.5,
                            topPadding: 30)
        
        profileImage.layer.cornerRadius = (view.bounds.width / 2.5) / 2
        
        changeImageButton.anchor(top: profileImage.topAnchor,
                             bottom: profileImage.bottomAnchor,
                             left: profileImage.leftAnchor,
                             right: profileImage.rightAnchor,
                             centerY: profileImage.centerYAnchor,
                             centerX: profileImage.centerXAnchor)
        
        changeImageButton.layer.cornerRadius = (view.bounds.width / 2.5) / 2
        
        infomationStackView.anchor(top: profileImage.bottomAnchor,
                                   centerX: view.centerXAnchor,
                                   width: view.bounds.width - 60,
                                   height: view.bounds.height * 0.35,
                                   topPadding: 40)
    }
    
    private func setupBindings(){
        
        nameTextfield.rx.text
            .asDriver()
            .drive { text in
                let text = text ?? ""
                self.viewModel.nameInput.onNext(text)
                self.name = text
                
            }
            .disposed(by: disposeBag)
        
        introductionTextView.rx.text
            .asDriver()
            .drive { text in
                let text = text ?? ""
                self.viewModel.introductionInput.onNext(text)
                self.introduction = text
            }
            .disposed(by: disposeBag)
        
        viewModel.validSaveDriver
            .drive { validAll in
                print("validAll",validAll)
                self.saveButton.isEnabled  = validAll
            }
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                let dic = [
                    "name" : self.name,
                    "introduction" : introduction
                ] as [String : Any]
                if imageIsChanged {
                    Storage.updateUserImageToStorage(image: profileImage.image, dic: dic) { result in
                        if result{
                            self.dismiss(animated: true)
                        }
                    }
                }else{
                    Firestore.updateUserInfoToFirestore(dic: dic){ result in
                        if result{
                            self.dismiss(animated: true)
                        }
                    }
                }
                
               // TODO: 画像が変更された時の処理を追加する
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func dismissScreen(){
        self.dismiss(animated: true)
    }
    
    @objc private func tappedChangeImageButton(){
        print("押されました")
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }
    
}

extension ProfileEditViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        self.profileImage.image = image
        self.dismiss(animated: true)
        self.imageIsChanged = true
    }
}
