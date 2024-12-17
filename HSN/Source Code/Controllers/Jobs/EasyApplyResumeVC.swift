//
//  EasyApplyResumeVC.swift
//  HSN
//
//  Created by Prashant Panchal on 24/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
class EasyApplyResumeVC: UIViewController {
    @IBOutlet weak var labelFileName: UILabel!
    
    var url = "test"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonAddDocTapped(_ sender: Any) {
        showDocumentPicker()
    }
    func validateFields(){
        if url.isEmpty{
            CommonUtils.showToast(message: "Please select resume")
            return
        }
        applyJobData[ApiParameters.resume_doc] = url
        if let vc = self.parent{
            if let pvc = vc as? PageViewControllerJobs{
                pvc.changeViewController(index: 2, direction: .forward)
                if let parentOfPVC = pvc.parent{
                    if let ppvc = parentOfPVC as? ApplyJobVC{
                        ppvc.selectScreen(index: 2)
                    }
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
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        validateFields()
    }
    
}
extension EasyApplyResumeVC : UIDocumentPickerDelegate{
    func showDocumentPicker() {
        let types: [String] = self.returnAlldoctType()
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .pageSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func returnAlldoctType() ->[String] {
        return ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key", "public.item", "public.content", "public.audiovisual-content",  "public.audiovisual-content",  "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content"]
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let pdfUrl = urls.first else { return  }
        let _ = pdfUrl.startAccessingSecurityScopedResource()
        let data = try! Data.init(contentsOf: pdfUrl)
        print(pdfUrl,data)
        globalApis.uploadResume(fileURL: pdfUrl, completion: {
            url in
            self.url = url
            self.labelFileName.text = pdfUrl.lastPathComponent
            self.labelFileName.tag = 1
        })
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
