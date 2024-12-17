//
//  MessagesTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 21/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

//class MessagesTVC: UITableViewCell {
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}

class MessagesTVC: UITableViewCell {

    @IBOutlet weak var imageUserProfile:UIImageView!
    @IBOutlet weak var labelName:UILabel!
    @IBOutlet weak var labelLastMessage:UILabel!
    @IBOutlet weak var labelLastMesssageTime:UILabel!
    
    var contact:Contacts?
    var Messageclass = [MessageClass]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        self.imageUserProfile.downlodeImage(serviceurl: String.getString(self.contact?.profilePicture), placeHolder: #imageLiteral(resourceName: "avtar_android"))
      //  self.imageUserProfile.loadImageAsync(with: String.getString(self.contact?.profilePicture), placeholderImage: #imageLiteral(resourceName: "avtar_android"))
        self.labelName.text = " \(String.getString(self.contact?.firstName)) \(String.getString(self.contact?.LastName))"
        self.Messageclass = MessageList.fetchMessagesForUser(userid: String.getString(self.contact?.id)) ?? []
        if self.Messageclass.count != 0{
          //  self.labelLastMesssageTime.text = String.getTime(timeStamp: String.getString(self.Messageclass[self.Messageclass.count - 1].SendingTime))
            self.labelLastMessage.text = String.getString(self.Messageclass[self.Messageclass.count - 1].Message)
        }else{
            self.labelLastMesssageTime.text = ""
            self.labelLastMessage.text = ""
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
