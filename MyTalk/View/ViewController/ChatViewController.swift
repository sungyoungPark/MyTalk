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
    
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var tv: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        //sendBtn.isEnabled = false
        navigationItem.title = viewModel.destinationFriend.value.name  //채팅방 이름 설정
        viewModel.findChatRoom()
        bindViewModel()
       
        //print(viewModel)
        //viewModel.checkChatRoom()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func bindViewModel(){
        
        viewModel.isCreateChatRoom.bind { (flag) in
            DispatchQueue.main.async {
                if (flag == true){
                    self.sendBtn.isEnabled = true
                }
                else{
                    self.sendBtn.isEnabled = false
                }
            }
        }
        
        viewModel.comments.bind { (log) in
            DispatchQueue.main.async {
                self.tv.reloadData()
                if(self.viewModel.comments.value.count > 0){  //채팅 마지막으로 테이블뷰 이동
                    self.tv.scrollToRow(at: IndexPath(item: self.viewModel.comments.value.count-1, section: 0), at: UITableView.ScrollPosition.bottom, animated: false)
                }
                
            }
        }
        
    }
    
    
    
    
    @IBAction func sendMSG(_ sender: Any) {
        viewModel.sendMSG()
        msgTextField.text = ""
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


extension ChatViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(viewModel.comments.value[indexPath.row].keys.first == viewModel.uid){
            let cell = tv.dequeueReusableCell(withIdentifier: "myMsgCell", for: indexPath) as! MyMessageCell
            cell.msgLabel.text = viewModel.comments.value[indexPath.row].values.first
            cell.msgLabel.numberOfLines = 0
            return cell
        }
        else{  //상대방이 채팅한 거에 대하여 구현
            let cell = tv.dequeueReusableCell(withIdentifier: "friendMsgCell", for: indexPath) as! FriendMessageCell
        
            cell.msgLabel.text = viewModel.comments.value[indexPath.row].values.first
            cell.profileImageView.image = viewModel.destinationProfile
            cell.nameLabel.text = viewModel.destinationFriend.value.name
            
            return cell
        }
       
        // return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
