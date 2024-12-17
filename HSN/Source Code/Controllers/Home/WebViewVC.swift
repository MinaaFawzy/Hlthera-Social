//
//  WebViewVC.swift
//  HSN
//
//  Created by Prashant Panchal on 17/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var pageTitle: UILabel!
    
    // MARK: - Stored Properties
    var pageTitleString = "Terms & Conditions"
    var url = kBASEURL + "term_condition"
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()
        webView.backgroundColor = .white
        self.pageTitle.text = pageTitleString
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Failed to load web page: \(error.localizedDescription)")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - Actions
    @IBAction private func buttonBackTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
}
