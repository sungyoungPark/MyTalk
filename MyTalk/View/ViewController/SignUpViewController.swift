//
//  SignUpViewController.swift
//  MyTalk
//
//  Created by 박성영 on 14/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController {
    
    var viewModel = SignUpViewModel()
    
    @IBOutlet var email: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
       viewModel.signUpEvent(email: email.text!, password: password.text!, name: name.text!, completion: goBackLoginView)
        
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goBackLoginView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
