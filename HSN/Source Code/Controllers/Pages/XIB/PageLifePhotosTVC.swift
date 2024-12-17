//
//  PageLifePhotosTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 03/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class PageLifePhotosTVC: UITableViewCell {
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    
    var productImages:[Any] = []{
        didSet{
            self.collectionViewPhotos.reloadData()
        }
    }
    func updateData(data:[PagePhotosModel]){
        self.productImages = data.map{$0.media}
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionViewPhotos.delegate = self
        self.collectionViewPhotos.dataSource = self
        self.collectionViewPhotos.register(UploadPhotoVideoBtnCVC.nib, forCellWithReuseIdentifier: UploadPhotoVideoBtnCVC.identifier)
        self.collectionViewPhotos.register(PhotoCVC.nib, forCellWithReuseIdentifier: PhotoCVC.identifier)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension PageLifePhotosTVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier , for: indexPath)  as! PhotoCVC
        if productImages.indices.contains(indexPath.row){
            if let image = productImages[indexPath.row] as? UIImage{
                cell.imageMedi.image = image
                

            }
            else{
                cell.imageMedi.downlodeImage(serviceurl: String.getString(kBucketUrl + String.getString(productImages[indexPath.row])), placeHolder: UIImage(named: "dummy_cover")!)
            }
        }
        
        cell.buttonEdit.isHidden = true
        cell.buttonDelete.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewPhotos.frame.width/1.75, height: collectionViewPhotos.frame.height)
    }
    
    
    
    
}
