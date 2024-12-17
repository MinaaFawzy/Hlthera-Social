//
//  SelectCreatePostTypeVC.swift
//  HSN
//
//  Created by Prashant Panchal on 14/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class SelectCreatePostTypeVC: UIViewController {
    
    var nav: UINavigationController?
    
    @IBOutlet var btnsPostType: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //selectBtn(index: 0)
    }
    
    func selectBtn(index: Int) {
        btnsPostType.forEach{
            $0.backgroundColor = UIColor(hexString: "#DADDE3")
        }
        btnsPostType[index].backgroundColor = UIColor(hexString: "#1E3F6C")
    }
    
    @IBAction func buttonSharePostTapped(_ sender: Any) {
        //selectBtn(index: 0)
        self.dismiss(animated: true, completion: {
            let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreatePostVC.getStoryboardID()) as! CreatePostVC
            self.nav?.pushViewController(vc, animated: true)
        })
    }
    
    @IBAction func buttonHltheraLoungeTapped(_ sender: Any) {
        selectBtn(index: 1)
        self.dismiss(animated: true, completion: {
            let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: CreateLoungeVC.getStoryboardID()) as! CreateLoungeVC
            self.nav?.pushViewController(vc, animated: true)
        })
    }
    
}
