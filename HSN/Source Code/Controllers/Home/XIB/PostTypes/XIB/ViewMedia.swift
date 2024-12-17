//
//  ViewMedia.swift
//  HSN
//
//  Created by Prashant Panchal on 04/01/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit
import AVKit
class ViewMedia: UIView {
    
    @IBOutlet weak var collectionViewMedia: UICollectionView!
    
    @IBOutlet weak var constraintViewMediaHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var parent:UIViewController?
    var data:HomeFeedModel = HomeFeedModel(data: [:]){
        
            didSet{
                self.pageControl.numberOfPages = data.post_pic.count
                
               
                if isShared && !(data.share_post?.post_pic.isEmpty ?? false){
                  let  postType =   getMediaType(url: String.getString(data.share_post?.post_pic.first?.picture))
                    if postType == 2{
                        constraintViewMediaHeight.constant = 84
                    }
                    else{
                        if let _ = UIApplication.topViewController() as? ViewPostVC {
                            constraintViewMediaHeight.constant = 151
                        }else{
                           constraintViewMediaHeight.constant = 300
                        }
                    }
                }
                else if !isShared && !data.post_pic.isEmpty {
                   let postType = getMediaType(url: String.getString(data.post_pic.first?.picture))
                    if postType == 2{
                        constraintViewMediaHeight.constant = 84
                    }
                    else{
                        if let _ = UIApplication.topViewController() as? ViewPostVC {
                            constraintViewMediaHeight.constant = 151
                        }else{
                            constraintViewMediaHeight.constant = 300
                        }
                    }
                }
                self.collectionViewMedia.reloadData()
               

            }
        
    }
    var isShared = false
    
