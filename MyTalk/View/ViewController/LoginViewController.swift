//
//  LoginViewController.swift
//  MyTalk
//
//  Created by 박성영 on 09/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: BindingTextField!{
        didSet{
            emailTextField.bind{ [weak self] email in
                self?.viewModel?.model.value.email = email
            }
        }
    }
    
    @IBOutlet var passwdTextField: BindingTextField! {
        didSet{
            passwdTextField.bind{ [weak self] password in
                self?.viewModel?.model.value.password = password
            }
        }
    }
    
    var viewModel : LoginViewModel?
    var alertControllerManager : AlertControllerService? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel()
        bindViewModel()
    }
    
    func bindViewModel(){
        if let viewModel = viewModel{
            viewModel.model.value.isLoginSucess.bind({ (flag) in
                DispatchQueue.main.async {
                    if(flag){
                        let mainTalkVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as! UITabBarController
                        UIApplication.shared.keyWindow?.rootViewController = mainTalkVC
                    }
                    else{
                        print("login false")
                    }
                }
            })
        }
    }
    
    @IBAction func logInEvent(_ sender: Any) {
        viewModel?.loginEvent()
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
