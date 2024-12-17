//
//  CreatePageVC.swift
//  HSN
//
//  Created by user206889 on 11/16/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class CreatePageVC: UIViewController,pageViewControllerProtocal {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var viewsProgress: [UIView]!
    
    var selectedTab = UIViewController()
    var containerViewController: CreatePageConnectionsVC?
    var selectedTabIndex = 0
    
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
        if let vc = segue.destination as? CreatePageConnectionsVC,
           segue.identifier == "pageVC" {
            containerViewController = vc
            vc.delegate = self
           // vc.hospitalData = self.searchResult
            vc.hasCameFrom = .createPage
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
        self.viewsProgress.forEach{
            $0.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.9333333333, alpha: 1)
        }
        selectedTabIndex = index
        self.viewsProgress[index].backgroundColor =  #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
       // containerViewController?.changeViewController(index: selectedTabIndex,direction:.reverse)
    }
   
    @IBAction func buttonBackTapped(_ sender: Any) {
        if selectedTabIndex == 0{
            CommonUtils.showDeleteAlert(title: "Cancel Page", message: "Are you sure want to cancel creating page?",btnTitle: "Yes", completion: {
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

}
