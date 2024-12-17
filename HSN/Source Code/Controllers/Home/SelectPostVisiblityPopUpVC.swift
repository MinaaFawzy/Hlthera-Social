//
//  SelectPostVisiblityPopUpVC.swift
//  HSN
//
//  Created by Prashant Panchal on 06/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class SelectPostVisiblityPopUpVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet var buttonsSelection: [UIButton]!
    @IBOutlet var imagesSelection: [UIImageView]!
    @IBOutlet weak var constraintBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet var viewOptions: [UIView]!
    @IBOutlet weak var imageNoOne: UIImageView!
    @IBOutlet weak var labelNoOne: UILabel!
    
    // MARK: - Stored Properties
    var hasCameFrom: HasCameFrom = .createPost
    var callback: ((Int, String, UIImage) -> ())?
    var groupCallback: (() -> ())?
    var selected = 0
    var postTypes = [
        "Anyone",
        "Connections only",
        "Private",
        //"Group"
    ]
    var postTypeImagesSelected = [
        UIImage(named: "anyone_selected")!,
        UIImage(named: "connections_only_selected")!,
        UIImage(named: "no_one_selected")!,
//        UIImage(named: "make_group_admin")!
    ]
    var postTypeImagesDefault = [
        UIImage(named: "anyone")!,
        UIImage(named: "connections_only")!,
        UIImage(named: "no_one")!,
//        UIImage(named: "make_group_admin")!
    ]
    var postTypeImagesWhite = [
        UIImage(named: "anyone_white")!,
        UIImage(named: "connections_only_white")!,
        UIImage(named: "no_one_white")!,
//        UIImage(named: "make_group_admin")!
    ]
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let obj = viewContent.layer
        obj.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        obj.cornerRadius = 20
        switch self.hasCameFrom {
        case .lounge:
            viewOptions[2].isHidden = false
            viewOptions[3].isHidden = true
            self.labelNoOne.text = "Private"

            self.labelPageTitle.text = "Who can join your Lounge?"
        default: viewOptions[2].isHidden = false
//            viewOptions[3].isHidden = false
        }
        selectButton(buttonsSelection[selected])
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            let topPadding = window.safeAreaInsets.top
            let bottomPadding = window.safeAreaInsets.bottom
            constraintBottomHeight.constant = bottomPadding + 15
        }
    }
    
    func selectButton(_ sender: UIButton) {
        for index in 0..<imagesSelection.count-1 {
            self.buttonsSelection[index].isSelected = false
            self.imagesSelection[index].image = postTypeImagesDefault[index]
        }
        buttonsSelection[sender.tag].isSelected = true
        imagesSelection[sender.tag].image = postTypeImagesSelected[sender.tag]
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            if self.selected == 3{
                self.selected = 0
                self.callback?(self.selected,self.postTypes[self.selected],self.postTypeImagesWhite[self.selected])
            } else {
                self.callback?(self.selected,self.postTypes[self.selected],self.postTypeImagesWhite[self.selected])
            }
        })
    }
    
    @IBAction func buttonsSelectionTapped(_ sender: UIButton) {
        //  self.dismiss(animated: true, completion: { [self] in
        switch sender.tag {
        case 0:
            selected = 0
            selectButton(sender)
            //callback?(0,sender.titleLabel?.text ?? "",sender.imageView?.image ?? UIImage())
        case 1:
            selected = 1
            selectButton(sender)
            // callback?(1,sender.titleLabel?.text ?? "",sender.imageView?.image ?? UIImage())
        case 2:
            selected = 2
            selectButton(sender)
        case 3:
            selected = 3
            // selectButton(sender)
            groupCallback?()
            //  callback?(2,sender.titleLabel?.text ?? "",sender.imageView?.image ?? UIImage())
        default: break
        }
        // })
    }
    
}
