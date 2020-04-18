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
    
    var model = Dynamic(SignUpModel())
    
    func signUpEvent(completion : @escaping(() -> Void)){
        Auth.auth().createUser(withEmail: model.value.email, password: model.value.password) { authResult, error in
            let uid = authResult?.user.uid
            if authResult !=  nil{
                print("register success")
                
                //let profile = profile.jpegData(compressionQuality: 0.1)
                let profile = self.model.value.profile!.jpegData(compressionQuality: 0.1)
                
                let imageRef = Storage.storage().reference().child("userProfile").child(uid!)
                print(profile)
                imageRef.putData(profile!, metadata: nil) { (data, error) in
                    imageRef.downloadURL { (url, error) in
                        if error != nil{
                            print("url 실패")
                        } else{                        Database.database().reference().child("users").child(uid!).setValue(["name":self.model.value.name,"profileImageURL":url?.absoluteString])
                            completion()
                        }
                    }
                }
            }
            else{
                print("register failed")
            }
        }
    }
    
    
    
}
