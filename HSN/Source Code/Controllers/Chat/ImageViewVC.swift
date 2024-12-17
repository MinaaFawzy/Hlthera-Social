//
//  ChatViewController_Ext_Chat.swift
//  RippleApp
//
//  Created by Mohd Aslam on 30/04/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class ImageViewVC: UIViewController {
    var imageString = ""
    
    @IBOutlet var imageUrl: UIImageView!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    
    var Messageclass = [MessageClass]()
    var selectedMessage = ""
    var selectedIndex: CGFloat = 0
    var imageList = [[String: Any]]()
    var isFromPoll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if #available(iOS 13.0, *) {
//            self.isModalInPresentation = true
//        } else {
//            // Fallback on earlier versions
//        }
        
        
        imgCollectionView.register(UINib(nibName: "FullImageCell", bundle: nil), forCellWithReuseIdentifier: "FullImageCell")
        
        if isFromPoll {
            imgCollectionView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
                
                self.imgCollectionView.contentOffset = CGPoint(x: ScreenSize.SCREEN_WIDTH * self.selectedIndex, y: 0)
                self.imgCollectionView.reloadItems(at: [IndexPath(item: Int(self.selectedIndex), section: 0)])
            }
        }else {
            filterImagesFromMessageList()
        }
        self.view.layoutIfNeeded()
    }
    
    private func filterImagesFromMessageList() {
        self.Messageclass.forEach { (message) in
            let imgUrl = String.getString(message.imageurl)
            let msgId = String.getString(message.uid)
            let mediaType = String.getString(message.mediatype)
            if mediaType == "image" && !imgUrl.isEmpty{80
                
                imageList.append(["image": imgUrl, "messageId": msgId])
            }
        }
        
        for index in 0..<imageList.count {
            let msgId = String.getString(imageList[index]["messageId"])
            if msgId == selectedMessage {
                selectedIndex = CGFloat(index)
                break
            }
        }
        imgCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
            
            self.imgCollectionView.contentOffset = CGPoint(x: ScreenSize.SCREEN_WIDTH * self.selectedIndex, y: 0)
            self.imgCollectionView.reloadItems(at: [IndexPath(item: Int(self.selectedIndex), section: 0)])
        }
        
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ImageViewVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullImageCell", for: indexPath) as? FullImageCell else{return UICollectionViewCell()}
              
//        cell.imgView.sd_setImage(with: URL(string: String.getString(imageList[indexPath.item]["image"])), placeholderImage: nil, options: .highPriority) { (image, error, type, url) in
         
        cell.imgView.downlodeImage(serviceurl: String.getString(imageList[indexPath.item]["image"]), placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        
//            cell.imgView.image = image
//        }

        return cell
    }
    
}

extension ImageViewVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imgCollectionView.frame.width, height: imgCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

