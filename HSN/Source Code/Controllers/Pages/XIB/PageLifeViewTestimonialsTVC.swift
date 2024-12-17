//
//  PageLifeViewTestimonialsTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 03/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class PageLifeViewTestimonialsTVC: UITableViewCell {
    @IBOutlet weak var collectionViewTestimonials: UICollectionView!
    @IBOutlet weak var labelName: UILabel!
    var data:[PageTestimonialModel] = [] {
        didSet{
            self.collectionViewTestimonials.reloadData()
        }
    }
    
    func updateData(data:[PageTestimonialModel]){
        self.data = data
        
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionViewTestimonials.delegate = self
        self.collectionViewTestimonials.dataSource = self
        self.collectionViewTestimonials.register(ViewPageTestimonialCVC.nib, forCellWithReuseIdentifier: ViewPageTestimonialCVC.identifier)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension PageLifeViewTestimonialsTVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewPageTestimonialCVC.identifier, for: indexPath) as! ViewPageTestimonialCVC
        let obj = data[indexPath.row]
        cell.labelLeaderName.text = obj.employee_name?.full_name
        cell.labelDesignation.text = obj.employee_name?.employee_type
        
        cell.labelQuote.text = obj.employee_quote
        
        cell.imageProfile.downlodeImage(serviceurl: kBucketUrl + String.getString(obj.employee_name?.profile_pic), placeHolder: UIImage(named: "profile_placeholder")!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewTestimonials.frame.width/1.05, height: self.collectionViewTestimonials.frame.height)
    }
    
    
    
    
}
