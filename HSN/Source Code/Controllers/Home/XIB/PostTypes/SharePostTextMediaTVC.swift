//
//  SharePostTextMediaTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 28/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import AVKit

class SharePostTextMediaTVC: UITableViewCell {
    @IBOutlet weak var viewHeaderMain: UIView!
    @IBOutlet weak var viewHeaderShared: UIView!
    @IBOutlet weak var labelDescriptionMain: UILabel!
    @IBOutlet weak var labelDescriptionShared: UILabel!
    @IBOutlet weak var collectionViewMediaShared: UICollectionView!
    @IBOutlet weak var viewFooterMain: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!

    var headerMainObj:PostHeader?
    var headerSharedObj:PostHeader?
    var footerObj:PostFooter?
    var parent:UIViewController?
    var hasCameFrom:HasCameFrom = .sharePost
    var data:HomeFeedModel = HomeFeedModel(data: [:]) {
        didSet{
            self.collectionViewMediaShared.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupHeaderView()
        setupFooterView()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.pageControl.numberOfPages = data.share_post?.post_pic.count ?? 0
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupHeaderView(){
        let view = UINib(nibName: "PostHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PostHeader
        viewHeaderMain.addSubview(view)
        view.frame = viewHeaderMain.bounds
        self.headerMainObj = view
        let view1 = UINib(nibName: "PostHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PostHeader
        viewHeaderShared.addSubview(view1)
        view.frame = viewHeaderShared.bounds
        self.headerSharedObj = view1
    }

    func setupFooterView(){
        let view = UINib(nibName: "PostFooter", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PostFooter
        viewFooterMain.addSubview(view)
        view.frame = viewFooterMain.bounds
        self.footerObj = view


    }

    func setupCollectionView(){
//        self.collectionViewMediaShared.delegate = self
//        self.collectionViewMediaShared.dataSource = self
        self.collectionViewMediaShared.register(UINib(nibName: PhotoCVC.identifier, bundle: nil), forCellWithReuseIdentifier: PhotoCVC.identifier)
        self.collectionViewMediaShared.register(UINib(nibName: DocumentVC.identifier, bundle: nil), forCellWithReuseIdentifier: DocumentVC.identifier)
    }
    func updateCell(data obj:HomeFeedModel,isSameProfile:Bool = false,dict:[String:Any] = [:]){
        self.data = obj
        headerMainObj?.parent = self.parent
        headerMainObj?.dict = dict
        headerMainObj?.data = self.data
        footerObj?.parent = self.parent
        footerObj?.data = self.data
        self.labelDescriptionMain.text = obj.description

        if obj.share_post?.post_pic.isEmpty ?? false{
            self.constraintCollectionViewHeight.constant = 0
            self.pageControl.isHidden = true
            self.collectionViewMediaShared.isHidden = true
        }
        else{
            switch Int.getInt(obj.share_post?.is_post_type){
            case 3:
                self.pageControl.isHidden  = true
                self.constraintCollectionViewHeight.constant = CGFloat(84 * Int.getInt(obj.share_post?.post_pic.count))
                self.collectionViewMediaShared.isHidden = false
            default:
                self.pageControl.isHidden = false
                self.constraintCollectionViewHeight.constant = 180
                self.collectionViewMediaShared.isHidden = false
            }
        }

    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x/scrollView.bounds.width
        self.pageControl.currentPage = Int(x)
        print(scrollView.contentOffset.x)
    }


}
extension SharePostTextMediaTVC{

//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return collectionView.numberOfRow(numberofRow: data.share_post?.post_pic.count)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let obj = data.share_post?.post_pic[indexPath.row]
//
//        let url = kBucketUrl + String.getString(obj?.picture)
//
//        switch getMediaType(url: url){
//        case 1:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
//            cell.buttonEdit.isHidden = true
//            cell.buttonDelete.isHidden = true
//            removePlayBtn(image: cell.imageMedi)
//            cell.imageMedi.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj?.picture)),placeholder: #imageLiteral(resourceName: "cover_page_placeholder"))
//            return cell
//        case 2:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocumentVC.identifier, for: indexPath) as! DocumentVC
//            cell.labelFileName.text = String.getString(URL(string: kBucketUrl + String.getString(obj?.picture))?.lastPathComponent)
//            cell.buttonRemoveFile.isHidden = true
//            return cell
//        case 3:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
//            cell.buttonEdit.isHidden = true
//            cell.buttonDelete.isHidden = true
//            removePlayBtn(image: cell.imageMedi)
//            DispatchQueue.main.async {
//               // cell.imageMedi.image = obj?.downloadedVideoImage
//                self.addPlayBtn(image: cell.imageMedi)
//                let webURL = URL(string: url)!
//                //cell.imageMedi.image = obj?.downloadedVideoImage
//
//                AVAsset(url:webURL).generateThumbnail { [weak self] (image) in
//                               DispatchQueue.main.async {
//                                   guard let image = image else { return }
//                                cell.imageMedi.image = image
//                               }
//                           }
//            }
//            return cell
//        default:return UICollectionViewCell()
//        }
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let obj = data.share_post?.post_pic[indexPath.row]
//        let url = kBucketUrl + String.getString(obj?.picture)
//        switch getMediaType(url: url){
//        case 1:
//            return CGSize(width: self.collectionViewMediaShared.frame.width, height: self.collectionViewMediaShared.frame.height)
//        case 2:
//            return CGSize(width: self.collectionViewMediaShared.frame.width, height: 84)
//        case 3:
//            return CGSize(width: self.collectionViewMediaShared.frame.width, height: self.collectionViewMediaShared.frame.height)
//        default:return CGSize(width: self.collectionViewMediaShared.frame.width, height: self.collectionViewMediaShared.frame.height)
//        }
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let obj = data.share_post?.post_pic[indexPath.row]
//        let url = kBucketUrl + String.getString(obj?.picture)
//        switch self.getMediaType(url: url){
//        case 2:
//            parent?.downloadPDFFile(string: url)
//        case 3:
//            if !url.isEmpty{
//                let videoURL = URL(string:kBucketUrl + String.getString(obj?.picture ))
//                let player = AVPlayer(url: videoURL!)
//                let playerViewController = AVPlayerViewController()
//                playerViewController.player = player
//                parent?.present(playerViewController, animated: true) {
//                    playerViewController.player!.play()
//                }
//            }
//            else{
//                CommonUtils.showToast(message: "Video not uploaded")
//                return
//            }
//        default:break
//        }
//    }

}
