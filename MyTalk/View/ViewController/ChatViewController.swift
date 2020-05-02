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
    var destinationEmail : String?
    
    var uid : String?
    var chatRoomUid : String?
    
    @IBOutlet var msgTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        findChatRoom()
        uid = Auth.auth().currentUser?.uid
        checkChatRoom()
    }
    
    func findChatRoom(){
        if chatRoomUid == ""{
            print("처음 채팅")
        }
        else{
            print("처음 채팅 아님")
        }
    }
    
    
    @IBAction func sendMSG(_ sender: Any) {
        let roomInfo : Dictionary<String,Any> = ["users" :[uid: true,destinationUid:true]]
        if(chatRoomUid == ""){
            print("채팅방 생성")
            Database.database().reference().child("chatRooms").childByAutoId().setValue(roomInfo)
            checkChatRoom()
            
        }else{
            print("기존 채팅방 사용")
            let value : Dictionary<String,Any> = ["comment": ["uid":uid!,"message": msgTextField.text!]]
            Database.database().reference().child("chatRooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value)
            print("기존 채팅방 끝")
        }
    }
    
    
    func checkChatRoom(){
        print("check")
        let myEmail = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: ",")
        Database.database().reference().child("chatRooms").queryOrdered(byChild: "users/" + uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value) { (DataSnapshot) in
            for item in DataSnapshot.children.allObjects as! [DataSnapshot]{
                
                if let chatRoomDic = item.value as? [String:AnyObject]{
                    let check = chatRoomDic["users"]
                    if (check![self.destinationUid as Any] as! Bool == true){
                        self.chatRoomUid = item.key
                        Database.database().reference().child("users/"+myEmail!+"/friendList/"+self.destinationEmail!+"/chatRoomUid").setValue(self.chatRoomUid)
                        
                        Database.database().reference().child("users/"+self.destinationEmail!+"/friendList/"+myEmail!+"/chatRoomUid").setValue(self.chatRoomUid)
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
