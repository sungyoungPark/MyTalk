//
//  MainTalkViewController.swift
//  MyTalk
//
//  Created by 박성영 on 15/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit
//import Firebase

class MyFriendViewController: UIViewController {
    
    
    @IBOutlet var tv: UITableView!
    
    var viewModel : MyFriendViewModel?
    let alertControllerManager = AlertControllerService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MyFriendViewModel()
        bindViewModel()
        tv.delegate = self
        tv.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func bindViewModel(){
        if let viewModel = viewModel{
            viewModel.modelArray.bind({ (modelArray) in
                DispatchQueue.main.async {
                    self.tv.reloadData()
                }
            })
            viewModel.myProfile.bind({ (myProfile) in
                DispatchQueue.main.async {
                    self.tv.reloadData()
                }
                
            })
            viewModel.isUpdateFriend.bind({ (isAddFriend) in
                if (isAddFriend){
                    DispatchQueue.main.async {
                        self.tv.reloadData()
                    }
                }
            })
        }
    }
    
    @IBAction func addFriend(_ sender: Any) {
        let alert = UIAlertController(title: "친구추가", message: "이메일을 입력하세요", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "확인", style: .default){(ok) in
            let searchEmail = alert.textFields![0].text?.description.replacingOccurrences(of: ".", with: ",")
            if (searchEmail != self.viewModel?.myProfile.value.email){
                self.viewModel?.addFriend(email: alert.textFields![0].text!)
            }
            else{
                self.dismiss(animated: true, completion: nil)
                let errorAlert = self.alertControllerManager.makeAlertController(title: "오류", message: "잘 못된 이메일입니다.") { (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                }
                self.present(errorAlert, animated: true, completion: nil)
            }
        })
        alert.addAction(UIAlertAction(title: "취소", style: .default){(cancel) in self.dismiss(animated: true, completion: nil)})
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgChat"{
            if let vc = segue.destination as? ChatViewController{
                vc.viewModel.destinationUid = viewModel?.modelArray.value[sender as! Int].uid
                vc.viewModel.chatRoomUid = (viewModel?.modelArray.value[sender as! Int].chatRoomUid)!
                vc.viewModel.destinationEmail = viewModel?.modelArray.value[sender as! Int].email
                
            }
        }
    }
    
    
    
}

extension MyFriendViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 2) {
            return "친구"
        }
        else if (section == 1){
            return "친구 요청"
        }
        else{
            return "내 프로필"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 1
        }
        else if (section == 1){
            return (viewModel?.waitFriendList.value.count)!
        }
        else{
            return (viewModel?.modelArray.value.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! MyFriendTableViewCell
        
        if (indexPath.section == 0){
            cell.name.text = viewModel?.myProfile.value.name
            cell.profile.image = viewModel?.myProfile.value.profileImage
        }
        else if (indexPath.section == 1){
            cell.name.text = viewModel?.waitFriendList.value[indexPath.row].name
            cell.profile.image = viewModel?.waitFriendList.value[indexPath.row].profileImage
        }
        else{
            cell.name.text = viewModel?.modelArray.value[indexPath.row].name
            cell.profile.image = viewModel?.modelArray.value[indexPath.row].profileImage
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        if(indexPath.section == 2){   //채팅창으로
            performSegue(withIdentifier: "sgChat", sender: indexPath.row)
        }
            
        else if(indexPath.section == 1){  //친구수락 여부 창
            let alert = alertControllerManager.makeAlertController(title: "", message: "친구를 추가하시겠습니까?") { (UIAlertAction) in
                self.viewModel?.agreeFriendRequest(friendModel: (self.viewModel?.waitFriendList.value[indexPath.row])!)
            }
            alert.addAction(UIAlertAction(title: "취소", style: .default){(cancel) in self.dismiss(animated: true, completion: nil)})
            self.present(alert, animated: true, completion: nil)
        }
            
        else{ //프로필 수정창
            performSegue(withIdentifier: "sgChangeProfile", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(indexPath.section != 0){
            if editingStyle == .delete{
                print("삭제")
            }
        }
    }
    
}
