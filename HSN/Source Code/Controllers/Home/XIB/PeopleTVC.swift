//
//  PeopleTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 17/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class PeopleTVC: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var data:[RecommendedUsersModel] = [] {
        didSet{
            self.collectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: PeopleCVC.identifier, bundle: nil), forCellWithReuseIdentifier: PeopleCVC.identifier)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell(data:[RecommendedUsersModel]){
        self.data = data
    }
}
extension PeopleTVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView.numberOfRow(numberofRow: data.count)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:PeopleCVC.identifier, for: indexPath) as! PeopleCVC
        let obj = data[indexPath.row]
        cell.updateCell(data: obj)
        cell.connectCallback = {
            globalApis.makeConnection(id: obj.id){
                
            }
        }
        cell.closeCallback = {
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.05, height: collectionView.frame.height)
    }
    
    
}
