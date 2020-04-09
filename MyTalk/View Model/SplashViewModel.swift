//
//  MainViewModel.swift
//  MyTalk
//
//  Created by 박성영 on 09/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation
import Firebase

protocol SplashViewProtocol {
    var remoteConfig : RemoteConfig { get }
    
    var remote_config_message : String { get }
    
    var remote_config_caps : Bool { get }
    
    init(remoteConfig : RemoteConfig)
    
}


class SplashViewModel : SplashViewProtocol {
    
    var remoteConfig: RemoteConfig
    
    var remote_config_message: String
    
    var remote_config_caps: Bool
    
    required init(remoteConfig : RemoteConfig) {
        self.remoteConfig = remoteConfig
        self.remote_config_caps = remoteConfig["splash_message_caps"].boolValue
        self.remote_config_message = remoteConfig["splash_message"].stringValue!
    }
    
   
}
