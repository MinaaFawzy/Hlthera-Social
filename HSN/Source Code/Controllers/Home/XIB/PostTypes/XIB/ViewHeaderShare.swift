//
//  ViewHeaderShare.swift
//  HSN
//
//  Created by Prashant Panchal on 04/01/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class ViewHeaderShare: UIView {
    
    @IBOutlet weak var labelDescriptionShare: UILabel!
    @IBOutlet weak var viewHeaderShare: UIView!
    @IBOutlet weak var viewContent: UIView!
    
    var headerSharedObj:PostHeader?
    var postType:PostTypes = .text
    var rootData:HomeFeedModel = HomeFeedModel(data: [:])
    var parent:UIViewController = UIViewController()
    
    func initialSetup(vc:UIViewController,dict:[String:Any],hasCameFrom:HasCameFrom,data:HomeFeedModel?,groupData:HSNGroupModel?,postType:PostTypes){
        self.postType = postType
        self.viewHeaderShare.isHidden = false
        let viewShare = UINib(nibName: "PostHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PostHeader
        self.viewHeaderShare.addSubview(viewShare)
        viewShare.frame = self.viewHeaderShare.bounds
        self.headerSharedObj = viewShare
        headerSharedObj?.parent = vc
        headerSharedObj?.dict = dict
        headerSharedObj?.hasCameFrom = hasCameFrom
        headerSharedObj?.data = data
        self.rootData = data ?? HomeFeedModel(data: [:])
        headerSharedObj?.groupData = groupData
        self.parent = vc
        setPostType()
    }
    
    func remove(){
      
        self.viewHeaderShare.subviews.forEach{$0.removeFromSuperview()}
        
        self.headerSharedObj = nil
        self.viewHeaderShare.isHidden = true
    }

    func setPostType(){
        if let obj = rootData.share_post{
        switch postType{
        case .text:
            self.labelDescriptionShare.text = obj.description
            
        case .media:
            
        
                if obj.post_pic.isEmpty{
                    self.viewContent.isHidden = true
                    
                    
                }
                else{
                    
                    self.viewContent.isHidden = false
                    let view = UINib(nibName: "ViewMedia", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ViewMedia
                    view.initialSetup(data: self.rootData, vc: self.parent ?? UIViewController(),isShared: true)
                    view.translatesAutoresizingMaskIntoConstraints = false
                   
                    viewContent.subviews.forEach{$0.removeFromSuperview()}
                    self.viewContent.addSubview(view)
                    NSLayoutConstraint.activate([   view.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor, constant: 0),
                                                    view.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: 0),
                                                    view.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0),
                                                    view.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0)
                    ])
                    
                }
            
        case .poll:
           
                
                if obj.user_poll.isEmpty{
                    self.viewContent.isHidden = true
                    
                    
                }
                else{
                    self.viewContent.isHidden = false
                    let view = UINib(nibName: "ViewPolls", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ViewPolls
                    view.initialSetup(isShared: true, data: self.rootData, vc: self.parent ?? UIViewController())
                    view.translatesAutoresizingMaskIntoConstraints = false
                   
                    viewContent.subviews.forEach{$0.removeFromSuperview()}
                    self.viewContent.addSubview(view)
                    NSLayoutConstraint.activate([   view.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor, constant: 0),
                                                    view.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: 0),
                                                    view.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0),
                                                    view.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0)
                    ])
                    
                }
            
            
        case .findExpert:
           
                            
             
                    self.viewContent.isHidden = false
                    let view = UINib(nibName: "ViewFindExpert", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ViewFindExpert
            view.initialSetup(isShared: true, data: self.rootData, vc: self.parent ?? UIViewController())
                    view.translatesAutoresizingMaskIntoConstraints = false
                   
                    viewContent.subviews.forEach{$0.removeFromSuperview()}
                    self.viewContent.addSubview(view)
                    NSLayoutConstraint.activate([   view.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor, constant: 0),
                                                    view.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: 0),
                                                    view.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0),
                                                    view.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0)
                    ])
                    
                
            

            
        case .share:
            print("shareeeee")
     
            
        default:print("none")
        }
    }
}

}
