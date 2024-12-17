//
//  ExploreHeaderView.swift
//  HSN
//
//  Created by Prashant Panchal on 22/09/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import Firebase

class ExploreHeaderView: UIView {
    
    @IBOutlet weak var exploreCollectionView: UICollectionView!
    //@IBOutlet weak var viewNavigation: UIView!
    
    var selectedPostType: String = ""
    var exploreOptions: [ExploreOptionsModel] = []
    var callback: ((String)->())?
    
    var nav: UINavigationController?

    func updateData(data: [ExploreOptionsModel], nav: UINavigationController) {
//        CommonUtils.showHudWithNoInteraction(show: false)
        self.exploreOptions = data
        self.exploreCollectionView.delegate = self
        self.exploreCollectionView.dataSource = self
        self.exploreCollectionView.register(UINib(nibName: ExploreOptionsCVC.identifier, bundle: nil), forCellWithReuseIdentifier: ExploreOptionsCVC.identifier)
        self.exploreCollectionView.reloadData()
        exploreCollectionView.backgroundColor = UIColor(hexString: "#F5F7F9")
        self.nav = nav
    }
    
    @IBAction func buttonViewAllTapped(_ sender: Any) {
    }
    
}
extension ExploreHeaderView:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exploreOptions.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreOptionsCVC.identifier, for: indexPath) as! ExploreOptionsCVC
        let obj = exploreOptions[indexPath.row]
        cell.labelName.text = obj.name
        cell.viewBackground.backgroundColor = .white
        cell.viewBackground.layer.cornerRadius = 10
        
        
        if obj.isSelected{
            cell.labelName.textColor = UIColor(named: "10")!
            cell.viewBackground.backgroundColor = UIColor(named: "5")!
            if obj.localImageActive != nil{
                cell.imageIcon.image = obj.localImageActive
            }
            else{
                cell.imageIcon.kf.setImage(with: URL(string: kBucketUrl + obj.activeImage),placeholder:  #imageLiteral(resourceName: "no_profile_image"))
                obj.downloadData()
            }
            //cell.imageIcon.image = obj.localImageActive
        }
        else{
            cell.labelName.textColor = UIColor(named: "5")!
            //cell.viewBackground.backgroundColor = UIColor(named: "10")!
            cell.viewBackground.backgroundColor = .white
            
            if obj.localImageInActive != nil{
                cell.imageIcon.image = obj.localImageInActive
            }
            else{
                cell.imageIcon.kf.setImage(with: URL(string: kBucketUrl + obj.inActiveImage),placeholder:  #imageLiteral(resourceName: "profile_placeholder"))
                obj.downloadData()
            }
            //cell.imageIcon.image = obj.localImageInActive
        }
        
        return cell
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let res = self.exploreOptions.filter{ $0.isSelected }
        if exploreOptions[indexPath.row].isSelected {
            self.exploreOptions[indexPath.row].isSelected = false
            self.selectedPostType = ""
            //self.updateData()
            callback?(selectedPostType)
        } else if res.count > 0 {
            self.exploreOptions.map{ $0.isSelected = false }
            self.exploreOptions[indexPath.row].isSelected = true
            self.selectedPostType = exploreOptions[indexPath.row].id
            //self.updateData()
            callback?(selectedPostType)
        } else {
            self.exploreOptions[indexPath.row].isSelected = !self.exploreOptions[indexPath.row].isSelected
            self.selectedPostType = exploreOptions[indexPath.row].id
            //self.updateData()
            callback?(selectedPostType)
        }
        self.exploreCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize { return CGSize(width: 100, height: 50)
    }
    
    //func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: 100, height: 100)
    //    }
    
}
