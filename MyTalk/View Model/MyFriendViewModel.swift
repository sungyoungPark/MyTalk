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
    
    var modelArray = Dynamic([MyFriendModel()])  //친구 목록
    var myProfile =  Dynamic(MyFriendModel())  //내 프로필
    
    var waitFriendList = Dynamic([MyFriendModel()])   //친구 추가를 기다리는 리스트
    var isUpdateFriend = Dynamic(false)  //친구 업데이트 추가
    
    var myProfileURL = ""
    
    init() {
        getFirebaseData()
    }
    
    func getFirebaseData(){
        let email = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: ",")
        Database.database().reference().child("users").child(email!).observe(DataEventType.value, with: { (snapShot) in
            let postDict = snapShot.value as? [String : AnyObject] ?? [:]
            
            self.modelArray.value.removeAll()
            self.waitFriendList.value.removeAll()
            
            var profile = MyFriendModel()
            profile.name = postDict["name"] as! String
            profile.uid = postDict["uid"] as! String
            profile.email = email!
            self.myProfileURL = (postDict["profileImageURL"]?.description)!
            URLSession.shared.dataTask(with:  URL(string: self.myProfileURL)!) { (Data, URLResponse, Error) in
                DispatchQueue.main.async {
                    let profileImage = UIImage(data: Data!)
                    profile.profileImage = profileImage!
                    self.myProfile.value = profile
                }
            }.resume()
            //--내 프로필 추가
            let friendList = postDict["friendList"] as? [String : AnyObject] ?? [:]
            if (postDict["friendList"] == nil){
                print("친구 없음")
            }else{  //친구 리스트 있음
                for child in friendList{
                    if ((child.value["isFriend"]?.boolValue) == false){  //친구 요청 있을때
                        var waitFriend = MyFriendModel()
                        waitFriend.name = child.value["name"]!.description
                        waitFriend.email = child.key
                        
                        URLSession.shared.dataTask(with:  URL(string: child.value["profileImageURL"]!.description)!) { (Data, URLResponse, Error) in
                            DispatchQueue.main.async {
                                let profileImage = UIImage(data: Data!)
                                waitFriend.profileImage = profileImage!
                                self.waitFriendList.value.append(waitFriend)
                                 self.isUpdateFriend.value = true
                            }
                        }.resume()
                        
                    }
                        
                    else{  //친구 리스트 추가
                        var friend = MyFriendModel()
                        friend.name = child.value["name"]!.description
                        friend.uid = child.value["uid"]!.description
                        friend.email = child.key
                        URLSession.shared.dataTask(with:  URL(string: child.value["profileImageURL"]!.description)!) { (Data, URLResponse, Error) in
                            DispatchQueue.main.async {
                                let profile = UIImage(data: Data!)
                                friend.profileImage = profile!
                                self.modelArray.value.append(friend)
                            }
                        }.resume()
                    }
                }
                print("친구 있음")
            }
            
        })
        
    }
    
    
    
    func addFriend(email : String){
        let myEmail = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: ",")
        let friendEmail = email.replacingOccurrences(of: ".", with: ",")
        let value = ["isFriend": false,"name" : myProfile.value.name.description,"profileImageURL":myProfileURL,"uid":myProfile.value.uid.description] as [String : Any]
        Database.database().reference().child("users").child(friendEmail).child("friendList").child(myEmail!).setValue(value)
    }
    
    func agreeFriendRequest(friendModel : MyFriendModel){
        print(friendModel)
        let email = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: ",")
        Database.database().reference().child("users").child(email!).child("friendList").child(friendModel.email).child("isFriend").setValue(true)   //내 데이터에서 친구추가
        
        let value = ["isFriend" : true,"name":myProfile.value.name,"profileImageURL":myProfileURL,"uid":myProfile.value.uid] as [String : Any]
        Database.database().reference().child("users").child(friendModel.email).child("friendList").child(email!).setValue(value)   //친구 데이터에서 내 데이터 추가
    }
    
}
