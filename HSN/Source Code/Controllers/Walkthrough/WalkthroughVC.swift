//
//  WalkthroughViewController.swift
//  Hlthera
//
//  Created by Fluper on 23/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class WalkthroughVC: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var bottomJoinNow: NSLayoutConstraint!
    @IBOutlet weak var viewWalkthroughButtons: UIView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var pageControlButtons: [UIButton]!
    // MARK: - Variables
    var imagesWalthrough = [UIImage(named: "Group 115353") , UIImage(named: "Connected world-pana"), UIImage(named: "Messaging fun-pana"), UIImage(named: "tutorial_4")]
    var heading = [
        "Welcome to Hlthera!",
        "Connect with Healers",
        "Join the Community",
        "Hlthera Lounge"
    ]
    var subheading = [
        "Hlthera is a platform designed to empower your health journey.",
        "Connect with others like you across the globe and share stories, posts, and experiences.",
        "A supportive community for discussing health topics.",
        "Take a break on a digital couch of your own making! Make it your own, personal digital lounge!"
    ]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        setStatusBarBackgroundColor(UIColor(red: 245, green: 247, blue: 249))
        self.pageController.numberOfPages = self.imagesWalthrough.count
        self.pageController.isHidden = true
        self.viewWalkthroughButtons.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.viewWalkthroughButtons.layer.cornerRadius = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setStatusBarBackgroundColor(UIColor(red: 245, green: 247, blue: 249))
    }
}
//MARK: - Actions
extension WalkthroughVC {
    
    @IBAction func btnSkipTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kLoginVc) as? LoginVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        if pageController.currentPage == 3 {
            //            guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kSelectLangVc) as? SelectLangViewController else {return}
            //            self.navigationController?.pushViewController(nextVc, animated: true)
        }else{
            self.collectionView.scrollToItem(at: IndexPath(item: self.pageController.currentPage == 4 ? 4 : self.pageController.currentPage + 1, section: 0), at: .centeredHorizontally, animated: true)
            self.pageController.currentPage = +1
        }
    }
    
    @IBAction func buttonSignInTapped(_ sender: Any) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: LoginVC.getStoryboardID()) as? LoginVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
        
        
    }
    
    @IBAction func btnFitness(_ sender: UIButton) {
        
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: FitnessWalkThroughVC.getStoryboardID()) as? FitnessWalkThroughVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func buttonJoinNowTapped(_ sender: Any) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: SignUpVC.getStoryboardID()) as? SignUpVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func pageControlButtonTapped(_ sender: Any) {
        for x in 0..<pageControlButtons.count{
            if pageControlButtons[x].isTouchInside {
                pageControlButtons[x].backgroundColor = UIColor(named: "5")
                collectionView.scrollToItem(at: IndexPath(row: x, section: 0), at: .top, animated: true)
            } else {
                pageControlButtons[x].backgroundColor = UIColor(named: "1")
            }
        }
    }
}

//MARK: - Collection Functions
extension WalkthroughVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesWalthrough.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.kWalkthroughCVC, for: indexPath) as! WalkthroughCVC
        cell.lblHeading.text = self.heading[indexPath.row]
        cell.lblSubheading.text = self.subheading[indexPath.row]
        cell.imgScreen.image = imagesWalthrough[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //        if indexPath.item == 3 {
        //            self.btnNext.setTitle("Get Started", for: .normal)
        //        }else{
        //            self.btnNext.setTitle("Next", for: .normal)
        //        }
        self.pageController.currentPage = indexPath.item
        for x in 0...pageControlButtons.count - 1 {
            if x == indexPath.row {
                pageControlButtons[x].backgroundColor = UIColor(named: "5")
            } else {
                pageControlButtons[x].backgroundColor = UIColor(named: "1")
            }
        }
    }
}

//MARK:- CollectionView Cell Class
class WalkthroughCVC:UICollectionViewCell {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblSubheading: UILabel!
    @IBOutlet weak var imgScreen: UIImageView!
    
}
