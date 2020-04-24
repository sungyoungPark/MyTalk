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
    
    var destinationUid : String?
    
    var uid : String?
    var chatRoomUid : String?
    
    @IBOutlet var msgTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        uid = Auth.auth().currentUser?.uid
        checkChatRoom()
    }
    
    @IBAction func sendMSG(_ sender: Any) {
        let roomInfo : Dictionary<String,Any> = ["users" :[uid: true,destinationUid:true]]
        if(chatRoomUid == nil){
            Database.database().reference().child("chatRooms").childByAutoId().setValue(roomInfo)
        }else{
            let value : Dictionary<String,Any> = ["comments": ["uid":uid!,"message": msgTextField.text]]
            print(value)
        Database.database().reference().child("chatRooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value)
        }
        
        
    }
    
    
    func checkChatRoom(){
        Database.database().reference().child("chatRooms").queryOrdered(byChild: "users/" + uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value) { (DataSnapshot) in
            for item in DataSnapshot.children.allObjects as! [DataSnapshot]{
                
                if let chatRoomDic = item.value as? [String:AnyObject]{
                    let check = chatRoomDic["users"]
                    if (check![self.destinationUid as Any] as! Bool == true){
                        self.chatRoomUid = item.key
                    }
                    
                }
                
                
            }
        }
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
