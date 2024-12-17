//
//  ViewInsightsVC.swift
//  HSN
//
//  Created by Mac02 on 07/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ViewInsightsVC: UIViewController,pageViewControllerProtocal {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet var navigationViews: [UIView]!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewHeader: UIView!
    var selectedTab = UIViewController()
    var selectedTabIndex = 0
    var containerViewController: PageViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
       // setStatusBar(color: #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1))
        
        DispatchQueue.main.async {
            self.viewHeader.setGradientBackground()
        }
        self.imageProfile.downlodeImage(serviceurl: kBucketUrl+UserData.shared.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        self.labelName.text = UserData.shared.full_name.capitalized
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        containerViewController?.changeViewController(index: 0,direction:.forward)
        selectedTabIndex = 0
        setupNavigation(selectedIndex: 0)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "pageVC" {
        //            containerViewController = segue.destination as? PageVIewController
        //           }
        if let vc = segue.destination as? PageViewController,
           segue.identifier == "insightsVC" {
            containerViewController = vc
            vc.delegate = self
           // vc.hospitalData = self.searchResult
            vc.hasCameFrom = .insights
            vc.mydelegate = self
            segue.destination.view.translatesAutoresizingMaskIntoConstraints = false
            
            //segue.destinationViewController.view.translatesAutoresizingMaskIntoConstraints = false
           
        }
        
    }
    func getSelectedPageIndex(with value: Int) {
        print(value)
      
        selectedTabIndex = value
    //  selectScreen(index: value)
        setupNavigation(selectedIndex: selectedTabIndex)
       
     
        
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonFilterTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier: FilterInsightsVC.getStoryboardID()) as? FilterInsightsVC else {return}
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
//         vc.callback = {
//
//         }
         UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true, completion: {
            
        })
    }
    @IBAction func buttonsNavigationTapped(_ sender: UIButton) {
        setupNavigation(selectedIndex: sender.tag)
        let lastIndex = selectedTabIndex
        self.selectedTabIndex = sender.tag
        
        if lastIndex > selectedTabIndex{
            containerViewController?.changeViewController(index: selectedTabIndex,direction:.reverse)
        }
        else{
            containerViewController?.changeViewController(index: selectedTabIndex,direction:.forward)
        }
        
    }
    func setupNavigation(selectedIndex:Int = 0){
   
        for (index,view) in self.navigationViews.enumerated(){
            for btn in view.subviews{
                if let button  = btn as? UIButton{
                    button.setTitleColor(selectedIndex == index ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)), for: .normal)
                  //  button.titleLabel?.font = selectedIndex == index ? (UIFont(name: "SFProDisplay-Medium", size: 16)) : (UIFont(name: "SFProDisplay-Regular", size: 16))
                    button.adjustsImageWhenDisabled = false
                    button.adjustsImageWhenHighlighted = false
                }
                
                else{
                    btn.isHidden = index == selectedIndex ? (false) : (true)
                    btn.backgroundColor = index == selectedIndex ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1))
                    
                }
            }
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
extension UIView{
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1).cgColor, #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1).cgColor]
        //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        //gradientLayer.endPoint = CGPoint(x: 1, y: 1.0)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradientLayer.frame = self.bounds
        gradientLayer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientBackgroundForCreatedCell() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1).cgColor, #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1).cgColor]
        //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        //gradientLayer.endPoint = CGPoint(x: 1, y: 1.0)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 15
        self.layer.insertSublayer(gradientLayer, at: 0)
      gradientLayer.masksToBounds = true
    }
    
    func setGradientLoungeOptionsBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
        //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        //gradientLayer.endPoint = CGPoint(x: 1, y: 1.0)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 0.95)]
        gradientLayer.frame = self.bounds
        gradientLayer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
