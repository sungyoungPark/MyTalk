//
//  MyFriendViewModel.swift
//  MyTalk
//
//  Created by 박성영 on 20/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation
import Firebase

class MyFriendViewModel {
    
    var modelArray = Dynamic([MyFriendModel()])
    
    init() {
        print("MyFriednViewModel")
        getFirebaseData()
    }
    
    func getFirebaseData(){
        Database.database().reference().child("users").observe(DataEventType.value, with: { (snapShot) in
            let postDict = snapShot.value as? [String : AnyObject] ?? [:]
            self.modelArray.value.removeAll()

            for child in postDict{
                print(child)
                var friend = MyFriendModel()
                friend.friendName = child.value["name"]!.description
                friend.profileImageURL = child.value["profileImageURL"]!.description
                self.modelArray.value.append(friend)
            }
            /*
            //viewController로
            DispatchQueue.main.async {
                self.tv.reloadData()
            }
            */
        })
        
    }
    
}
