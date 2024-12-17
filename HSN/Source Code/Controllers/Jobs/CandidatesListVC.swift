//
//  CandidatesListVC.swift
//  HSN
//
//  Created by Apple on 04/10/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class CandidatesListVC: UIViewController {
    
    @IBOutlet weak var navStackView : UIStackView!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    var companyId = ""
    var jobId = ""
    var isFavorite = false
    var candidates = [CandidateDetailsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: CandidateCell.identifier, bundle: nil), forCellReuseIdentifier: CandidateCell.identifier)
        setStatusBar()
        isFavorite ? getFavoriteData() : getData()
        navStackView.isHidden = isFavorite 
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func favoriteAction(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: CandidatesListVC.getStoryboardID()) as? CandidatesListVC else { return }
        vc.isFavorite = true
//        vc.companyId = self.data?.company_id ?? ""
//        vc.jobId = self.data?.id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func filterAction(_ sender: Any) {
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
       
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CandidatesListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CandidateCell.identifier, for: indexPath) as! CandidateCell
        cell.candidate = candidates[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: CandidateProfileVC.getStoryboardID()) as? CandidateProfileVC else { return }
        vc.userID = String.getString(self.candidates[indexPath.row].user_id)
        vc.candidate = self.candidates[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Get Candidate List
extension CandidatesListVC {
    
    func getData(){
     
        globalApis.getCandidatesList(companyId : self.companyId, jobId : self.jobId, completion: {
            data in
            self.candidates = data
            self.tableView.reloadData()
        })
    }
    
    func getFavoriteData(){
     
        globalApis.getFavoriteCandidatesList(completion: {
            data in
            self.candidates = data
            self.tableView.reloadData()
        })
    }
}
