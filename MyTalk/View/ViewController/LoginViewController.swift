//
//  LoginViewController.swift
//  MyTalk
//
//  Created by 박성영 on 09/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwdTextField: UITextField!
    var viewModel = LoginViewModel()
    var alertControllerManager : AlertControllerService? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInEvent(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwdTextField.text!){ (user , error) in
            if error != nil{
                print("login 실패")
                
            }
            else{
                Auth.auth().addStateDidChangeListener { ( auth, user ) in
                    if user != nil {
                        print("로그인 성공")
                        let mainTalkVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTalkViewController") as! MainTalkViewController
                        UIApplication.shared.keyWindow?.rootViewController = mainTalkVC
                        //self.present(mainTalkVC, animated: true, completion: nil)
                    }
                    else{
                        print("잘못된 사용자 입니다.")
                    }
                }
            }
            
            
        }
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSignUp" {
            let signUpVC = segue.destination as? SignUpViewController
            signUpVC?.alertControllerManager = alertControllerManager
            
        }
        
    }
    
    
}
