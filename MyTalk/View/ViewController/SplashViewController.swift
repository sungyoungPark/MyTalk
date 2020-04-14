//
//  ViewController.swift
//  MyTalk
//
//  Created by 박성영 on 05/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit
//import Firebase


class SplashViewController: UIViewController {
    
    var viewModel : SplashViewModel?
    //var remoteConfig : RemoteConfig!
    let alertControllerManager = AlertControllerService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SplashViewModel(completion: displayWelcome)
    }
    
    
    func displayWelcome(){
        if (viewModel!.remote_config_caps!) {
            let alert = alertControllerManager.makeAlertController(title: "공지사항", message: viewModel!.remote_config_message!, OK_handler: {(action) -> Void in exit(0)})
            self.view.backgroundColor = .gray
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            loginVC.viewModel.remoteConfig = viewModel!.remoteConfig
            loginVC.alertControllerManager = alertControllerManager
            print("건네주기")
            OperationQueue.main.addOperation {
                UIApplication.shared.keyWindow?.rootViewController = loginVC
            }
        }
        
    }
    
    
    
}

