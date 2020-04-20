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
    
    func bindViewModel(){
        if let viewModel = viewModel{
            viewModel.modelArray.bind({ (modelArray) in
                DispatchQueue.main.async {
                    
                    self.tv.reloadData()
                    
                }
                
            })
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.modelArray.value.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! MyFriendTableViewCell
       
        cell.name.text = viewModel?.modelArray.value[indexPath.row].friendName
        cell.profile.image = viewModel?.modelArray.value[indexPath.row].profileImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
