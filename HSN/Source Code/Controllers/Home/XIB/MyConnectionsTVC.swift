//
//  MyConnectionsTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 17/09/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class MyConnectionsTVC: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var nav: UINavigationController?
    var recommendedUsers: [RecommendedUsersModel] = [] {
        didSet {
            //self.collectionView.reloadSections(IndexSet.init(integer: 0))
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(UINib(nibName: PeopleCVC.identifier, bundle: nil), forCellWithReuseIdentifier: PeopleCVC.identifier)
    }
    
    func updateCell(data: [RecommendedUsersModel], nav: UINavigationController?) {
        self.nav = nav
        self.recommendedUsers = data
    }
    
}

extension MyConnectionsTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView.numberOfRow(numberofRow: recommendedUsers.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeopleCVC.identifier, for: indexPath) as! PeopleCVC
        cell.updateCell(data: recommendedUsers[indexPath.row])
        cell.connectCallback = {
            globalApis.makeConnection(id: self.recommendedUsers[indexPath.row].id, completion: {
                self.nav?.moveToPopUp(text: "Request Sent Successfully"){
                    globalApis.getRecommendedUsers(){ users,_ in
                        self.recommendedUsers = users
                    }
                }
            })
        }
        cell.closeCallback = {
            self.recommendedUsers.remove(at: indexPath.row)
            self.collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        globalApis.getProfile(id: self.recommendedUsers[indexPath.row].id, completion: {user in
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
            vc.data = user
            vc.id = user.id
            vc.hasCameFrom = .viewProfile
            self.nav?.pushViewController(vc, animated: true)
        })
        //        let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: PeopleQuickViewVC.getStoryboardID()) as! PeopleQuickViewVC
        //        vc.modalTransitionStyle = .crossDissolve
        //        vc.modalPresentationStyle = .overFullScreen
        //        vc.data = self.recommendedUsers
        //        self.nav?.present(vc, animated: true, completion: nil)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 100
        
        let size = CGSize(width: 200, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let obj = recommendedUsers[indexPath.row]
        let prevObj = recommendedUsers.indices.contains(indexPath.row - 1) ? recommendedUsers[indexPath.row - 1] : nil
        let nextObj = recommendedUsers.indices.contains(indexPath.row + 1) ? recommendedUsers[indexPath.row + 1] : nil
        var height: CGFloat = 30
        var heightPrev: CGFloat = 30
        var heightNext: CGFloat = 30
        let padding: CGFloat = 5
        
        let textPrev = String.getString(prevObj?.full_name).capitalized
        let textNext = String.getString(nextObj?.full_name).capitalized
        height = estimateFrameForText(text: String.getString(obj.full_name).capitalized).height + padding
        heightPrev = estimateFrameForText(text: textPrev).height + padding
        heightNext = estimateFrameForText(text: textNext).height + padding
        print(height, "$$")
        if Int(height) == 26 {
            if indexPath.row % 2 == 0 && nextObj != nil && Int(heightNext) == 47 {
                height = height + 21.48046875
            }
            else if indexPath.row % 2 != 0 && prevObj != nil && Int(heightPrev) == 47{
                height = height + 21.48046875
            }
        }
        //        else if Int(height) == 47  {
        //            if indexPath.row % 2 == 0 && nextObj != nil && Int(heightNext) == 26 {
        //                nextObj?.full_name = String.getString(nextObj?.full_name) + "\n    £"
        //            }
        //            else if indexPath.row % 2 != 0 && prevObj != nil && Int(heightPrev) == 26{
        //                prevObj?.full_name = String.getString(prevObj?.full_name) + "\n    £"
        //            }
        //        }
        //        height = estimateFrameForText(text: String.getString(obj.full_name).capitalized).height + padding
        return CGSize(width: collectionView.frame.width/2.065, height: 204 + height)
        //  204 + label.frame.height
        // width that you want
        //return
    }
    
}
