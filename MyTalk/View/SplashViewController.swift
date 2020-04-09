//
//  ViewController.swift
//  MyTalk
//
//  Created by 박성영 on 05/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit
import Firebase


class SplashViewController: UIViewController {

    var viewModel : SplashViewModel?
    var remoteConfig : RemoteConfig!
    let alertControllerManager = AlertControllerService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setRemoteConfig()
       
    }

    
    func setRemoteConfig(){
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
          if status == .success {
            print("Config fetched!")
            self.remoteConfig.activate(completionHandler: { (error) in
              // ...
            })
          } else {
            print("Config not fetched")
            print("Error: \(error?.localizedDescription ?? "No error available.")")
          }
          self.viewModel = SplashViewModel(remoteConfig: self.remoteConfig)
          self.displayWelcome()
        }
    }
    
    func displayWelcome(){
       
        if (viewModel!.remote_config_caps) {
            let alert = alertControllerManager.makeAlertController(title: "공지사항", message: viewModel!.remote_config_message, OK_handler: {(action) -> Void in exit(0)})
            self.view.backgroundColor = .gray
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            //instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            UIApplication.shared.keyWindow?.rootViewController = loginVC
            //self.present(loginVC, animated: false, completion: nil)
        }
        
    }
    


}

