//
//  ViewJobVC.swift
//  HSN
//
//  Created by Prashant Panchal on 23/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ViewJobVC: UIViewController {
    @IBOutlet weak var labelJobTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var data:JobModel?
    var similarJobs:[JobModel] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    var viewJobHeader:ViewJobHeader?
    var jobId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setupTableView()
        setupRefreshControl()
        self.labelJobTitle.text = data?.job_title ?? "Job"

        self.viewJobHeader = UINib(nibName: "ViewJobHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ViewJobHeader
        self.viewJobHeader?.initialSetup(userData: data ,parentVC: self)
        if let viewJobHeaderObj = viewJobHeader{
            viewJobHeaderObj.callbackSave = {
                globalApis.favoriteUnfavoriteJob(jobId: String.getString(self.data?.id), status: !viewJobHeaderObj.buttonSave.isSelected, completion: {
                    status in
                    self.data?.is_favourite = status
                    viewJobHeaderObj.buttonSave.isSelected = status
                    self.updateSaveButton(status: status)
                })
            }
            viewJobHeaderObj.callbackApply = {
                if let obj = self.data{
                    if obj.apply_type == "0"{
                        guard let vc = UIStoryboard(name: Storyboards.kJobs, bundle: nil).instantiateViewController(withIdentifier: ApplyJobVC.getStoryboardID()) as? ApplyJobVC else { return }
                        vc.data = obj
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else{
                        if !obj.website_link.isEmpty{
                            UIApplication.shared.openURL(URL(string: obj.website_link)!)
                        }
                        else{
                            CommonUtils.showToast(message: "No link found!")
                            return
                        }
                    }
                }
            }
            viewJobHeaderObj.callbackCandidates = {
                guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: CandidatesListVC.getStoryboardID()) as? CandidatesListVC else { return }
                vc.companyId = self.data?.company_id ?? ""
                vc.jobId = self.data?.id ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func updateSaveButton(status:Bool){
        if let viewJobHeaderObj = viewJobHeader{
            if status{
                viewJobHeaderObj.buttonSave.backgroundColor = UIColor(named: "5")!
                viewJobHeaderObj.buttonSave.setTitle("Saved", for: .normal)
                viewJobHeaderObj.buttonSave.setTitleColor(.white, for: .normal)
            }
            else{
                viewJobHeaderObj.buttonSave.backgroundColor = .white
                viewJobHeaderObj.buttonSave.setTitle("Save", for: .normal)
                viewJobHeaderObj.buttonSave.setTitleColor(UIColor(named: "3")!, for: .normal)
            }
        }
        
    }
    
    func getData(){
        globalApis.getJob(id: jobId){ data in
            self.data = data
            self.labelJobTitle.text = data.job_title
            self.viewJobHeader?.updateData(data: data)
            self.updateSaveButton(status: data.is_favourite)
            self.similarJobs = data.similar_jobs
//            globalApis.getAllJobsByCompany(id: data.company_id, completion: { otherJobs in
//                self.similarJobs = otherJobs
//
//            })
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
 
    @objc func refresh(_ sender:UIRefreshControl)
     {
        getData()
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
    func setupTableView(){
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
            
        } else {
            // Fallback on earlier versions
        }
        tableView.register(UINib(nibName: ViewJobTVC.identifier, bundle: nil), forCellReuseIdentifier: ViewJobTVC.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 25;
        self.tableView.reloadData()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension ViewJobVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewJobHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return similarJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewJobTVC.identifier, for: indexPath) as! ViewJobTVC
        let obj = similarJobs[indexPath.row]
        cell.labelCompanyName.text = obj.company?.business_name
        cell.labelJobTitle.text = obj.job_title
        cell.labelLocation.text = obj.location
        cell.labelConnections.text = obj.facility
        cell.labelJobPostedDate.text = obj.posted_date
        cell.imageCompanyLogo.downlodeImage(serviceurl: String.getString(kBucketUrl + String.getString(obj.company?.profile_pic)), placeHolder: UIImage(named: "profile_placeholder"))
        let date = Date(unixTimestamp: Double.getDouble(obj.posted_date))
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        cell.labelJobPostedDate.text = formatter.localizedString(for: date, relativeTo: Date())
        cell.viewMembers.isHidden = false
        cell.buttonBookmark.isSelected = obj.is_favourite
        cell.bookmarkCallback = {
            globalApis.favoriteUnfavoriteJob(jobId: obj.id, status: !obj.is_favourite, completion: {
                status in
                obj.is_favourite = status
                cell.buttonBookmark.isSelected = status
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: Storyboards.kJobs, bundle: nil).instantiateViewController(withIdentifier: ViewJobVC.getStoryboardID()) as? ViewJobVC else { return }
        vc.jobId = self.similarJobs[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

