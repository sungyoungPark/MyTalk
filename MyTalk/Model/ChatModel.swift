//
//  ChatModel.swift
//  MyTalk
//
//  Created by 박성영 on 23/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import Foundation

class ChatModel : NSObject {
    
    var users : Dictionary<String,Bool> = [:]  //채팅방에 참여한 사람들
    var comments : Dictionary<String,Comment> = [:]  //채팅방의 대화 내용
    
    class Comment {
        var uid : String?
        var message : String?
    }
    
    
    
}
