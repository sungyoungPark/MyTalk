//
//  MainTalkViewController.swift
//  MyTalk
//
//  Created by 박성영 on 15/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit
//import Firebase

class MyFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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
            self.viewModel?.addFriend(email: alert.textFields![0].text!)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .default){(cancel) in self.dismiss(animated: true, completion: nil)})
        self.present(alert, animated: true, completion: nil)
    }
    
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? MyFriendTableViewCell , let indexPath = tv.indexPath(for: cell) {
            if let vc = segue.destination as? ChatViewController{
                if (indexPath.section == 2){
                vc.destinationUid = viewModel?.modelArray.value[indexPath.row].uid
                }
            }
        }
    }
    
    
    
}
