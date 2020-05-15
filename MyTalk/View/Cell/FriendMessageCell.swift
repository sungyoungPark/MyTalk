//
//  FriendMessageCell.swift
//  MyTalk
//
//  Created by 박성영 on 06/05/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class FriendMessageCell: UITableViewCell {

    @IBOutlet var msgLabel: UILabel!
    
    @IBOutlet var timeStamp: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
