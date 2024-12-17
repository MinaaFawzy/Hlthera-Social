//
//  OpenMediaFileVC.swift
//  Haallo
//
//  Created by Mohd Aslam on 14/10/20.
//  Copyright © 2020 fluper. All rights reserved.
//

import UIKit
import WebKit

class OpenMediaFileVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var urlStr: String?
    var fileName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        webView.scrollView.backgroundColor = UIColor.clear
        webView.navigationDelegate = self
        let fileManager = FileManager.default
        let filePath = CommonUtils.getDocumentDirectoryPath() + "/\(String.getString(fileName))"
        if fileManager.fileExists(atPath: filePath) {
            let fileURL = URL(fileURLWithPath: filePath)
            self.webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
            
        }else {
            CommonUtils.showHudWithNoInteraction(show: true)
               CommonUtils.saveFile(url: String.getString(urlStr), fileName: String.getString(fileName)) { (path) in
                   
                   CommonUtils.showHudWithNoInteraction(show: false)
                   if path != "" {
                       DispatchQueue.main.async {
                           let fileURL = URL(fileURLWithPath: path ?? "")
                           self.webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
                       }
                  }
              }
        }
       
        
    }
    
    @IBAction func tap_BackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension OpenMediaFileVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //CommonUtils.showHudWithNoInteraction(show: false)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //CommonUtils.showHudWithNoInteraction(show: false)
    }
}
