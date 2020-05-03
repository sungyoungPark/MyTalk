//
//  ChatViewController.swift
//  MyTalk
//
//  Created by 박성영 on 21/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    var viewModel = ChatViewModel()
    
    @IBOutlet var msgTextField: BindingTextField!{
        didSet{
            msgTextField.bind { [weak self] msg in
                self?.viewModel.msg = msg
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        findChatRoom()
        viewModel.checkChatRoom()
    }
    
    func findChatRoom(){
        if viewModel.chatRoomUid == ""{
            print("처음 채팅")
        }
        else{
            print("처음 채팅 아님")
        }
    }
    
    
    @IBAction func sendMSG(_ sender: Any) {
        viewModel.sendMSG()
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
