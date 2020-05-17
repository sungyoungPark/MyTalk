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
    
    var destinationFriend = Dynamic(MyFriendModel())
    
    var uid = Auth.auth().currentUser?.uid   //내 uid
    var destinationUid : String?
    var destinationEmail : String?
    var destinationProfile : UIImage?
    
    var isCreateChatRoom = Dynamic(true)
    
    var chatRoomUid = ""
    var chatTimeStamp = ""   //채팅시간 기록  오후 몇시 몇분
    var chatDayStamp = ""       //채팅 년월일 기록
    
    var msg : String?
    var comments = Dynamic([[String:String]]())
    
    func findChatRoom() {
        chatRoomUid = destinationFriend.value.chatRoomUid
        destinationUid = destinationFriend.value.uid
        destinationEmail = destinationFriend.value.email
        destinationProfile = destinationFriend.value.profileImage
        
        if chatRoomUid == ""{
            print("처음 채팅")
        }
        else{
            print("처음 채팅 아님")
            getMsgList()
        }
    }
    
    func sendMSG(){
        if msg != nil{  //아무것도 안적혀있으면 채팅 안됨
            
            //DateFormatter로 따로 뺄것
            let formatterYMDDay = DateFormatter()
            formatterYMDDay.locale = Locale(identifier: "Ko_kr")
            formatterYMDDay.dateFormat = "yyyy년 MM월 dd일 EEEE"
            let formatterHM = DateFormatter()
            formatterHM.locale = Locale(identifier: "Ko_kr")
            formatterHM.dateFormat = "a h시 mm분"
            chatDayStamp = formatterYMDDay.string(from: Date())
            chatTimeStamp = formatterHM.string(from: Date())
            print("timeStamp", chatTimeStamp)
            
            
            let roomInfo : Dictionary<String,Any> = ["users" :[uid: true,destinationUid:true]]
            if(chatRoomUid == ""){
                print("채팅방 생성")
                isCreateChatRoom.value = false
                Database.database().reference().child("chatRooms").childByAutoId().setValue(roomInfo)
                checkChatRoom()
                
            }else{
                print("기존 채팅방 사용")
                let value : Dictionary<String,Any> = ["comment": ["uid":uid!,"message": msg,"timeStamp":chatTimeStamp]]
                Database.database().reference().child("chatRooms").child(chatRoomUid).child("comments").child(chatDayStamp).childByAutoId().setValue(value)
                getMsgList()
                print("기존 채팅방 끝")
            }
        }
        // msg = nil
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
                        
                        let value : Dictionary<String,Any> = ["comment": ["uid":self.uid!,"message": self.msg,"timeStamp":self.chatTimeStamp]]
                        Database.database().reference().child("chatRooms").child(self.chatRoomUid).child("comments").child(self.chatDayStamp).childByAutoId().setValue(value)
                        self.getMsgList()
                    }
                    
                }
                
                
            }
        }
        print("check 끝")
    }
    
    func getMsgList(){
        var count = 0
        Database.database().reference().child("chatRooms").child(chatRoomUid).child("comments").observe(DataEventType.value) { (datasnapshot) in
            self.comments.value.removeAll()
            for items in datasnapshot.children.allObjects as! [DataSnapshot]{
                print("key",items.key)  //채팅한 날짜 적혀있음
                let dayStamp = ["chatDayStamp":items.key]
                self.comments.value.append(dayStamp)
                for item in items.children.allObjects as! [DataSnapshot]{
                    let log = item.value as? [String:AnyObject]
                    let logUpdate = ["uid":log!["comment"]!["uid"]?.description,"message":log!["comment"]!["message"]?.description,
                                     "timeStamp":log!["comment"]!["timeStamp"]?.description]
                    
                    self.comments.value.append(logUpdate as! [String : String])
                }
                
            }
            self.msg = nil
        }
    }
    
}
