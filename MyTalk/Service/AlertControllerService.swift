//
//  AlertControllerService.swift
//  MyTalk
//
//  Created by 박성영 on 09/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class AlertControllerService {
    
    func makeAlertController(title : String, message : String , OK_handler : @escaping ((UIAlertAction)-> Void)) ->UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: OK_handler))
        
        return alert
    }
    
}
