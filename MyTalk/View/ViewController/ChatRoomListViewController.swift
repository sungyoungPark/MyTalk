//
//  ChatRoomListViewController.swift
//  MyTalk
//
//  Created by 박성영 on 21/05/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class ChatRoomListViewController: UIViewController {

    @IBOutlet var tv: UITableView!
    var viewModel = ChatRoomListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ChatRoomListView 실행")
        viewModel.getChatRoomList()
        // Do any additional setup after loading the view.
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

extension ChatRoomListViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tv.dequeueReusableCell(withIdentifier: "chatRowCell", for: indexPath) 
      
        return cell
    }
    
    
}
