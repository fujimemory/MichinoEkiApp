//
//  RegisterViewController.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import UIKit
import RxSwift

class RegisterViewController: UIViewController {
    
    //MARK: - Property
    var viewModel = RegisterViewModel()
    private let disposeBag = DisposeBag()
    //MARK: - UIView
    var titleLabel = UILabel.createTitleLabel("新規登録")// タイトル
    var emailLabel = UILabel.createSubTitleLabel("メールアドレス")// メールアドレスラベル
    var emailTextField = UITextField.createTextField("メールアドレス")// メールアドレステキストフィールド
    var passwordLabel = UILabel.createSubTitleLabel("パスワード")// パスワードラベル
    var passwordTextField = UITextField.createTextField("半角英数字8文字以上")// パスワードテキストフィールド
    var checkPasswordLabel = UILabel.createSubTitleLabel("パスワード（確認用）")// 確認用パスワードラベル
    var checkPasswordTextField = UITextField.createTextField("パスワード（確認用）")// 確認用パスワードテキストフィールド
    var registerButton = UIButton.createButton("新規登録")// 新規登録ボタン
    var toLoginButton  = UIButton.createSubButton("既にアカウントをお持ちの方はこちらから")// ログイン画面へ
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBinding()
        toLoginButton.addTarget(self, action: #selector(toLogin), for: .touchUpInside)
//        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
  
    // ログイン画面に戻る
    @objc private func toLogin() {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @objc func register() {
//        print("登録します")
//    }
}


extension RegisterViewController {
    private func setupLayout() {
        view.backgroundColor = UIColor(named: "main")
        // 戻るボタンを隠す
        self.navigationItem.hidesBackButton = true
        
        passwordTextField.isSecureTextEntry = true
        checkPasswordTextField.isSecureTextEntry = true
       
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
    
    private func setupBinding() {
        emailTextField.rx.text
            .asDriver()
            .drive { text in
                self.viewModel.emailInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .asDriver()
            .drive { text in
                self.viewModel.passwordInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        checkPasswordTextField.rx.text
            .asDriver()
            .drive { text in
                self.viewModel.checkPasswordInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        viewModel.validRegisterDriver
            .drive { validAll in
                self.registerButton.isEnabled = validAll
                self.registerButton.backgroundColor = validAll ? UIColor(named: "sub") : UIColor.systemGray
            }
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .asDriver()
            .drive { [weak self] _  in
                self?.viewModel.createUser(email: self?.emailTextField.text,
                                           pass: self?.passwordTextField.text){ result in
                    if result {
                        self?.dismiss(animated: true)
                    }else {
                        print("新規登録に失敗しました")
                    }
                }
                
            }
            .disposed(by: disposeBag)
    }
            
}
