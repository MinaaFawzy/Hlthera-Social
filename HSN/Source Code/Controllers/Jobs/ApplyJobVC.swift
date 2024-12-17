//
//  ApplyJobVC.swift
//  HSN
//
//  Created by Prashant Panchal on 24/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ApplyJobVC: UIViewController,pageViewControllerProtocal {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelPage: UILabel!
    @IBOutlet weak var containerView: UIView!
    var pageId = ""
    var selectedTab = UIViewController()
    var data:JobModel = JobModel(data: [:])
    var containerViewController: PageViewControllerJobs?
    var selectedTabIndex = 0 {
        didSet{
            self.labelPage.text = "Page \(selectedTabIndex+1) of 3"
            switch selectedTabIndex{
            case 0:
                progressView.progress = 0.33
                
            case 1:
                progressView.progress = 0.66
            case 2:
                progressView.progress = 0.99
            default:
                progressView.progress = 0.0
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        containerViewController?.changeViewController(index: 0,direction:.forward)
        selectedTabIndex = 0
        selectScreen(index: 0)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "pageVC" {
        //            containerViewController = segue.destination as? PageVIewController
        //           }
        if let vc = segue.destination as? PageViewControllerJobs,
           segue.identifier == "pageVC" {
            containerViewController = vc
            vc.delegate = self
           // vc.hospitalData = self.searchResult
            vc.data = data
            vc.hasCameFrom = .createJob
            vc.mydelegate = self
            vc.removeSwipeGesture()
            segue.destination.view.translatesAutoresizingMaskIntoConstraints = false
            
            //segue.destinationViewController.view.translatesAutoresizingMaskIntoConstraints = false
           
        }
        
    }
   
    func getSelectedPageIndex(with value: Int) {
        print(value)
        selectedTabIndex = value
      selectScreen(index: value)
        
    }
    func selectScreen(index:Int){
        
        selectedTabIndex = index
        
       // containerViewController?.changeViewController(index: selectedTabIndex,direction:.reverse)
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        if selectedTabIndex == 0{
            CommonUtils.showDeleteAlert(title: "Cancel Job Apply Process?", message: "Are you sure want to cancel applying for this job ?",btnTitle: "Yes", completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
        else{
            print(selectedTabIndex)
            
            selectedTabIndex = selectedTabIndex - 1
            containerViewController?.changeViewController(index: selectedTabIndex,direction:.reverse)
            selectScreen(index: selectedTabIndex)
            
        }
        
        
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
