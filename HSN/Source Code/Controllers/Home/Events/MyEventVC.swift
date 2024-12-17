//
//  MyEventVC.swift
//  HSN
//
//  Created by Ankur on 23/05/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class MyEventVC: UIViewController {
    
    @IBOutlet weak var buttonNotifications: UIButton!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ViewSearchHeightConstraint: NSLayoutConstraint!
    
    var events:[EventListModel] = []
    var filteredData:[EventListModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: UIColor(hexString: "F5F7F9"))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MyEventsCell.identifier, bundle: nil), forCellReuseIdentifier: MyEventsCell.identifier)
        self.myEvent()
        ViewSearchHeightConstraint.constant = 0
        
        
    }
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSearch(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            ViewSearchHeightConstraint.constant = 51
            
        }
        else{
            ViewSearchHeightConstraint.constant = 0
        }
    }
      
    
    @IBAction func SearchEvent(_ sender:UITextField) {
        if sender.text?.count == 0 {
            self.filteredData = self.events
        }else{
            filteredData = events.filter({ (text) -> Bool in
                let tmp:NSString = text.event?.name as? NSString ?? ""
                let range = tmp.range(of: sender.text!, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
        }
        tableView.reloadData()
    }
    @IBAction func buttonNotifiCations(_ sender: UIButton) {
        
    }
}


extension MyEventVC:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredData.count
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: MyEventsCell.identifier, for: indexPath) as! MyEventsCell
        let obj = filteredData[indexPath.row]
        cell.imageEvent.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj.event?.event_pic)),placeholder:#imageLiteral(resourceName: "cover_page_placeholder") )
//        cell.imageEvent.cornerRadius = 8
        let startDate = obj.event?.start_date ?? ""
        if startDate != ""{
            cell.labelEventDate.text = ankur_changeDateFormate(YourDate: startDate, FormatteFrom: "yyyy/MM/dd", FormatteTo: "E, MMM d, yyyy")
        }
        cell.buttonSponsor.isHidden = obj.event?.is_promoted == 1 ? true : false
        cell.labelEventName.text = obj.event?.name
//        cell.labelEventDate.text = obj.event?.start_date
        cell.labelEventTime.text = "\(obj.event?.start_time ?? "") onwards"
        cell.labelonline.isHidden = true
        if obj.event_status == "1"{
            cell.labelonline.isHidden = false
        }
        cell.callbackEdit = {
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: EditEventVC.getStoryboardID()) as? EditEventVC else { return }
            vc.eventId = obj.event_id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.callbackSponsor = {
            guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier: CreatePromotionPostVC.getStoryboardID()) as? CreatePromotionPostVC else { return }
            kSharedAppDelegate?.promotionType = "event"
            kSharedAppDelegate?.loungeId = obj.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
                let obj = self.filteredData[indexPath.row]
                let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                    
                    globalApis.deleteEvent(id: obj.event_id, completion: {
                        self.myEvent()
                        self.tableView.reloadData()
                    })
                }
                
                    deleteAction.image = #imageLiteral(resourceName: "delete_white")
                    deleteAction.backgroundColor = .red
                
                    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])

                    return configuration
                    
                
    }

    
//    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
//       // let cell = tableView.cellForRow(at: indexPath) as! HomeSearchTVC
//       // cell.viewBG.isHidden = false
//        let mainView = tableView.subviews.filter{String(describing:Swift.type(of: $0)) == "_UITableViewCellSwipeContainerView"}
//        if !mainView.isEmpty{
//            let backgroundView = mainView[0].subviews
//            if !backgroundView.isEmpty{
//                backgroundView[0].frame = CGRect(x: 0, y: 5, width: mainView[0].frame.width, height: mainView[0].frame.height-10)
//                backgroundView[0].layoutIfNeeded()
//            }
//        }
//
//        }
    
}

extension MyEventVC {
    
    func myEvent(){
        globalApis.getAllEvents(){ data in
            self.events.removeAll()
            self.events = data
            self.filteredData = self.events
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        }
    }

}
