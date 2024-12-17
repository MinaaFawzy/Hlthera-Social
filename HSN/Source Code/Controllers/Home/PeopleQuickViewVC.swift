//
//  PeopleQuickViewVC.swift
//  HSN
//
//  Created by Prashant Panchal on 08/02/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class PeopleQuickViewVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelPageTitle: UILabel!
    
    var data:[RecommendedUsersModel]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        // Do any additional setup after loading the view.
    }
    
    func setupCollectionView(){
        let screenSize = UIScreen.main.bounds.size
        let cellScale = 0.85
        let cellWidth = floor(screenSize.width * cellScale)
        let cellHeight = floor(screenSize.height * cellScale)
        let insetX = (view.bounds.width - cellWidth)/2.0
        let insetY = (view.bounds.height - cellHeight)/2.0
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        self.collectionView.register(PeopleCardQuickViewCVC.nib, forCellWithReuseIdentifier: PeopleCardQuickViewCVC.identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
extension PeopleQuickViewVC:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeopleCardQuickViewCVC.identifier, for: indexPath) as! PeopleCardQuickViewCVC
        cell.configure(data: data[indexPath.row])
        return cell
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    
    
    
}
