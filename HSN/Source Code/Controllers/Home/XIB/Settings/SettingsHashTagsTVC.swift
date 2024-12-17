//
//  SettingsHashTagsTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 22/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class SettingsHashTagsTVC: UITableViewCell {
    @IBOutlet weak var tableViewHashtags: UITableView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    var parent:UIViewController? = nil
    var tags:[HashTagModel] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableViewHashtags.delegate = self
        self.tableViewHashtags.dataSource = self
        self.tableViewHashtags.register(UINib(nibName: NameTVC.identifier, bundle: .none), forCellReuseIdentifier: NameTVC.identifier)
        // Initialization code
    }
    func updateCell(data:[HashTagModel]){
        self.constraintTableViewHeight.constant = CGFloat(data.count * 30)
        self.tags = data
        self.tableViewHashtags.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension SettingsHashTagsTVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NameTVC.identifier, for: indexPath) as! NameTVC
        let obj = tags[indexPath.row]
        
        cell.callbackHashTag = {
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewTagVC.getStoryboardID()) as? ViewTagVC else { return }
            vc.tag = obj.name
            vc.tagId = obj.id
            self.parent?.navigationController?.pushViewController(vc, animated: true)
        }
        cell.buttonHashTag.setTitle(tags[indexPath.row].name, for: .normal)
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
   
    
}
