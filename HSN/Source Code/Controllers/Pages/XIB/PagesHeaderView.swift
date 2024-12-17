//
//  PagesHeaderView.swift
//  HSN
//
//  Created by user206889 on 11/24/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class PagesHeaderView: UIView {
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var imagePageIcon: UIImageView!
    @IBOutlet weak var buttonEdit: ResizableButton!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelPageName: UILabel!
    @IBOutlet weak var labelTotalFollowers: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnFollowUnfollow: ResizableButton!
    @IBOutlet weak var collectionViewNavigation:UICollectionView!
    @IBOutlet weak var labelBusinessType: UILabel!
    
    private var hasCameFrom:HasCameFrom?
    private var pageData:CompanyPageModel?
     private var parentVC:UIViewController?
    var selectedTab = 0
    private var protocal:UpdateProfilePageProtocal?
    var nav:[String] = ["Home","About","Product","Jobs","Life","People","Events"]
   
    
    
    func initialSetup(_ hasCameFrom:HasCameFrom, userData:CompanyPageModel?, parentVC:UIViewController,selectedTab:Int = 0,protocal:UpdateProfilePageProtocal?){
        
        self.pageData = userData
        self.parentVC = parentVC
        self.protocal = protocal
        self.hasCameFrom = hasCameFrom
        self.collectionViewNavigation.register(UINib(nibName: NavigationCVC.identifier, bundle: nil), forCellWithReuseIdentifier: NavigationCVC.identifier)
        self.collectionViewNavigation.delegate = self
        self.collectionViewNavigation.dataSource = self
       // setupNavigation(selectedIndex: selectedTab)
        viewHeader.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewHeader.layer.cornerRadius = 25
       updateData(data: userData)
        
        imageCover.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageCover.contentMode = UIView.ContentMode.scaleAspectFill
        imagePageIcon.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imagePageIcon.contentMode = UIView.ContentMode.scaleAspectFill
        btnFollowUnfollow.isUserInteractionEnabled = true
        self.btnFollowUnfollow.setTitle("Follow Page", for: .normal)
        switch hasCameFrom{
        case .viewPage:
            self.buttonEdit.isHidden = true
        case .viewPageAdmin:
            self.buttonEdit.isHidden = false
        default:break
        }
    }

    
    func updateData(data:CompanyPageModel?){
        if let obj = data{
            self.labelPageName.text = obj.page_name
            self.labelDescription.text = obj.description
           
                self.labelTotalFollowers.text = String.getString(obj.total_followers_count) + " Followers"
            self.labelBusinessType.text = obj.industry
            
            self.imagePageIcon.kf.setImage(with: URL(string: kBucketUrl + obj.profile_pic),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
            self.imageCover.kf.setImage(with: URL(string: kBucketUrl + obj.cover_pic),placeholder: #imageLiteral(resourceName: "cover_page_placeholder"))
            setPageFollowed(status: obj.company_page_follow_by_me)
        }
    }
    
//    func setupNavigation(selectedIndex:Int = 0){
//
//        for (index,view) in self.ViewsNavigation.enumerated(){
//            for btn in view.subviews{
//                if let button  = btn as? UIButton{
//                    button.setTitleColor(), for: .normal)
//                  //  button.titleLabel?.font = selectedIndex == index ? (UIFont(name: "SFProDisplay-Medium", size: 16)) : (UIFont(name: "SFProDisplay-Regular", size: 16))
//                    button.adjustsImageWhenDisabled = false
//                    button.adjustsImageWhenHighlighted = false
//                }
//
//                else{
//                    btn.isHidden = index == selectedIndex ? (false) : (true)
//                    btn.backgroundColor = index == selectedIndex ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1))
//
//                }
//            }
//        }
//    }
    func setPageFollowed(status:Bool){
        if status{
            self.btnFollowUnfollow.setTitle("Unfollow Page", for: .normal)
            self.btnFollowUnfollow.backgroundColor = .lightGray
            
        }else{
            self.btnFollowUnfollow.setTitle("Follow Page", for: .normal)
            self.btnFollowUnfollow.backgroundColor = UIColor(named: "5")!
        }
    }
    
    @IBAction func buttonEditTapped(_ sender: Any) {
        if hasCameFrom == .viewPageAdmin{
            
            guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: EditPageVC.getStoryboardID()) as? EditPageVC else { return }
           
            vc.data = pageData
            vc.pageId = pageData?.id ?? ""
            vc.hasCameFrom = .editPage
            self.parentVC?.navigationController?.pushViewController(vc, animated: true)

        }
        
    }
    @IBAction func buttonFollowUnfollowTapped(_ sender: Any) {
        if hasCameFrom == .viewPage || hasCameFrom == .viewPageAdmin{
           // obj?.id
            if let obj = pageData{
                globalApis.followUnfollowPageApi(pageId: obj.id, isFollowing: !obj.company_page_follow_by_me , completion: { count,status in
                    self.parentVC?.moveToPopUp(text: "Page \(status ? "followed" : "unfollowed") successfully!", completion: {
                        self.setPageFollowed(status: status)
                        obj.company_page_follow_by_me  = status
                        self.labelTotalFollowers.text = String.getString(count) + " Followers"
                            
                    })
                })
            }
          
           // globalApis.followUnfollowPageApi(pageId: data?.id ?? "", isFollowing: data., completion: <#T##(Int, Bool) -> ()#>)

        }
        else{
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
}
extension PagesHeaderView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nav.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationCVC.identifier, for: indexPath) as! NavigationCVC
        
        cell.labelName.text = nav[indexPath.row]
       // if selectedTab == indexPath.row{
            
            
       
        
    if selectedTab == indexPath.row {
        cell.viewActiveInactive.isHidden = false
        cell.viewActiveInactive.backgroundColor =   (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1))
        cell.labelName.textColor = UIColor(named: "5")!
        } else{
            cell.viewActiveInactive.isHidden = true
            cell.viewActiveInactive.backgroundColor = (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1))
            cell.labelName.textColor = UIColor(named: "New 1")!
        }
            
       //}
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedTab = indexPath.row
        protocal?.currentProfilePage(index: indexPath.row)
        self.collectionViewNavigation.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = nav[indexPath.row]
                let itemSize = item.size(withAttributes: [
                    NSAttributedString.Key.font : UIFont.SFDisplayMedium(fontSize: 16)
                ])
                //return itemSize
        
        
        return CGSize(width: itemSize.width, height: self.collectionViewNavigation.frame.height)
    }
    
    
}
