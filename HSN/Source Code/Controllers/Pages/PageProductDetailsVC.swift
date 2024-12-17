//
//  PageProductDetailsVC.swift
//  HSN
//
//  Created by Prashant Panchal on 03/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class PageProductDetailsVC: UIViewController {
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelIndustryType: UILabel!
    @IBOutlet weak var buttonCompany: UIButton!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonLink: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var data:PageProductModel?
    var productImages:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

        // Do any additional setup after loading the view.
    }
    
    func initialSetup(){
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        if let obj = data{
            
            self.imageLogo.downlodeImage(serviceurl: kBucketUrl + obj.profile_pic, placeHolder: UIImage(named: "dummy_cover")!)
            self.labelName.text = obj.product_name.capitalized
            self.labelDescription.text = obj.tagline
            self.labelIndustryType.text = obj.industry.capitalized
            self.buttonCompany.setTitle(obj.company_id, for: .normal)
            self.productImages = obj.product_media.components(separatedBy: ",")
            self.pageControl.numberOfPages = productImages.count
            
        }
        self.collectionViewPhotos.delegate = self
        self.collectionViewPhotos.dataSource = self
        self.collectionViewPhotos.register(UploadPhotoVideoBtnCVC.nib, forCellWithReuseIdentifier: UploadPhotoVideoBtnCVC.identifier)
        self.collectionViewPhotos.register(PhotoCVC.nib, forCellWithReuseIdentifier: PhotoCVC.identifier)
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func buttonCompanyTapped(_ sender: Any) {
        guard let url = URL(string: String.getString(data?.website_url) ) else { return }
        UIApplication.shared.open(url)
        
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
extension PageProductDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
        return CGSize(width: collectionViewPhotos.frame.width, height: collectionViewPhotos.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x/scrollView.bounds.width
        self.pageControl.currentPage = Int(x)
        
    }
    
    
    
}
