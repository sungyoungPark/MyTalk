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
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 1) {
            return "친구"
        }
        else{
            return "내 프로필"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 1
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
                vc.destinationUid = viewModel?.modelArray.value[indexPath.row].uid
            }
        }
    }
    
    
    
}
