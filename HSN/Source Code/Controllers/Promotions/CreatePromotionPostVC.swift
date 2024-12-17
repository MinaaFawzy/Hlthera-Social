//
//  CreatePromotionPostVC.swift
//  HSN
//
//  Created by fluper on 05/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class CreatePromotionPostVC: UIViewController ,pageViewControllerProtocal{
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var viewsProgress: [UIView]!
    
    var selectedTab = UIViewController()
    var containerViewController: PageViewController?
    var selectedTabIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //selectScreen(index: 0)
        setStatusBar()//color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        //setupController()
       // view.translatesAutoresizingMaskIntoConstraints = false
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
        if let vc = segue.destination as? PageViewController,
           segue.identifier == "pageVC" {
            containerViewController = vc
            vc.delegate = self
           // vc.hospitalData = self.searchResult
            vc.hasCameFrom = .createPromotion
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
    
    func setupController(){
        let vc = SelectPromotionGoalVC()
        add(asChildViewController:vc , childFrame:self.containerView.frame )
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        if selectedTabIndex == 0{
            CommonUtils.showDeleteAlert(title: "Cancel Promotion", message: "Are you sure want to cancel post promotion?",btnTitle: "Yes", completion: {
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
extension CreatePromotionPostVC{
    func add(asChildViewController viewController: UIViewController, childFrame:CGRect) {
        self.selectedTab = viewController
        // Add Child View Controller
        addChild(viewController)
        // Add Child View as Subview
        self.containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = childFrame
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
        
        
    }
    
    func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
}
