//
//  LoungeMeetingView.swift
//  HSN
//
//  Created by Apple on 14/07/22.
//  Copyright © 2022 Nisha. All rights reserved.
//

import UIKit
import FittedSheets

class LoungeMeetingView: UIView {
    
    var contentView: UIView!
    var callbackLounge:(()->())?
    var roomId: String = ""
    var micState: Bool = false
    var speakerState: Bool = false
    var anonymousState: Bool = false
    let dict = kSharedInstance.getDictionary(kSharedUserDefaults.getLounge())
    
    var nibName: String {
        return String(describing: type(of: self))
    }
    
    //MARK:
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    //MARK: - IBAction
    @IBAction func BackToLoungeButton(_ sender: Any) {
        expandView()
    }
    
    //MARK:
    func loadViewFromNib() {
        let bundle = Bundle(for: LoungeMeetingView.self)
        contentView = UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: self).first as? UIView
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    func hideShowView(){
        
        if dict["description"] != nil {
            
            kSharedAppDelegate?.viewToShow.isHidden =  kSharedAppDelegate!.isShowLounge ? false : true
        }else{
            kSharedAppDelegate?.viewToShow.isHidden = true
        }
    }
    
    func expandView() {
        let id = roomId
        let optionsSheetVC = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: AudioRoomVC.getStoryboardID()) as! AudioRoomVC
        if let vc = optionsSheetVC as? AudioRoomVC{
            vc.roomId = id
            vc.commingFromSmalView = true
            vc.enteredLounge = true
            vc.micFromSmalView = self.micState
            vc.speakerFromSmalView = self.speakerState
            vc.anonymousState = self.anonymousState
        }
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
        sheetController.dismissOnPull = true
        
        self.isHidden = true
        UIApplication.topViewController()?.navigationController?.present(sheetController, animated: false, completion: nil)
        
    }
}
