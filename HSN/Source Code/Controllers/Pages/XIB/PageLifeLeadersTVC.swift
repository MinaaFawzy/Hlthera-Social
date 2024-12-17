//
//  PageLifeLeadersTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 03/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class PageLifeLeadersTVC: UITableViewCell {
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var collectionViewLeaders: UICollectionView!
    var isDeleteHidden:Bool = false
    var leaders:[AllUserModel] = [] {
        didSet{
            self.collectionViewLeaders.reloadData()
        }
    }
    func updateData(heading:String,description:String,data:[AllUserModel]){
        self.labelDescription.text = description.capitalized
        self.leaders = data
        self.labelHeading.text = heading.capitalized
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionViewLeaders.delegate = self
        self.collectionViewLeaders.dataSource = self
        self.collectionViewLeaders.register(PageLifeLeaderCVC.nib, forCellWithReuseIdentifier: PageLifeLeaderCVC.identifier)
        self.collectionViewLeaders.register(ViewPageLifeLeaderCVC.nib, forCellWithReuseIdentifier: ViewPageLifeLeaderCVC.identifier)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension PageLifeLeadersTVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leaders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewPageLifeLeaderCVC.identifier, for: indexPath) as! ViewPageLifeLeaderCVC
        let obj = leaders[indexPath.row]
        cell.labelName.text = obj.full_name
        cell.labelProfile.text = obj.employee_type
        cell.buttonDelete.isHidden = isDeleteHidden
        cell.deleteCallback = {
            self.leaders[indexPath.row] = AllUserModel(data: [:])
            self.collectionViewLeaders.reloadData()
        }
        cell.imageProfile.downlodeImage(serviceurl: kBucketUrl + obj.profile_pic, placeHolder: UIImage(named: "profile_placeholder")!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewLeaders.frame.width/3.15, height: self.collectionViewLeaders.frame.height)
    }
    
    
    
    
}
