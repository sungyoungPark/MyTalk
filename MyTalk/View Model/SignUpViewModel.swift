//
//  SignUpViewModel.swift
//  MyTalk
//
//  Created by 박성영 on 15/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation
import Firebase

class SignUpViewModel {
    
    func signUpEvent(email : String, password : String, name : String , completion : @escaping(() -> Void)){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            let uid = authResult?.user.uid
            if authResult !=  nil{
                print("register success")
                Database.database().reference().child("users").child(uid!).setValue(["name":name])
                completion()
            }
            else{
                print("register failed")
            }
        }
    }
    
    
    
}
