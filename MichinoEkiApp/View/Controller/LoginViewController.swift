//
//  LoginViewController.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    //MARK: - Property
    private let disposeBag = DisposeBag()
    private var viewModel = LoginViewModel()
    //MARK: - UIView
    var titleLabel = UILabel.createTitleLabel("ログイン")// タイトル
    var emailLabel = UILabel.createSubTitleLabel("メールアドレス")// メールアドレスラベル
    var emailTextField = UITextField.createTextField("メールアドレス")// メールアドレステキストフィールド
    var passwordLabel = UILabel.createSubTitleLabel("パスワード")// パスワードラベル
    var passwordTextField = UITextField.createTextField("パスワード")// パスワードテキストフィールド
    var loginButton = UIButton.createButton("ログイン")// ログインボタン
    var toRegisterButton  = UIButton.createSubButton("アカウントをお持ちでない方はこちらから")// 登録画面へ
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupBinding()
        toRegisterButton.addTarget(self, action: #selector(toRegister), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension LoginViewController {
    //MARK: - Function
    // レイアウト
    private func setupLayout() {
        view.backgroundColor = UIColor(named: "main")
        passwordTextField.isSecureTextEntry = true
       
        let stackviews = [[emailLabel,emailTextField],[passwordLabel,passwordTextField]].map { views in
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
        view.addSubview(loginButton)
        view.addSubview(toRegisterButton)
        
        titleLabel.anchor(top: view.topAnchor,
                          centerX: view.centerXAnchor,
                          topPadding: 100)
        emailTextField.anchor(height: 40)
        passwordTextField.anchor(height: 40)
        baseStackView.anchor(top: titleLabel.bottomAnchor ,
                             centerX: view.centerXAnchor,
                             width: view.bounds.width - 50,
                             topPadding: 100)
        loginButton.anchor(top: baseStackView.bottomAnchor ,
                          centerX: view.centerXAnchor,
                           width: view.bounds.width - 50,
                           height: 50,
                           topPadding: 30)
        toRegisterButton.anchor(top: loginButton.bottomAnchor ,
                                centerX: view.centerXAnchor,
                                topPadding: 10)
    }
    
    // 登録画面への遷移
    @objc private func toRegister() {
        let nextVC = RegisterViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // ViewModelとのバインディング
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
        
        viewModel.validLoginDriver
            .asDriver()
            .drive { valid  in
                self.loginButton.isEnabled = valid
                self.loginButton.backgroundColor = valid ? UIColor(named: "sub") : UIColor.systemGray
            }
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .asDriver()
            .drive {[weak self] _ in
                print("ログインします")
                self?.viewModel.login(email: self?.emailTextField.text,
                                password: self?.passwordTextField.text) { result in
                    if result {
                        self?.dismiss(animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
  
}