    func initialSetup(data:HomeFeedModel,vc:UIViewController,isShared:Bool){
        setupCollectionView()
        self.data = data
        self.parent = vc
        self.isShared = isShared
        
       
        
        
    }
    func setupCollectionView(){
//        let alignedFlowLayout = collectionViewTags?.collectionViewLayout as? AlignedCollectionViewFlowLayout
//        alignedFlowLayout?.horizontalAlignment = .left
//        alignedFlowLayout?.verticalAlignment = .top
        
        self.collectionViewMedia.delegate = self
        self.collectionViewMedia.dataSource = self
        
        self.collectionViewMedia.register(UINib(nibName: PhotoCVC.identifier, bundle: nil), forCellWithReuseIdentifier: PhotoCVC.identifier)
        self.collectionViewMedia.register(UINib(nibName: DocumentVC.identifier, bundle: nil), forCellWithReuseIdentifier: DocumentVC.identifier)
        
       
        
    }

}
extension ViewMedia:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x/scrollView.bounds.width
        self.pageControl.currentPage = Int(x)

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if data.media != "" {return 1} //By N for Exclusive
        
            if isShared{
                var postType = 0
                if !(data.share_post?.post_pic.isEmpty ?? false){
                    postType = getMediaType(url: String.getString(data.share_post?.post_pic.first?.picture))
                    
                }


                if Int.getInt(data.share_post?.post_pic.count)<2{
                    self.pageControl.isHidden = true
                }
                else{

                    if postType != 2{
                        self.pageControl.isHidden = false
                    }
                    else{
                        self.pageControl.isHidden = false
                    }
                }
                return collectionView.numberOfRow(numberofRow: data.share_post?.post_pic.count)

            }
            else{
                var postType = 0
                if !data.post_pic.isEmpty{
                    postType = getMediaType(url: String.getString(data.post_pic.first?.picture))
                    
                }
                if Int.getInt(data.post_pic.count)<2{
                    self.pageControl.isHidden = true
                }
                else{
                    if postType != 2{
                        self.pageControl.isHidden = false
                    }
                    else{
                        self.pageControl.isHidden = false
                    }

                }
                
                return collectionView.numberOfRow(numberofRow: data.post_pic.count)
            }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            if isShared{
                let obj = data.share_post?.post_pic[indexPath.row]

                let url = kBucketUrl + String.getString(obj?.picture)

                switch getMediaType(url: url){
                case 1:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
                    cell.buttonEdit.isHidden = true
                    cell.buttonDelete.isHidden = true
                    cell.imagePlayBtn.isHidden = true
                    if let downloaded = obj?.downloadedVideoImage{
                        cell.imageMedi.image = downloaded
                        //cell.imageMedi.setupImageViewer()

                    }
                    else{
                        cell.imageMedi.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj?.picture)),placeholder: #imageLiteral(resourceName: "cover_page_placeholder"),completionHandler: { data in
                            //cell.imageMedi.setupImageViewer()
                        })


                    }
                    return cell
                case 2:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocumentVC.identifier, for: indexPath) as! DocumentVC
                    cell.labelFileName.text = String.getString(URL(string: kBucketUrl + String.getString(obj?.picture))?.lastPathComponent)
                    cell.buttonRemoveFile.isHidden = true
                    return cell
                case 3:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
                    cell.buttonEdit.isHidden = true
                    cell.buttonDelete.isHidden = true
                    cell.imagePlayBtn.isHidden = false
                    if let downloaded = obj?.downloadedVideoImage{
                        cell.imageMedi.image = downloaded
                    }
                    else{

                        let webURL = URL(string: url)!

                        //cell.imageMedi.image = obj?.downloadedVideoImage

                        AVAsset(url:webURL).generateThumbnail { [weak self] (image) in
                                       DispatchQueue.main.async {
                                           guard let image = image else { return }
                                        cell.imageMedi.image = image
                                       }
                                   }
                    }
                    return cell
                default:return UICollectionViewCell()
                }
            }
            else{
                var url = ""
                var obj : PostPicModel?
                if data.media == "" {
                    obj = data.post_pic[indexPath.row]
                    url = kBucketUrl + (obj?.picture ?? "")
                }else {
                    url =  "https://hlthera-s3.s3-ap-southeast-2.amazonaws.com/" + data.media
                }


                switch getMediaType(url: url){
                case 1:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
                    cell.imageMedi.isUserInteractionEnabled = true
                    cell.imagePlayBtn.isHidden = true
                    cell.buttonEdit.isHidden = true
                    cell.buttonDelete.isHidden = true

                    if data.media == "" {
                        if let downloaded = data.post_pic[indexPath.row].downloadedVideoImage{
                            cell.imageMedi.image = downloaded
                            cell.imageMedi.setupImageViewer()
                        }
                        else{
                            cell.imageMedi.kf.setImage(with: URL(string: url),placeholder: #imageLiteral(resourceName: "cover_page_placeholder"),completionHandler: { data in
                                cell.imageMedi.setupImageViewer()
                            })
                        }
                    }else{
                        cell.imageMedi.kf.setImage(with: URL(string: url),placeholder: #imageLiteral(resourceName: "cover_page_placeholder"),completionHandler: { data in
                            cell.imageMedi.setupImageViewer()
                        })
                    }


                    return cell
                case 2:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocumentVC.identifier, for: indexPath) as! DocumentVC
                    cell.labelFileName.text = String.getString(URL(string: kBucketUrl + (obj?.picture ?? ""))?.lastPathComponent)
                    cell.buttonRemoveFile.isHidden = true
                    //cell.imagePlayBtn.isHidden = true
                    return cell
                //cell.imageMedi.image = #imageLiteral(resourceName: "cover_page_placeholder")
                case 3:

                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
                    cell.imageMedi.isUserInteractionEnabled = false
                    cell.imagePlayBtn.isHidden = false
                    cell.buttonEdit.isHidden = true
                    cell.buttonDelete.isHidden = true

                    if let downloaded = obj?.downloadedVideoImage{
                        cell.imageMedi.image = downloaded
                    }
                    else{

                       // cell.imageMedi.image = obj.downloadedVideoImage
                        let webURL = URL(string: url)!
                        //cell.imageMedi.image = obj?.downloadedVideoImage

                        AVAsset(url:webURL).generateThumbnail { [weak self] (image) in
                                       DispatchQueue.main.async {
                                           guard let image = image else { return }
                                        cell.imageMedi.image = image
                                       }
                                   }

                    }
                    return cell
                default:return UICollectionViewCell()
                }
            }




    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //  if collectionView == collectionViewTags{
        //    return CGSize(width: self.collectionView.frame.width, height: 84)
        //        }

        if data.media != "" {
          //  let url = kBucketUrl + String.getString(data.media)
            return CGSize(width: self.collectionViewMedia.frame.width, height: self.collectionViewMedia.frame.height)
            
        }
        
        if collectionView == self.collectionViewMedia{
            if !isShared{
                let obj = data.post_pic[indexPath.row]
                let url = kBucketUrl + obj.picture
                switch getMediaType(url: url){
                case 1:
                    return CGSize(width: self.collectionViewMedia.frame.width, height: self.collectionViewMedia.frame.height)
                case 2:
                    return CGSize(width: self.collectionViewMedia.frame.width, height: self.collectionViewMedia.frame.width)
                case 3:
                    return CGSize(width: self.collectionViewMedia.frame.width, height: self.collectionViewMedia.frame.height)
                default:return CGSize(width: self.collectionViewMedia.frame.width, height: self.collectionViewMedia.frame.height)
                }
            }
            else{
                let obj = data.share_post?.post_pic[indexPath.row]
                let url = kBucketUrl + String.getString(obj?.picture)
                switch getMediaType(url: url){
                case 1:
                    return CGSize(width: self.collectionViewMedia.frame.width, height: self.collectionViewMedia.frame.height)
                case 2:
                    return CGSize(width: self.collectionViewMedia.frame.width, height: self.collectionViewMedia.frame.width)
                case 3:
                    return CGSize(width: self.collectionViewMedia.frame.width, height: self.collectionViewMedia.frame.height)
                default:return CGSize(width: self.collectionViewMedia.frame.width, height: self.collectionViewMedia.frame.height)
                }
            }
        }
        else{
            return CGSize(width: collectionView.frame.width, height: 30)
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewMedia{
            if isShared{
                let obj = data.share_post?.post_pic[indexPath.row]
                let url = kBucketUrl + String.getString(obj?.picture)
                switch self.getMediaType(url: url){
                case 2:
                    parent?.downloadPDFFile(string: url)
                case 3:
                    if !url.isEmpty{
                        let videoURL = URL(string:kBucketUrl + String.getString(obj?.picture ))
                        let player = AVPlayer(url: videoURL!)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        parent?.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                    }
                    else{
                        CommonUtils.showToast(message: "Video not uploaded")
                        return
                    }
                default:break
                }
            }
            else{
                let obj = data.post_pic[indexPath.row]
                let url = kBucketUrl + obj.picture
                switch self.getMediaType(url: url){

                case 2:
                    // saveDocument(invoiceName: String.getString(URL(string: url)?.lastPathComponent), invoiceData: url )
                    //savePdf(urlString:url, fileName:fileName)
                    parent?.downloadPDFFile(string: url)
                case 3:
                    if !url.isEmpty{
                        let videoURL = URL(string:kBucketUrl + obj.picture )
                        let player = AVPlayer(url: videoURL!)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        parent?.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                    }
                    else{
                        CommonUtils.showToast(message: "Video not uploaded")
                        return
                    }
                default:break
                }
            }
        }
    }

}

