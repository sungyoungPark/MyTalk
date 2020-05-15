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
    
    func signUpEvent(){
        Auth.auth().createUser(withEmail: model.value.email, password: model.value.password) { authResult, error in
            let uid = authResult?.user.uid
            let email = authResult?.user.email?.replacingOccurrences(of: ".", with: ",")
            if authResult !=  nil{
                print("register success")
                let profile = self.model.value.profile.value!.jpegData(compressionQuality: 0.1)
                let imageRef = Storage.storage().reference().child("userProfile").child(uid!)
                imageRef.putData(profile!, metadata: nil) { (data, error) in
                    imageRef.downloadURL { (url, error) in
                        if error != nil{
                            print("url 실패")
                        } else{
                            let values = ["email":email,"name":self.model.value.name,"profileImageURL":url?.absoluteString,"uid":uid]
                            Database.database().reference().child("users").child(email!).setValue(values, withCompletionBlock: {(err,ref) in
                                if(err==nil){
                                    self.model.value.isSignUpSucess.value = true
                                }
                                
                            })
                            
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
