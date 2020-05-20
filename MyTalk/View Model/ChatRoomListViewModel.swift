//
//  ChatRoomListViewModel.swift
//  MyTalk
//
//  Created by 박성영 on 21/05/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation
import Firebase

class ChatRoomListViewModel {
    
    let email = Auth.auth().currentUser?.email!.replacingOccurrences(of: ".", with: ",")
    
    func getChatRoomList(){
        print("getChatRoomList")
        Database.database().reference().child("users/"+email!+"/friendList").observeSingleEvent(of: DataEventType.value) { (DataSnapshot) in
            
            for item in DataSnapshot.children.allObjects as! [DataSnapshot]{
                let data = item.value as? [String:AnyObject]
                print("///////")
                print(data)
                print(data?["chatRoomUid"])
            }
        }
        print("getChatRoomList 끝")
    }
    
    
}