extension UIView{
    func getMediaType(url:String)->Int{
        let imageExtensions = ["png", "jpg", "gif","jpeg"]
        let documentExtensions = ["pdf","txt","rtf"]
        let url: URL? = NSURL(fileURLWithPath: url) as URL
        let pathExtention = url?.pathExtension
        if imageExtensions.contains(pathExtention!)
        {
            return 1
        }
        else if documentExtensions.contains(pathExtention!)
        {
            return 2
        }
        else
        {
            return 3
        }
    }
    func removePlayBtn(image:UIImageView){
        for view in image.subviews{
            if view.restorationIdentifier == "playBtn"{
                view.removeFromSuperview()
            }
        }
    }
    func addPlayBtn(image:UIImageView){
        let playBtn = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        playBtn.restorationIdentifier = "playBtn"
        playBtn.image = UIImage(named: "play_butoon")
        playBtn.tintColor = .white
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        image.addSubview(playBtn)
        
        
        NSLayoutConstraint.activate([playBtn.centerXAnchor.constraint(equalTo: image.centerXAnchor, constant: 0),playBtn.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: 0),playBtn.heightAnchor.constraint(equalToConstant: 50),playBtn.widthAnchor.constraint(equalToConstant: 50)])
        
    }
//    func getMediaType(url:String)->Int{
//        let imageExtensions = ["png", "jpg", "gif","jpeg"]
//        let documentExtensions = ["pdf","rtf","txt"]
//        let url: URL? = NSURL(fileURLWithPath: url) as URL
//        let pathExtention = url?.pathExtension
//        if imageExtensions.contains(pathExtention!)
//        {
//            return 1
//        }
//        else if documentExtensions.contains(pathExtention!)
//        {
//            return 2
//        }
//        else
//        {
//            return 3
//        }
//    }
//    func removePlayBtn(image:UIImageView){
//        for view in image.subviews{
//            if view.restorationIdentifier == "playBtn"{
//                view.removeFromSuperview()
//            }
//        }
//    }
//    func addPlayBtn(image:UIImageView){
//        let playBtn = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        playBtn.restorationIdentifier = "playBtn"
//        playBtn.image = UIImage(named: "play_butoon")
//        playBtn.tintColor = .white
//        playBtn.translatesAutoresizingMaskIntoConstraints = false
//        image.addSubview(playBtn)
//        NSLayoutConstraint.activate([playBtn.centerXAnchor.constraint(equalTo: image.centerXAnchor, constant: 0),playBtn.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: 0),playBtn.heightAnchor.constraint(equalToConstant: 50),playBtn.widthAnchor.constraint(equalToConstant: 50)])
//    }
}
