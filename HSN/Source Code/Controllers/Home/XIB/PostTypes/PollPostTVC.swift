//
//  PollAnswerPostTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 27/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class PollPostTVC: UITableViewCell {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelPollQuestion: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var labelTotalVotes: UILabel!
    @IBOutlet weak var constraintFooterHeight: NSLayoutConstraint!
    @IBOutlet weak var labelTimeLeft: UILabel!
    
    var headerObj:PostHeader?
    var footerObj:PostFooter?
    var parent:UIViewController?
    var data:HomeFeedModel = HomeFeedModel(data: [:]) {
        didSet{
            
            self.tableView.reloadData()
        }
    }
    var isShared:Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCells()
        setupHeaderView()
        if !isShared{
            setupFooterView()
        }
       
        
        // Initialization code
    }
    func updateCell(data obj:HomeFeedModel,isSameProfile:Bool = false,dict:[String:Any] = [:]){
        //self.constraintTableViewHeight.constant = 50*4 + 15
        self.data = obj
        headerObj?.parent = self.parent
        headerObj?.dict = dict
        headerObj?.data = self.data
        footerObj?.parent = self.parent
        footerObj?.data = self.data
       
        if isShared{
            constraintFooterHeight.constant = 0
            viewFooter.isHidden = true
        }
        else{
            constraintFooterHeight.constant = 100
            viewFooter.isHidden = false
        }
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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

