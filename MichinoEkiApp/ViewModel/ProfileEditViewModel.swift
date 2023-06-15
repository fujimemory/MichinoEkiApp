//
//  ProfileEditViewModel.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/06/14.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProfileEditInput {
    var nameInput : AnyObserver<String> { get }
    var introductionInput : AnyObserver<String> { get }
}

protocol ProfileEditOutput{
    var nameOutput : PublishSubject<String> { get }
    var introductionOutput : PublishSubject<String> { get }
//    var validSaveSubject : BehaviorSubject<Bool> { get }
}

final class ProfileEditViewModel : ProfileEditInput,
                                   ProfileEditOutput{
    let disposeBag = DisposeBag()
    
    //MARK: - Output
    var nameOutput = PublishSubject<String>()
    
    var introductionOutput = PublishSubject<String>()
    
    var validSaveSubject = BehaviorSubject<Bool>(value: false)
    
    //MARK: - Input
    var nameInput: AnyObserver<String>{
        nameOutput.asObserver()
    }
    
    var introductionInput: AnyObserver<String>{
        introductionOutput.asObserver()
    }
    
    var validSaveDriver : Driver<Bool> = Driver.never()
    
    init(){
        validSaveDriver = validSaveSubject
            .asDriver(onErrorDriveWith: Driver<Bool>.empty())
        
        let combine = Observable.combineLatest(nameOutput.asObservable(),
                                               introductionOutput.asObservable())
        
        combine
            .map { (name,introduction) in
                let shapedName = name.shapedString
                let shapedIntroduction = introduction.shapedString
                
                let validName = shapedName.count > 0 && shapedName.count <= 15
                let validIntroduction = shapedIntroduction.count > 0 && shapedIntroduction.count <= 200
                
                let validAll = validName && validIntroduction
                return validAll
            }
            .subscribe(onNext: { event in
                self.validSaveSubject.onNext(event)
            })
            .disposed(by: disposeBag)
            
            
           
         
    }
    
    
}

