//
//  ViewPolls.swift
//  HSN
//
//  Created by Prashant Panchal on 04/01/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class ViewPolls: UIView {
    @IBOutlet weak var labelPollQuestion: UILabel!
    @IBOutlet weak var tableViewPoll: UITableView!
    @IBOutlet weak var labelPollTotalVotes: UILabel!
    @IBOutlet weak var labelPollDaysLeft: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    var isShared:Bool = false
    var isInsights:Bool = false
    var data:HomeFeedModel = HomeFeedModel(data: [:])
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func initialSetup(isShared:Bool,data:HomeFeedModel,vc:UIViewController){
        self.data = data
        setupTableView()
        if !isShared{

            self.labelPollQuestion.text = data.question
            self.labelPollTotalVotes.text = data.total_poll_votes + " Total Votes"
            let totalDate = Date(unixTimestamp: Double.getDouble(data.poll_duration))
            let leftDate = Date(unixTimestamp: Double.getDouble(data.poll_duration)-Double.getDouble(data.poll_remaining_time))
            let cal = Calendar.current
            let totalDays = cal.numberOfDaysBetween(Date(), and: totalDate)
            let leftDays = cal.numberOfDaysBetween(Date(), and: leftDate)

            self.labelPollDaysLeft.text = String.getString(totalDays-leftDays) + (totalDays-leftDays <= 1 ? " day left" : " days Left")
            if data.poll_ans_id.isEmpty{
                self.tableViewHeight.constant = CGFloat(data.user_poll.count * 50)
            }
            else{
                self.tableViewHeight.constant = CGFloat(data.user_poll.count * (40))
            }

        }
        else{
            self.labelPollQuestion.text = data.share_post?.question
            self.labelPollTotalVotes.text = String.getString(data.share_post?.total_poll_votes) + " Total Votes"
            let totalDate = Date(unixTimestamp: Double.getDouble(data.share_post?.poll_duration))
            let leftDate = Date(unixTimestamp: Double.getDouble(data.share_post?.poll_duration)-Double.getDouble(data.poll_remaining_time))
            let cal = Calendar.current
            let totalDays = cal.numberOfDaysBetween(Date(), and: totalDate)
            let leftDays = cal.numberOfDaysBetween(Date(), and: leftDate)
            self.labelPollDaysLeft.text = String.getString(totalDays-leftDays) + (totalDays-leftDays <= 1 ? " day left" : " days Left")
           // if String.getString(data.share_post?.poll_ans_id).isEmpty{
//                self.constraintTableViewPollsHeight.constant = CGFloat(Int.getInt(data.share_post?.user_poll.count) * 50)
//            }
//            else{
//                self.constraintTableViewPollsHeight.constant = CGFloat(Int.getInt(data.share_post?.user_poll.count) * (40))
//            }
        }
    }
    func setupTableView(){
        tableViewPoll.delegate = self
        tableViewPoll.dataSource = self
        tableViewPoll.register(UINib(nibName: AnswerPollTVC.identifier, bundle: nil), forCellReuseIdentifier: AnswerPollTVC.identifier)
        tableViewPoll.register(UINib(nibName: ViewPollTVC.identifier, bundle: nil), forCellReuseIdentifier: ViewPollTVC.identifier)
    }

}
extension ViewPolls:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShared{
            return data.share_post?.user_poll.count ?? 0
        }
        else{
            
            return data.user_poll.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isShared{
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
        else{
            if data.poll_ans_id.isEmpty{
                let cell = tableView.dequeueReusableCell(withIdentifier: AnswerPollTVC.identifier, for: indexPath) as! AnswerPollTVC
                cell.labelOption.text = data.user_poll[indexPath.row].answer
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: ViewPollTVC.identifier, for: indexPath) as! ViewPollTVC
                cell.labelOptionName.text = data.user_poll[indexPath.row].answer.capitalized
                cell.labelTotalPercentage.text = String(format: "%.2f", Double.getDouble(data.user_poll[indexPath.row].ans_percentage)) + "%"
                if data.poll_ans_id == data.user_poll[indexPath.row].id{
                    cell.imageSelected.isHidden = false
                }
                else{
                    cell.imageSelected.isHidden = true
                }
                
                cell.progressView.progress = Float(Double.getDouble(data.user_poll[indexPath.row].ans_percentage)/100)
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isShared{
            if data.share_post?.poll_ans_id.isEmpty ?? false{
                return 50
            }
            else{
                return 40
            }
        }
        else{
            if data.poll_ans_id.isEmpty{
                return 50
            }
            else{
                return 40
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isShared{
            if data.poll_ans_id.isEmpty{
                globalApis.answerPollApi(postId: data.user_poll[indexPath.row].post_id, answerId: data.user_poll[indexPath.row].id){ total,answerdId,polls in
                    self.data.user_poll = polls
                    self.data.poll_ans_id = answerdId
                    self.tableViewPoll.reloadData()
                }
            }
            else{
                
            }
        }
        else{
            if String.getString(data.share_post?.poll_ans_id).isEmpty{
                globalApis.answerPollApi(postId: String.getString(data.share_post?.user_poll[indexPath.row].post_id), answerId: String.getString(data.share_post?.user_poll[indexPath.row].id)){ total,answerdId,polls in
                    self.data.share_post?.user_poll = polls
                    self.data.share_post?.poll_ans_id = answerdId
                    self.tableViewPoll.reloadData()
                }
            }
            else{
                
            }
        }
        
    }
    
    
    
}
