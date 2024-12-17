//
//  HomeFitnessTVC.swift
//  HSN
//
//  Created by Kaustubh Rastogi on 25/11/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class HomeFitnessTVC: UITableViewCell  {

    @IBOutlet weak var imageBanner: UIImageView!
    
    @IBOutlet weak var BodyTestName: UILabel!
    
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var labelStartTime: UILabel!
    
    @IBOutlet weak var labelEndTime: UILabel!
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var buttonAcceptedType: UIButton!
    
    @IBOutlet weak var labelPrice: UILabel!
    var id:Int?
   // var id:String = ""
    var callBack:(()->())?
    var callBackcollect:(()->())?
    var allFitness = [AllChallenges]()
    var profilepic : String = ""
    
    @IBOutlet weak var labelDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func buttonAccepedTapped(_ sender: UIButton) {
        self.callBack?()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        collection.delegate = self
        collection.dataSource = self
        collection.reloadData()
       
       
        // Configure the view for the selected state
    }

}

extension HomeFitnessTVC : UICollectionViewDelegate , UICollectionViewDataSource  , UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allFitness.first?.userdata.count ?? 0

    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "CollectionViewPicCVC", for: indexPath) as! CollectionViewPicCVC
        let obj1 = allFitness[indexPath.row].userdata.first?.user_profile_pic ?? ""

        cell.imageProfilePic.downlodeImage(serviceurl: String.getString(kBucketUrl+obj1), placeHolder: nil )
       // print("--->",obj1)
        return cell


    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {



            return CGSize(width: 50, height: 50)


    }


}







