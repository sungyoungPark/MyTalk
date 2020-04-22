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
        getFirebaseData()
    }
    
    func getFirebaseData(){
        print(Auth.auth().currentUser?.email)
        Database.database().reference().child("users").observe(DataEventType.value, with: { (snapShot) in
            let postDict = snapShot.value as? [String : AnyObject] ?? [:]
            self.modelArray.value.removeAll()

            for child in postDict{
                var friend = MyFriendModel()
                friend.friendName = child.value["name"]!.description
                URLSession.shared.dataTask(with:  URL(string: child.value["profileImageURL"]!.description)!) { (Data, URLResponse, Error) in
                    DispatchQueue.main.async {
            
                    let profile = UIImage(data: Data!)
                    //friend.profileImage.layer.cornerRadius = (profile?.size.width)! / 2
                   // friend.profileImage.clipsToBounds = true
                        friend.profileImage = profile!
                    self.modelArray.value.append(friend)
                    }
                  
                }.resume()
                
            
            }
        })
        
    }
    
    
}
