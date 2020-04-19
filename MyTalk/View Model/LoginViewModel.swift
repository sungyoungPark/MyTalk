//
//  LoginViewModel.swift
//  MyTalk
//
//  Created by 박성영 on 09/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation
import  Firebase

class LoginViewModel {
    var model = Dynamic(LoginModel())
    
    func loginEvent(){
        Auth.auth().signIn(withEmail: model.value.email, password: model.value.password){ (user , error) in
            if error != nil{
                print("login 실패")
                self.model.value.isLoginSucess.value = false
            }
            else{
                Auth.auth().addStateDidChangeListener { ( auth, user ) in
                    if user != nil {
                        print("로그인 성공")
                        self.model.value.isLoginSucess.value = true
                    }
                }
            }
        }
    }
    
    
}
