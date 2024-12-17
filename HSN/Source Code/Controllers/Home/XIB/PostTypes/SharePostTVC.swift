//
//  SharePostTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 28/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class SharePostTVC: UITableViewCell {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    
    var tableViewHeight:CGFloat = 0.0
    var headerObj:PostHeader?
    var footerObj:PostFooter?
    var hasCameFrom:HasCameFrom = .sharePost
    var parent:UIViewController?
    
    var data:HomeFeedModel? {
        didSet{
           // self.constraintTableViewHeight.constant =
                 String.getString(data?.share_post?.poll_ans_id).isEmpty ? ( CGFloat(Int.getInt(data?.share_post?.user_poll.count) * 50) + 36 + 15 + 15 + 15) : (CGFloat(Int.getInt(data?.share_post?.user_poll.count) * 50) + 36 + 15 + 15 + 15)
         
                self.tableView.reloadData()
            
            
            
        }
    }
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCells()
        setupHeaderView()
        setupFooterView()
        //self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        //self.tableView.reloadData()
        
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "contentSize"{
//                if let newVal = change?[.newKey]{
//                    let newSize = newVal as! CGSize
//                    self.constraintTableViewHeight.constant = newSize.width + 15
//                }
//
//        }
//    }
    
   
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(data obj:HomeFeedModel,isSameProfile:Bool = false,dict:[String:Any] = [:],hasCameFrom:HasCameFrom = .sharePost){
        self.data = obj
        headerObj?.parent = self.parent
        headerObj?.dict = dict
        headerObj?.data = self.data
        footerObj?.parent = self.parent
        footerObj?.data = self.data
        self.labelDescription.text = obj.description
    }
    
    func setupHeaderView(){
        let view = UINib(nibName: "PostHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PostHeader
        viewHeader.addSubview(view)
        view.frame = viewHeader.bounds
        self.headerObj = view
    }
    func setupFooterView(){
        let view = UINib(nibName: "PostFooter", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PostFooter
        viewFooter.addSubview(view)
        view.frame = viewFooter.bounds
        self.footerObj = view
        
        
    }
    func setupCells(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TextMediaPostTVC.identifier, bundle: nil), forCellReuseIdentifier: TextMediaPostTVC.identifier)
        tableView.register(UINib(nibName: PollPostTVC.identifier, bundle: nil), forCellReuseIdentifier: PollPostTVC.identifier)
    }
    
}
extension SharePostTVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let obj = data?.share_post{
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
   
            let obj = data
        switch hasCameFrom == .findExpert ? (7) : (Int.getInt(obj?.share_post?.is_post_type)){
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: FindExpertTVC.identifier, for: indexPath) as! FindExpertTVC
            cell.updateCell(obj: obj ?? HomeFeedModel(data: [:]))
            return cell
            
            case 6:
               return UITableViewCell()
            case 5:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: PollPostTVC.identifier, for: indexPath) as! PollPostTVC
                cell.updateCell(data: data?.share_post ?? HomeFeedModel(data: [:]))
                cell.parent = self.parent
                cell.isShared = true
                cell.constraintFooterHeight.constant = 0
                cell.viewFooter.isHidden = true
                
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
               // cell.updateCell(data: data?.share_post ?? HomeFeedModel(data: [:]))
                cell.parent = self.parent
                cell.isShared = true
//                if obj?.post_pic.isEmpty ?? false{
//                            cell.constraintCollectionViewMediaHeight.constant = 0
//                            cell.pageControl.isHidden = true
//                        }
//                        else{
//                            cell.pageControl.isHidden = false
//                            cell.constraintCollectionViewMediaHeight.constant = 180
//                        }
//                cell.constraintFooterHeight.constant = 0
//                cell.viewFooter.isHidden = true
                    return cell
            }
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(UITableView.automaticDimension)
       
        return UITableView.automaticDimension
        
    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
////        print(cell.frame.size.height, self.tableViewHeight)
////        self.tableViewHeight += cell.frame.size.height
//        constraintTableViewHeight.constant = cell.frame.size.height
//        self.tableView.layoutIfNeeded()
//    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
            
            self.constraintTableViewHeight.constant = cell.frame.size.height
        
        //self.tableView.layoutIfNeeded()
    }
    
    
 
    
    
}
final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
