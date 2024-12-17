//
//  JBTabBarController.swift
//  JBTabBarAnimation
//
//  Created by Jithin Balan on 2/5/19.
//

import UIKit
import Foundation
import FittedSheets

public class JBTabBarController: UITabBarController,ShareImageDelegate {
   
    var obj = UIView()
    var imageView = UIImageView()
    var priviousSelectedIndex: Int = -1
    var image = ""
    var menuButton = UIButton()
    var menuButtonFrame = CGRect(x: 0, y: 0, width: 50, height: 50)
    
    public func shareImage(image: String) {
        self.imageView.downlodeImage(serviceurl: kBucketUrl+UserData.shared.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
    }
    
    public func updateNotificationIcon(status: Bool) {
        self.updateNotificationIcon(isTapped: status)
    }
    
    func setupMiddleButton() {
        self.menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.x = self.view.bounds.width / 2 - menuButtonFrame.size.width / 2
        menuButton.frame = menuButtonFrame
        
        //button.setTitle("Cam", for: .normal)
        //menuButton.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.3254901961, blue: 0.3843137255, alpha: 1)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(menuButton)
        NSLayoutConstraint.activate([menuButton.centerXAnchor.constraint(equalTo: self.tabBar.centerXAnchor),menuButton.centerYAnchor.constraint(equalTo: self.tabBarItemViews()[2].centerYAnchor,constant: 0)])
        menuButton.setImage(#imageLiteral(resourceName: "create_post"), for: .normal)
        menuButton.addTarget(self, action: #selector(self.menuBtnAction(_:)), for: UIControl.Event.touchUpInside)

        self.view.layoutIfNeeded()
    }
    
    func manageMiddleConstraint(){
        self.menuButton.isHidden = true
        self.menuButton.removeFromSuperview()
        self.setupMiddleButton()
    }
    
   // <UIButton: 0x7fa2c02143d0; frame = (202 853; 24.3333 24.3333); opaque = NO; layer = <CALayer: 0x600000085ee0>>
    @objc func menuBtnAction(_ sender: UIButton) {
        setupMiddleBtn()
    }
    
    func setupMiddleBtn(){

//        let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreatePostVC.getStoryboardID()) as! CreatePostVC
//                 self.navigationController?.pushViewController(vc, animated: true)
        
        let optionsSheetVC = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: SelectCreatePostTypeVC.getStoryboardID()) as! SelectCreatePostTypeVC
        if let vc = optionsSheetVC as? SelectCreatePostTypeVC{
            vc.nav = self.navigationController
        }
        
        let options = SheetOptions(
            pullBarHeight: 24, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: true, useInlineMode: false
        )

       let sheetController = SheetViewController(controller: optionsSheetVC, sizes: [.intrinsic], options: options)
        sheetController.allowGestureThroughOverlay = false
        sheetController.overlayColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7475818452)
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.treatPullBarAsClear = false
        sheetController.autoAdjustToKeyboard = false
        sheetController.dismissOnOverlayTap = true

        // Disable the ability to pull down to dismiss the modal
        sheetController.dismissOnPull = true
       // sheetController?.animateIn(to: self.parent?.view ?? UIView(), in: parent ?? UIViewController())
        self.navigationController?.present(sheetController, animated: false, completion: nil)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        showProfileImage(for: self.tabBarItemViews()[4], index: 4,isTapped: false)
        setupMiddleButton()
        self.tabBarItemViews()[2].isUserInteractionEnabled = false
        kSharedAppDelegate?.tabBarController = self
    }
    
    override public func viewWillAppear(_ animated : Bool){
        setupMiddleButton()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let item = self.tabBar.selectedItem {
            self.tabBar(self.tabBar, didSelect: item)
        }
        
        self.createLoungeView()
       // showProfileImage(for: self.tabBarItemViews()[4], index: 4,isTapped: true)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        kSharedAppDelegate?.viewToShow.isHidden = true
    }
    
    func createLoungeView(){
        // add view on top of window
        let window = UIApplication.shared.windows.last!
        let viewToShow = LoungeMeetingView(frame: CGRect(x: window.frame.width - 75 , y: window.frame.height -  (self.tabBar.frame.height + 85), width: 70, height: 70))
        kSharedAppDelegate?.viewToShow = viewToShow
//        viewToShow.backgroundColor =  UIColor.init(hexString: "#F5F9F7") 
        viewToShow.hideShowView()
        window.addSubview(viewToShow)
        window.bringSubviewToFront(viewToShow)
        window.bringSubviewToFront(self.tabBar)
        kSharedAppDelegate?.viewToShow.isHidden = true
    }
    
    override public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let items = self.tabBar.items, let selectedIndex = items.firstIndex(of: item), priviousSelectedIndex != selectedIndex, let customTabBar = tabBar as? JBTabBar {
            
            let tabBarItemViews = self.tabBarItemViews()
            tabBarItemViews.forEach { tabBarItemView in
                let firstIndex = tabBarItemViews.firstIndex(of: tabBarItemView)
                if selectedIndex == firstIndex {
                    showItemLabel(for: tabBarItemView, isHidden: false)
                    showProfileImage(for: tabBarItemView, index: selectedIndex,isTapped: false)
                    createRoundLayer(for: tabBarItemView)
                    customTabBar.curveAnimation(for: selectedIndex)
                  
                    UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 0.57, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                        tabBarItemView.frame = CGRect(x: tabBarItemView.frame.origin.x, y: tabBarItemView.frame.origin.y - 12.5, width: tabBarItemView.frame.width, height: tabBarItemView.frame.height)
                    }, completion: { _ in
                        
                        customTabBar.finishAnimation()
                    })
                } else if priviousSelectedIndex == firstIndex {
                    
                    removeProfileImage(tabBarItemView: tabBarItemView)
                    showItemLabel(for: tabBarItemView, isHidden: false)
                    
                    //showProfileImage(for: tabBarItemView, index: selectedIndex,isTapped: false)
                    removeBarItemCircleLayer(barItemView: tabBarItemView)
                    UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 0.57, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                        tabBarItemView.frame = CGRect(x: tabBarItemView.frame.origin.x, y: tabBarItemView.frame.origin.y + 12.5, width: tabBarItemView.frame.width, height: tabBarItemView.frame.height)
                        self.showProfileImage(for: tabBarItemView, index: self.priviousSelectedIndex,isTapped: true)
                    }, completion: nil)
                }
            }
            priviousSelectedIndex = selectedIndex
           // removeProfileImage(tabBarItemView: tabBarItemViews[selectedIndex])
        }
    }
    
    private func tabBarItemViews() -> [UIView] {
        let interactionControls = tabBar.subviews.filter { $0 is UIControl }
        return interactionControls.sorted(by: { $0.frame.minX < $1.frame.minX })
    }
    
    private func removeBarItemCircleLayer(barItemView: UIView) {
        if let circleLayer = (barItemView.layer.sublayers?.filter { $0 is CircleLayer }.first) {
            circleLayer.removeFromSuperlayer()
        }
    }
    
    private func createRoundLayer(for tabBarItemView: UIView) {
        if let itemImageView = (tabBarItemView.subviews.filter { $0 is UIImageView }.first) {
            let circle = CircleLayer()
            circle.positionValue = itemImageView.center
            tabBarItemView.layer.addSublayer(circle.createCircle())
        }
    }
    
    private func showItemLabel(for tabBarItemView: UIView, isHidden: Bool) {
        if let itemLabel = (tabBarItemView.subviews.filter{ $0 is UILabel }.first),
            itemLabel is UILabel,
            let buttonLabel = itemLabel as? UILabel {
            buttonLabel.isHidden = isHidden
        }
    }
    
    private func removeProfileImage(tabBarItemView: UIView){
        if let itemImage = (tabBarItemView.subviews.filter{ $0 is UIImageView }.first){
           for view in itemImage.subviews{
                if view.restorationIdentifier == "profile"{
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    private func removeBellIconImage(tabBarItemView: UIView){
        if let itemImage = (tabBarItemView.subviews.filter{ $0 is UIImageView }.first){
            for view in itemImage.subviews{
                if view.restorationIdentifier == "bell"{
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    private func showProfileImage(for tabBarItemView: UIView, index: Int,isTapped:Bool) {
        
        if let itemImage = (tabBarItemView.subviews.filter{ $0 is UIImageView }.first),index == 4
           {
           removeProfileImage(tabBarItemView: tabBarItemView)
            self.imageView = UIImageView(frame: CGRect(x: isTapped ? -2.5 : itemImage.frame.width/2, y: isTapped ? -2.5 : itemImage.frame.height/2, width: 30, height: 30))
            imageView.downlodeImage(serviceurl: kBucketUrl+UserData.shared.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor(named: "5")!.cgColor
            imageView.layer.cornerRadius = 15
            imageView.restorationIdentifier = "profile"
            imageView.clipsToBounds = true
            itemImage.addSubview(imageView)
        }
    }
    
    private func updateNotificationIcon(isTapped:Bool) {
        if isTapped{
            self.tabBar.items?.item(at: 3)?.image = #imageLiteral(resourceName: "notification-active")
        }
        else{
            self.tabBar.items?.item(at: 3)?.image = #imageLiteral(resourceName: "notifications")
        }
    }
    

}
public protocol ShareImageDelegate {
    func shareImage(image:String)
    func updateNotificationIcon(status:Bool)
}
