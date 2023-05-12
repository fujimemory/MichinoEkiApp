//
//  RegisterViewController.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import UIKit

class RegisterViewController: UIViewController {
    //MARK: - UIView
    var titleLabel = UILabel.createTitleLabel("新規登録")// タイトル
    var emailLabel = UILabel.createSubTitleLabel("メールアドレス")// メールアドレスラベル
    var emailTextField = UITextField.createTextField("メールアドレス")// メールアドレステキストフィールド
    var passwordLabel = UILabel.createSubTitleLabel("パスワード")// パスワードラベル
    var passwordTextField = UITextField.createTextField("パスワード")// パスワードテキストフィールド
    var checkPasswordLabel = UILabel.createSubTitleLabel("パスワード（確認用）")// 確認用パスワードラベル
    var checkPasswordTextField = UITextField.createTextField("パスワード（確認用）")// 確認用パスワードテキストフィールド
    var registerButton = UIButton.createButton("新規登録")// 新規登録ボタン
    var toLoginButton  = UIButton.createSubButton("既にアカウントをお持ちの方はこちらから")// ログイン画面へ
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        toLoginButton.addTarget(self, action: #selector(toLogin), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor(named: "main")
        // 戻るボタンを隠す
        self.navigationItem.hidesBackButton = true
       
        let stackviews = [
            [emailLabel,emailTextField],
            [passwordLabel,passwordTextField],
            [checkPasswordLabel,checkPasswordTextField]
        ].map { views in
            let stackview = UIStackView(arrangedSubviews: views)
            stackview.axis = .vertical
            stackview.spacing = 5
            stackview.translatesAutoresizingMaskIntoConstraints = false
            return stackview
        }
        
        let baseStackView = UIStackView(arrangedSubviews: stackviews)
        baseStackView.axis = .vertical
        baseStackView.spacing = 10
        baseStackView.distribution = .fillEqually
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(baseStackView)
        view.addSubview(registerButton)
        view.addSubview(toLoginButton)
        
        titleLabel.anchor(top: view.topAnchor,
                          centerX: view.centerXAnchor,
                          topPadding: 100)
        emailTextField.anchor(height: 40)
        passwordTextField.anchor(height: 40)
        checkPasswordTextField.anchor(height: 40)
        baseStackView.anchor(top: titleLabel.bottomAnchor ,
                             centerX: view.centerXAnchor,
                             width: view.bounds.width - 50,
                             topPadding: 100)
        registerButton.anchor(top: baseStackView.bottomAnchor ,
                          centerX: view.centerXAnchor,
                           width: view.bounds.width - 50,
                           height: 50,
                           topPadding: 30)
        toLoginButton.anchor(top: registerButton.bottomAnchor ,
                                centerX: view.centerXAnchor,
                                topPadding: 10)
    }
    
    // ログイン画面に戻る
    @objc private func toLogin() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
