//
//  SignUpViewController.swift
//  MyTalk
//
//  Created by 박성영 on 14/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit
//import Firebase


class SignUpViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate {
    
    var viewModel : SignUpViewModel?
    var alertControllerManager : AlertControllerService? = nil
    
    @IBOutlet weak var email: BindingTextField! {
        didSet{
            email.bind{ [weak self] email in
                self?.viewModel?.model.value.email = email
            }
        }
    }
    
    @IBOutlet weak var name: BindingTextField! {
        didSet{
            name.bind{ [weak self] name in
                self?.viewModel?.model.value.name = name
            }
        }
    }
    
    @IBOutlet weak var password: BindingTextField! {
        didSet{
            password.bind{ [weak self] password in
                self?.viewModel?.model.value.password = password
            }
        }
    }
    
    @IBOutlet var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        name.delegate = self
        password.delegate = self
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        viewModel = SignUpViewModel()
        bindViewModel()
    }
    
    func bindViewModel(){
        if let viewModel = viewModel{
            viewModel.model.bind({ (model) in
                self.profileImageView.image = model.profile
            })
        }
        if let viewModel = viewModel{
            viewModel.model.value.isSignUpSucess.bind({ (flag) in
                if (flag) {
                    self.goBackLoginView()
                }
            })
        }
    }
    
    
    @objc func imagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        viewModel?.model.value.profile = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        viewModel!.signUpEvent()
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goBackLoginView(){
        let alert = alertControllerManager!.makeAlertController(title: "성공", message: "회원가입이 성공적으로 완료되었습니다.", OK_handler: {(action) -> Void in  self.dismiss(animated: true, completion: nil)})
        self.view.backgroundColor = .gray
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
