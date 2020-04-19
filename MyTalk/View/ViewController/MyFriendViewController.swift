//
//  MainTalkViewController.swift
//  MyTalk
//
//  Created by 박성영 on 15/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit
import Firebase

class MyFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tv: UITableView!
    var array : [FriendModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        tv.delegate = self
        tv.dataSource = self
        getFirebase()
        print("getFirebase")
        // Do any additional setup after loading the view.
    }
    
    
    func getFirebase(){
        Database.database().reference().child("users").observe(DataEventType.value, with: { (snapShot) in
            let postDict = snapShot.value as? [String : AnyObject] ?? [:]
            self.array.removeAll()
            
            for child in postDict{
                var friend = FriendModel()
                friend.friendName = child.value["name"]!.description
                friend.profileImageURL = child.value["profileImageURL"]!.description
                self.array.append(friend)
                print(friend)
                // friendModel.
                
            }
            DispatchQueue.main.async {
                self.tv.reloadData()
            }
        })
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        
        let profile = UIImageView()
        cell.addSubview(profile)
        
        URLSession.shared.dataTask(with:  URL(string: array[indexPath.row].profileImageURL)!) { (Data, URLResponse, Error) in
            
            DispatchQueue.main.async {
                profile.image = UIImage(data: Data!)
                cell.imageView!.layer.cornerRadius = profile.frame.size.width / 2
                cell.imageView!.clipsToBounds = true
                cell.imageView!.image = profile.image
            }
        }.resume()
         cell.textLabel?.text = array[indexPath.row].friendName
       
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
