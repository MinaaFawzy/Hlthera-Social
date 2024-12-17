//
//  SharePostPollTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 28/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class SharePostPollTVC: UITableViewCell {
    @IBOutlet weak var viewHeaderMain: UIView!
    @IBOutlet weak var viewHeaderShared: UIView!
    @IBOutlet weak var labelDescriptionMain: UILabel!
    @IBOutlet weak var labelDescriptionShared: UILabel!
    @IBOutlet weak var viewFooterMain: UIView!
    @IBOutlet weak var constraintPollHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelPollQuestion: UILabel!
    @IBOutlet weak var labelTotalVotes: UILabel!
    @IBOutlet weak var labelRemainingTime: UILabel!
    
    var headerMainObj:PostHeader?
    var headerSharedObj:PostHeader?
    var footerObj:PostFooter?
    var parent:UIViewController?
    var data:HomeFeedModel = HomeFeedModel(data: [:]) {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCells()
        setupHeaderView()
        setupFooterView()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCells(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: AnswerPollTVC.identifier, bundle: nil), forCellReuseIdentifier: AnswerPollTVC.identifier)
        tableView.register(UINib(nibName: ViewPollTVC.identifier, bundle: nil), forCellReuseIdentifier: ViewPollTVC.identifier)
    }
    func setupHeaderView(){
        let view = UINib(nibName: "PostHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PostHeader
        viewHeaderMain.addSubview(view)
        view.frame = viewHeaderMain.bounds
        self.headerMainObj = view
        
        let view2 = UINib(nibName: "PostHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PostHeader
        viewHeaderShared.addSubview(view2)
        view2.frame = viewHeaderShared.bounds
        self.headerSharedObj = view2
    }
    
    func setupFooterView(){
        let view = UINib(nibName: "PostFooter", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PostFooter
        viewFooterMain.addSubview(view)
        view.frame = viewFooterMain.bounds
        self.footerObj = view
        
        
    }
    func updateCell(data obj:HomeFeedModel,isSameProfile:Bool = false,dict:[String:Any] = [:]){
        self.data = obj
        headerMainObj?.parent = self.parent
        headerMainObj?.dict = dict
        headerMainObj?.data = self.data
        footerObj?.parent = self.parent
        footerObj?.data = self.data
        self.labelDescriptionMain.text = obj.description
        
        headerSharedObj?.parent = self.parent
        headerSharedObj?.dict = dict
        headerSharedObj?.data = self.data.share_post
        self.labelDescriptionShared.text = obj.share_post?.description
        
        self.labelPollQuestion.text = obj.share_post?.question
        self.labelTotalVotes.text = String.getString(obj.share_post?.total_poll_votes) + " total votes"
        let totalDate = Date(unixTimestamp: Double.getDouble(obj.share_post?.poll_duration))
        let leftDate = Date(unixTimestamp: Double.getDouble(obj.share_post?.poll_duration)-Double.getDouble(obj.share_post?.poll_remaining_time))
        let cal = Calendar.current
        let totalDays = cal.numberOfDaysBetween(Date(), and: totalDate)
        let leftDays = cal.numberOfDaysBetween(Date(), and: leftDate)
        
        self.labelRemainingTime.text = String.getString(totalDays-leftDays) + " days left"
        if String.getString(data.share_post?.poll_ans_id).isEmpty{
            self.constraintPollHeight.constant = CGFloat(Int.getInt(data.share_post?.user_poll.count) * 50)
        }
        else{
            self.constraintPollHeight.constant = CGFloat(Int.getInt(data.share_post?.user_poll.count) * (40))
        }
    }
}
extension SharePostPollTVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.share_post?.user_poll.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if String.getString(data.share_post?.poll_ans_id).isEmpty{
            let cell = tableView.dequeueReusableCell(withIdentifier: AnswerPollTVC.identifier, for: indexPath) as! AnswerPollTVC
            cell.labelOption.text = data.share_post?.user_poll[indexPath.row].answer
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewPollTVC.identifier, for: indexPath) as! ViewPollTVC
            cell.labelOptionName.text = data.share_post?.user_poll[indexPath.row].answer.capitalized
            cell.labelTotalPercentage.text = String(format: "%.2f", Double.getDouble(data.share_post?.user_poll[indexPath.row].ans_percentage)) + "%"
            if data.share_post?.poll_ans_id == data.share_post?.user_poll[indexPath.row].id{
                cell.imageSelected.isHidden = false
            }
            else{
                cell.imageSelected.isHidden = true
            }
            cell.progressView.progress = Float(Double.getDouble(data.share_post?.user_poll[indexPath.row].ans_percentage)/100)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if String.getString(data.share_post?.poll_ans_id).isEmpty{
            return 50
        }
        else{
            return 40
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if String.getString(data.share_post?.poll_ans_id).isEmpty{
            globalApis.answerPollApi(postId: String.getString(data.share_post?.user_poll[indexPath.row].post_id), answerId: String.getString(data.share_post?.user_poll[indexPath.row].id)){ total,answerdId,polls in
                self.data.share_post?.user_poll = polls
                self.data.share_post?.poll_ans_id = answerdId
                self.tableView.reloadData()
            }
        }
        else{
            
        }
    }
   
    
    
}
extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}
