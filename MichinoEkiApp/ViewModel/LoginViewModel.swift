//
//  LoginViewModel.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/16.
//

import Foundation
import RxCocoa
import RxSwift

protocol LoginInput {
    var emailInput : AnyObserver<String> { get }
    var passwordInput : AnyObserver<String> { get }
}

protocol LoginOutput {
    var emailOutput : PublishSubject<String> { get }
    var passwordOutput : PublishSubject<String> { get }
}

class LoginViewModel : LoginInput,LoginOutput {
    
    let disposeBag = DisposeBag()
    //MARK: - OutPuts
    var emailOutput = PublishSubject<String>()
    var passwordOutput = PublishSubject<String>()
    var validLoginSubject = BehaviorSubject<Bool>(value: false)
    
    //MARK: - Inputs
    var emailInput: AnyObserver<String>{
        emailOutput.asObserver()
    }
    
    var passwordInput: AnyObserver<String> {
        passwordOutput.asObserver()
    }
    
    var validLoginDriver : Driver<Bool> = Driver.never()
    
    init(){
        validLoginDriver = validLoginSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let combine = Observable.combineLatest(emailOutput.asObservable(),
                                               passwordOutput.asObservable())
        
        combine
            .map { email,pass in
                !email.isEmpty &&
                !pass.isEmpty
            }
            .subscribe { event in
                self.validLoginSubject.onNext(event)
            }
            .disposed(by: disposeBag)
        
    }
}
