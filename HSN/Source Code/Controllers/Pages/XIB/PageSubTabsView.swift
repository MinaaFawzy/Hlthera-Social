//
//  PageSubTabsView.swift
//  HSN
//
//  Created by Prashant Panchal on 03/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class PageSubTabsView: UIView {
    @IBOutlet weak var collectionViewNav: UICollectionView!
    
    var selectedSubTab = 0 {
        didSet{
            didChangeProtocol?.didSelectTab(on: selectedSubTab)
            self.collectionViewNav.reloadData()
        }
    }
    var didChangeProtocol:SubTabSwitchProtocol?
    var tabsData:[String] = []
    var parent:UIViewController?
    func initialSetup(parent:UIViewController){
        collectionViewNav.delegate = self
        collectionViewNav.dataSource = self
        self.parent = parent
        collectionViewNav.register(SubTabsCVC.nib, forCellWithReuseIdentifier: SubTabsCVC.identifier)
        
       
    }
    func refreshNav(data:[String] = []){
        self.tabsData = data
        self.selectedSubTab = 0
    }
    


}

extension PageSubTabsView:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubTabsCVC.identifier, for: indexPath) as! SubTabsCVC
        cell.viewBackground.cornerRadius = 13
        cell.labelName.text = tabsData[indexPath.row]
        if selectedSubTab == indexPath.row{
            cell.viewBackground.backgroundColor = UIColor(hexString: "#1E3F6C")
            cell.labelName.textColor = .white
            cell.labelName.font = UIFont.SFDisplayMedium(fontSize: 13)
            
        }
        else{
            cell.viewBackground.backgroundColor = .white
            cell.labelName.textColor = UIColor(hexString: "#C8C8CF")
            cell.labelName.font = UIFont.SFDisplayRegular(fontSize: 13)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedSubTab = indexPath.row
    }
    
    
    
}
protocol SubTabSwitchProtocol{
    func didSelectTab(on index:Int)
}
