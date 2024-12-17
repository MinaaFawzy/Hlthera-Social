//
//  EventsViewController.swift
//  HSN
//
//  Created by Mukul Dixit on 13/05/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {

    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var ViewSearchHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonCalender: UIButton!
    @IBOutlet weak var buttonNotifications: UIButton!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
   
    var selectedIndex = IndexPath(item: 0, section: 0)
    var arrFilter = ["Top","Local","This week","Sponsored","Connections","Online","follow"]
    var arrFilterData:[EventListByFilterModel] = []
    
    var filteredData:[EventListByFilterModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.register(UINib(nibName: EventsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: EventsTableViewCell.identifier)
        collectionView.register(UINib(nibName: EventTopCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: EventTopCollectionViewCell.identifier)
        setupRefreshControl()
        ViewSearchHeightConstraint.constant = 0
        self.hidesBottomBarWhenPushed = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getEventbyFilter(type: selectedIndex.row)
    }
    
    @objc func refresh(_ sender:UIRefreshControl)
     {
         getEventbyFilter(type: selectedIndex.row)
        
     }
    
    func setupRefreshControl(){

        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"5")
         refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
         refreshControl.addTarget(self,
                                  action: #selector(refresh(_:)),
                                  for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated:true)
    }
    
    
    @IBAction func buttonCalender(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: InterestedEventVC.getStoryboardID()) as? InterestedEventVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func buttonSearch(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            ViewSearchHeightConstraint.constant = 35
            
        }
        else{
            ViewSearchHeightConstraint.constant = 0
        }
    }
    
    @IBAction func SearchEvent(_ sender:UITextField) {
        if sender.text?.count == 0 {
            self.filteredData = self.arrFilterData
        }else{
            filteredData = arrFilterData.filter({ (text) -> Bool in
                let tmp:NSString = text.name as? NSString ?? ""
                let range = tmp.range(of: sender.text!, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
        }
        tableView.reloadData()
    }
    
    
    @IBAction func buttonNotifiCations(_ sender: UIButton) {
    }
    
    
    @IBAction func buttonCreateEvents(_ sender: UIButton) {
        
//        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreateEventVC.getStoryboardID()) as? CreateEventVC else { return }
////        vc.hasCameFrom = .createCompanyEvent
////        vc.companyId = self.pageId
//        self.navigationController?.pushViewController(vc, animated: true)
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreateNewEventVC.getStoryboardID()) as? CreateNewEventVC else { return }
         vc.hidesBottomBarWhenPushed = true
//        vc.hasCameFrom = .createCompanyEvent
//        vc.companyId = self.pageId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func buttonYourEvents(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: MyEventVC.getStoryboardID()) as? MyEventVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension EventsViewController:UITableViewDelegate,UITableViewDataSource{


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.identifier, for: indexPath) as! EventsTableViewCell
        let obj = filteredData[indexPath.row]
        cell.labelonline.isHidden = true
        if obj.is_online_event == 1{
            cell.labelonline.isHidden = false
        }
        cell.labelSponsored.isHidden = obj.is_promoted ? false : true
        cell.imageEvent.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj.event_pic)),placeholder:#imageLiteral(resourceName: "cover_page_placeholder") )
//        cell.imageEvent.cornerRadius = 8
        cell.labelEventName.text = obj.name
        let startDate = obj.start_date
        if startDate != ""{
            cell.labelEventDate.text = ankur_changeDateFormate(YourDate: startDate, FormatteFrom: "yyyy/MM/dd", FormatteTo: "E, MMM d, yyyy")
        }
//        let startTime = obj.start_time
//        if startTime != ""{
//            cell.labelEventTime.text = ankur_changeDateFormate(YourDate: obj.start_time, FormatteFrom: "HH:mm", FormatteTo: "h:mm a")
//
//        }


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
//        if obj.interest_type == "public"{
        if obj.is_interest == true {
            cell.imageInterested.image = UIImage(named: "filled_star")
            cell.viewInterestedButton.backgroundColor = UIColor(hexString: "4276C2")
            cell.labelInterested.textColor = .white
        }else{
            cell.imageInterested.image = UIImage(named: "hollow_star")
            cell.viewInterestedButton.backgroundColor = UIColor(hexString: "D8DFE9")
            cell.labelInterested.textColor = UIColor(hexString: "263E68")
        }
//        }
        cell.callbackInterested = {
            globalApis.eventInterest(event_id: "\(obj.id ?? 0)", is_interest: !obj.is_interest, interest_type: "public") { stat in
                if stat == "1" {
                    cell.imageInterested.image = UIImage(named: "filled_star")
                    cell.viewInterestedButton.backgroundColor = UIColor(hexString: "4276C2")
                    cell.labelInterested.textColor = .white
                }else{
                    cell.imageInterested.image = UIImage(named: "hollow_star")
                    cell.viewInterestedButton.backgroundColor = UIColor(hexString: "D8DFE9")
//                    cell.labelInterested.textColor = .label
                    cell.labelInterested.textColor = UIColor(hexString: "263E68")
                }
//                self.tableView.reloadData()
                self.getEventbyFilter(type: self.selectedIndex.row)
                
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 281
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = filteredData[indexPath.row]
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: EventDetailsVC.getStoryboardID()) as? EventDetailsVC else { return }
        vc.eventId = "\(obj.id ?? 0)"
        vc.hasCameFrom = .viewEvent
        vc.IsInterested = obj.is_interest
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
  
    }
}

extension EventsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventTopCollectionViewCell.identifier , for: indexPath)  as! EventTopCollectionViewCell
        cell.labelCategories.text = arrFilter[indexPath.item]
        cell.viewCategories.isHidden = true
//        cell.labelCategories.textColor = .lightGray
        cell.labelCategories.textColor = UIColor(hexString: "8794AA")
        if selectedIndex == indexPath {
            cell.viewCategories.isHidden = false
            cell.labelCategories.textColor = UIColor(hexString: "263E68")
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        getEventbyFilter(type: indexPath.row)
        self.collectionView.reloadData()
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let w = collectionView.frame.width / 4
//        return CGSize(width: w, height: collectionView.frame.height)
//    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let x = scrollView.contentOffset.x/scrollView.bounds.width
//        self.pageControl.currentPage = Int(x)
//
//    }

}

extension EventsViewController {
    func getEventbyFilter(type:Int){
        globalApis.getPublicEventbyFilter(filter_type: "\(type)") { data in
            self.arrFilterData.removeAll()
            self.arrFilterData = data
            self.filteredData = self.arrFilterData
            self.tableView.refreshControl?.endRefreshing()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
}


extension UIViewController {
    func ankur_changeDateFormate(YourDate:String,FormatteFrom:String,FormatteTo:String) -> String {
        var valL = YourDate
        if YourDate != "" {
            let dateFormatte = DateFormatter()
            dateFormatte.dateFormat = FormatteFrom
            let dateNeweSE = dateFormatte.date(from: valL)
            dateFormatte.dateFormat = FormatteTo
            valL = dateFormatte.string(from: dateNeweSE!)
        }
        return valL
    }
}
