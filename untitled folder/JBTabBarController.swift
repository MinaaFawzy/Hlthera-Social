//
//  JBTabBarController.swift
//  JBTabBarAnimation
//
//  Created by Jithin Balan on 2/5/19.
//

import UIKit
import Foundation

public class JBTabBarController: UITabBarController,ShareImageDelegate {
   
    var obj = UIView()
    var imageView = UIImageView()
    var priviousSelectedIndex: Int = -1
    var image = #imageLiteral(resourceName: "profile_placeholder")
    
    
    public func shareImage(image: UIImage) {
        self.image = image
        self.imageView.image = image
        
    }
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = self.view.bounds.height - self.tabBar.frame.height
        menuButtonFrame.origin.x = self.view.bounds.width / 2 - menuButtonFrame.size.width / 2
        menuButton.frame = menuButtonFrame
        
        //button.setTitle("Cam", for: .normal)
        
        //menuButton.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.3254901961, blue: 0.3843137255, alpha: 1)
       
        self.view.addSubview(menuButton)

        menuButton.setImage(#imageLiteral(resourceName: "create_post"), for: .normal)
        menuButton.addTarget(self, action: #selector(self.menuBtnAction(_:)), for: UIControl.Event.touchUpInside)

        self.view.layoutIfNeeded()
    }
    
    @objc func menuBtnAction(_ sender: UIButton) {
        setupMiddleBtn()
    }
    func setupMiddleBtn(){
        self.selectedIndex = 2
        if let vc = self.tabBarController?.viewControllers as? {
            //vc.parent?.navigationController?.pushViewController(vc, animated: true)
        }
        

    }
   
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        showProfileImage(for: self.tabBarItemViews()[4], index: 4,isTapped: false)
        setupMiddleButton()
        self.tabBarItemViews()[2].isUserInteractionEnabled = false

    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let item = self.tabBar.selectedItem {
            self.tabBar(self.tabBar, didSelect: item)
        }
       // showProfileImage(for: self.tabBarItemViews()[4], index: 4,isTapped: true)
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
        if let itemImage = (tabBarItemView.subviews.filter{ $0 is UIImageView }.first)
           {
           
            for view in itemImage.subviews{
                if view.restorationIdentifier == "profile"{
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
            imageView.image = self.image
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.cornerRadius = 15
            imageView.restorationIdentifier = "profile"
            imageView.clipsToBounds = true
            itemImage.addSubview(imageView)
           
            
            
        }
    }
    

}
public protocol ShareImageDelegate {
    func shareImage(image:UIImage)
}
