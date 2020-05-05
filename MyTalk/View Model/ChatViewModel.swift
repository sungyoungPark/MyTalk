//
//  ChatViewModel.swift
//  MyTalk
//
//  Created by 박성영 on 03/05/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation
import Firebase

class ChatViewModel{
    
    var uid = Auth.auth().currentUser?.uid
    var destinationUid : String?
    var destinationEmail : String?
    
    var isCreateChatRoom = Dynamic(true)
    
    var chatRoomUid = ""
    
    var msg : String?
    var comments = Dynamic([[String:String]]())
    
    func findChatRoom() {
       if chatRoomUid == ""{
            print("처음 채팅")
        }
        else{
            print("처음 채팅 아님")
            getMsgList()
        }
    }
    
    func sendMSG(){
        let roomInfo : Dictionary<String,Any> = ["users" :[uid: true,destinationUid:true]]
        if(chatRoomUid == ""){
            print("채팅방 생성")
            isCreateChatRoom.value = false
            Database.database().reference().child("chatRooms").childByAutoId().setValue(roomInfo)
            checkChatRoom()
            
        }else{
            print("기존 채팅방 사용")
            let value : Dictionary<String,Any> = ["comment": ["uid":uid!,"message": msg]]
            Database.database().reference().child("chatRooms").child(chatRoomUid).child("comments").childByAutoId().setValue(value)
            getMsgList()
            print("기존 채팅방 끝")
        }

    }
    
    
    func checkChatRoom(){  //viewModel로
        print("check 확인")
        let myEmail = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: ",")
        Database.database().reference().child("chatRooms").queryOrdered(byChild: "users/" + uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value) { (DataSnapshot) in
            for item in DataSnapshot.children.allObjects as! [DataSnapshot]{
                if let chatRoomDic = item.value as? [String:AnyObject]{
                    let check = chatRoomDic["users"]
                    if (check![self.destinationUid as Any] as? Bool != nil && check![self.destinationUid as Any] as! Bool == true){
                        self.chatRoomUid = item.key
                        self.isCreateChatRoom.value = true
                        Database.database().reference().child("users/"+myEmail!+"/friendList/"+self.destinationEmail!+"/chatRoomUid").setValue(self.chatRoomUid)
                        Database.database().reference().child("users/"+self.destinationEmail!+"/friendList/"+myEmail!+"/chatRoomUid").setValue(self.chatRoomUid)
                        
                        let value : Dictionary<String,Any> = ["comment": ["uid":self.uid!,"message": self.msg]]
                        Database.database().reference().child("chatRooms").child(self.chatRoomUid).child("comments").childByAutoId().setValue(value)
                        self.getMsgList()
                    }
                    
                }
                
                
            }
        }
        print("check 끝")
    }
    
    func getMsgList(){
        Database.database().reference().child("chatRooms").child(chatRoomUid).child("comments").observe(DataEventType.value) { (datasnapshot) in
            self.comments.value.removeAll()
            
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                let log = item.value as? [String:AnyObject]
                let logUpdate = [log!["comment"]!["uid"]?.description:log!["comment"]!["message"]?.description]
                self.comments.value.append(logUpdate as! [String : String])
            }
        }
    }
    
}
