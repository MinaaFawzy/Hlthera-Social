//
//  GroupListTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 15/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import FittedSheets

class GroupListTVC: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageGroup: UIImageView!
    @IBOutlet var profileImages: [UIImageView]!
    @IBOutlet weak var labelTotalMembers: UILabel!
    @IBOutlet weak var labelTotalCount: UILabel!
    @IBOutlet weak var viewMembers: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var buttonRadio: UIButton!
    @IBOutlet weak var buttonFollow: UIButton!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var viewAdmin: UIView!
    @IBOutlet weak var alignViewConstraint: NSLayoutConstraint!
    
    var acceptCallback:(()->())?
    var rejectCallback:(()->())?
    var followUnfollowCallback:(()->())?
    var companyId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageGroup.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageGroup.contentMode = UIView.ContentMode.scaleAspectFill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonAcceptTapped(_ sender: Any) {
        acceptCallback?()
    }
    
    @IBAction func buttonRejectTapped(_ sender: Any) {
        rejectCallback?()
    }
    
    @IBAction func buttonFollowUnfollowTapped(_ sender: Any) {
        followUnfollowCallback?()
    }
    
    @IBAction func buttonAdminTapped(_ sender: Any) {
        
        guard let optionsSheetVC = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: ManageAdminAccessVC.getStoryboardID()) as? ManageAdminAccessVC else { return }
        optionsSheetVC.pageId = companyId
        
        let options = SheetOptions(
            pullBarHeight: 50, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: true, useInlineMode: false
        )

       let sheetController = SheetViewController(controller: optionsSheetVC, sizes: [.marginFromTop(100)], options: options)
        sheetController.allowGestureThroughOverlay = false
        sheetController.overlayColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7475818452)
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.treatPullBarAsClear = false
        sheetController.autoAdjustToKeyboard = false
        sheetController.dismissOnOverlayTap = true
    
        // Disable the ability to pull down to dismiss the modal
        sheetController.dismissOnPull = true
       // sheetController?.animateIn(to: self.parent?.view ?? UIView(), in: parent ?? UIViewController())

        UIApplication.topViewController()?.navigationController?.present(sheetController, animated: true)
    
    }
    
}
