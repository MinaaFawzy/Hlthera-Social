//
//  InterestedEventVC.swift
//  HSN
//
//  Created by Ankur on 02/06/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class InterestedEventVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var list:[InterestedEventListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: InterestedEventCell.identifier, bundle: nil), forCellReuseIdentifier: InterestedEventCell.identifier)
        getInterestedList()
    }
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated:true)
    }
}

extension InterestedEventVC:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InterestedEventCell.identifier, for: indexPath) as! InterestedEventCell
        
        let obj = list[indexPath.row]
        cell.labelonline.isHidden = true
        if obj.is_online_event == 1{
            cell.labelonline.isHidden = false
        }
        cell.imageEvent.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj.event_pic)),placeholder:#imageLiteral(resourceName: "cover_page_placeholder") )
//        cell.imageEvent.cornerRadius = 8
        cell.labelEventName.text = obj.name
        let startDate = obj.start_date
        if startDate != ""{
            cell.labelEventDate.text = ankur_changeDateFormate(YourDate: startDate, FormatteFrom: "yyyy/MM/dd", FormatteTo: "E, MMM d, yyyy")
        }


//      cell.labelEventDate.text = obj.start_date
        cell.labelEventTime.text = "\(obj.start_time) onwards"
        let location = obj.location
        if location != ""{
         cell.labelEventLocation.text = location
        }else{
            cell.labelEventLocation.text = "N/A"
        }
       
        cell.labelInterestedCount.text = "\(obj.total_event_interested_count ?? 0)"
        cell.buttonIntrested.cornerRadius = 6
        cell.buttonIntrested.clipsToBounds = true
        if obj.interest_type == "public"{
        if obj.is_interest == true {
            cell.imageInterested.image = UIImage(named: "filled_star")
//            cell.viewInterestedButton.backgroundColor = UIColor(hexString: "4276C2")
//            cell.viewInterestedButton.backgroundColor = UIColor(hexString: "CBE4FA")
            cell.viewInterestedButton.backgroundColor = UIColor(hexString: "4276C2")
            cell.labelInterested.textColor = .white
        }else{
            cell.imageInterested.image = UIImage(named: "hollow_star")
            cell.viewInterestedButton.backgroundColor = UIColor(hexString: "D8DFE9")
            cell.labelInterested.textColor = UIColor(hexString: "263E68")
//            cell.labelInterested.textColor = .label
        }
        }
        cell.callbackInterested = {
            globalApis.eventInterest(event_id: "\(obj.id ?? 0)", is_interest: !obj.is_interest, interest_type: "public") { stat in
                if stat == "1" {
                    cell.imageInterested.image = UIImage(named: "filled_star")
//                    cell.viewInterestedButton.backgroundColor = UIColor(hexString: "4276C2")
                    cell.viewInterestedButton.backgroundColor = UIColor(hexString: "CBE4FA")
                    cell.labelInterested.textColor = .white
                }else{
                    cell.imageInterested.image = UIImage(named: "hollow_star")
                    cell.viewInterestedButton.backgroundColor = UIColor(hexString: "D8DFE9")
                    cell.labelInterested.textColor = UIColor(hexString: "263E68")
//                    cell.labelInterested.textColor = .label
                }
                DispatchQueue.main.async {
                    self.getInterestedList()
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290
    }
    
}

extension InterestedEventVC {
    func getInterestedList(){
        globalApis.getEventInterestList { data in
            self.list = data
            self.tableView.refreshControl?.endRefreshing()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
