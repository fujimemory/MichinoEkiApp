//
//  CreateMemoryViewController.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import UIKit

class CreateMemoryViewController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - UIViews
    var dismissButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("キャンセル", for: .normal)
        button.setTitleColor(.init(named: "main"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("保存", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .init(named: "main")
        button.layer.cornerRadius = 15
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .gray
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        dismissButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
  
}

extension CreateMemoryViewController {
    private func setupLayout(){
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews:[dismissButton,saveButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.addSubview(textView)
        
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor ,
                         centerX: view.centerXAnchor,
                         width: view.bounds.width - 20,
                         height: 50)
        saveButton.anchor(width: 80,height: 30)
        
        textView.anchor(top: stackView.bottomAnchor,
                        bottom: view.bottomAnchor,
                        centerX: view.centerXAnchor,
                        width: view.bounds.width - 20)
    }
    @objc private func back(){
        self.dismiss(animated: true)
    }
}


