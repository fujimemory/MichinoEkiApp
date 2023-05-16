//
//  RegisterViewModel.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/13.
//

import RxCocoa
import RxSwift
import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


protocol RegisterViewModelInput {
    var emailInput : AnyObserver<String> { get }
    var passwordInput : AnyObserver<String> { get }
    var checkPasswordInput : AnyObserver<String> { get }
}

protocol RegisterViewModelOutput {
    var emailOutput : PublishSubject<String>{ get }
    var passwordOutput : PublishSubject<String>{ get }
    var checkPasswordOutput : PublishSubject<String>{ get }
}

class RegisterViewModel : RegisterViewModelInput,
                          RegisterViewModelOutput {
    
    let disposeBag = DisposeBag()
    
    //MARK: - Outputs
    var emailOutput = PublishSubject<String>()
    
    var passwordOutput = PublishSubject<String>()
    
    var checkPasswordOutput = PublishSubject<String>()
    
    var validRegisterSubject = BehaviorSubject<Bool>(value: false)
    
    //MARK: - Inputs
    var emailInput: AnyObserver<String>{
        emailOutput.asObserver()
    }
    
    var passwordInput: AnyObserver<String>{
        passwordOutput.asObserver()
    }
    
    var checkPasswordInput: AnyObserver<String>{
        checkPasswordOutput.asObserver()
    }
    
    var validRegisterDriver : Driver<Bool> = Driver.never()
    
    init(){
        validRegisterDriver = validRegisterSubject
            .asDriver(onErrorDriveWith: Driver<Bool>.empty())
        
        // combineLatestでOutput群を一括監視
        let combine = Observable.combineLatest(emailOutput.asObservable(),
                                               passwordOutput.asObservable(),
                                               checkPasswordOutput.asObservable())
        combine
            .map { email,pass,check in
                !email.checkWhiteSpace &&
                !pass.checkWhiteSpace &&
                !check.checkWhiteSpace &&
                email.validEmail &&
                pass.validPassword &&
                pass == check
            }
            .subscribe { event in
                self.validRegisterSubject.onNext(event)
            }
            .disposed(by: disposeBag)
    }
    
    func createUser(email: String?,pass: String?,completion : @escaping (Bool) -> Void){
        guard let email = email,
              let pass = pass else { return }
        
        Auth.addUser(email: email, pass: pass) { result in
            completion(result)
        }
        
    }
}
