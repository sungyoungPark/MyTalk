//
//  MainViewModel.swift
//  MyTalk
//
//  Created by 박성영 on 09/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation
import Firebase

//protocol SplashViewProtocol {
//    var remoteConfig : RemoteConfig { get }
//
//    var remote_config_message : String { get }
//
//    var remote_config_caps : Bool { get }
//
//    init(remoteConfig : RemoteConfig)
//
//}

class SplashViewModel {
    
    var remoteConfig: RemoteConfig
    
    var remote_config_message = Dynamic("")
    
    var remote_config_caps = Dynamic(true)
    
    required init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        fetchRemote()
    }
    
    
    func fetchRemote(){
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate(completionHandler: { (error) in
                    self.remote_config_message.value = self.remoteConfig["splash_message"].stringValue!
                    self.remote_config_caps.value = self.remoteConfig["splash_message_caps"].boolValue
                    print(self.remote_config_caps.value)
                })
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
}
