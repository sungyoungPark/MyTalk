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
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSignUp" {
            let signUpVC = segue.destination as? SignUpViewController
            signUpVC?.alertControllerManager = alertControllerManager
            
        }
        
    }
    
    
}
