//
//  PageMediaTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 03/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class PageMediaTVC: UITableViewCell {
    @IBOutlet weak var imageMedia: UIImageView!
    @IBOutlet weak var viewMedia: UIView!
    let playerViewController = AVPlayerViewController()
    var parent:UIViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.playerViewController.view.frame = self.viewMedia.bounds
            self.viewMedia.clipsToBounds = true
            self.playerViewController.view.clipsToBounds = true
            //self.playerViewController.view.cornerRadius = 10
        }
    }
    
    func removeMyTvPlayer(){
//        self.viewMedia.willMove(toParent: nil)
        for view in self.viewMedia.subviews{
            if view.tag == 99{
                self.playerViewController.view.tag = 0
                view.removeFromSuperview()
            }
        }
        if let vc = parent as? ViewPageVC{
            for controller in vc.children as Array{
                if controller.restorationIdentifier == "mytv"{
                    controller.restorationIdentifier = ""
                    controller.removeFromParent()
                }
            }
        }
        self.imageMedia.isHidden = false
    }
    func addMyTvPlayer(){
        self.imageMedia.isHidden = true
//        DispatchQueue.main.async {
//            self.playerViewController.view.tag = 99
//            self.playerViewController.restorationIdentifier = "mytv"
//            self.viewBanner.addSubview(self.playerViewController.view)
//            self.addChild(self.playerViewController)
//            self.playerViewController.didMove(toParent: self)
//        }
       
            self.playerViewController.view.tag = 99
            self.playerViewController.restorationIdentifier = "mytv"
        self.viewMedia.addSubview(self.playerViewController.view)
        
        if let vc = self.parent as? ViewPageVC{
            vc.addChild(playerViewController)
        }
        
            
        
    }
    func getMediaType(urlString:String = "",url fileURL:URL?)->Int{
        let imageExtensions = ["png", "jpg", "gif","jpeg"]
        let documentExtensions = ["pdf","rtf","txt"]
        var url: URL?
        if urlString.isEmpty{
             url = fileURL
        }
        else{
             url = NSURL(fileURLWithPath: urlString) as URL
        }
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
    
    func playMedia(url:String,on:UIViewController){
        self.parent = on
        switch self.getMediaType(urlString:url , url: nil){
        case 1:
            
            self.removeMyTvPlayer()
            self.imageMedia.downlodeImage(serviceurl: String.getString(kBucketUrl + url), placeHolder: UIImage(named: "dummy_cover")!)
        case 3:
            self.removeMyTvPlayer()
            self.addMyTvPlayer()
            
            let videoURL = URL(string: String.getString(kBucketUrl + url))
            let player = AVPlayer(url: videoURL!)
            self.playerViewController.player = player
            self.playerViewController.player?.play()
            
        default:break
        }
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
