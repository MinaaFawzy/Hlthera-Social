//
//  TempCallVC.swift
//  HSN
//
//  Created by Prashant Panchal on 10/02/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit
import CallKit
import PushKit

class TempCallVC: UIViewController {
    @IBOutlet weak var buttonCall:UIButton!
    let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: kAppName))
  
    override func viewDidLoad() {
        super.viewDidLoad()
        provider.setDelegate(self, queue: nil)
        let registry = PKPushRegistry(queue: nil)
               registry.delegate = self
               registry.desiredPushTypes = [PKPushType.voIP]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonBackTapped(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonRecieveCallTapped(sender:UIButton){
        print("test")
//               let update = CXCallUpdate()
//               update.remoteHandle = CXHandle(type: .generic, value: "Test Call")
//               provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
        kSharedAppDelegate?.providerDelegate.reportIncomingCall(uuid: UUID(), handle: "test",hasVideo: false, completion: {error in})
        
    }
    @IBAction func buttonSendCallTapped(sender:UIButton){
       
        
//        let controller = CXCallController()
//        let transaction = CXTransaction(action: CXStartCallAction(call: UUID(), handle: CXHandle(type: .generic, value: "Pete Za")))
//        controller.request(transaction, completion: { error in })
//
//        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 5) {
//            self.provider.reportOutgoingCall(with: controller.callObserver.calls[0].uuid, connectedAt: nil)
//        }
        kSharedAppDelegate?.callManager.startCall(handle: "test", videoEnabled: false)
        
        
        
    }
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TempCallVC:CXProviderDelegate,PKPushRegistryDelegate{
    func providerDidReset(_ provider: CXProvider) {
       }

       func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
           action.fulfill()
       }

       func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
           action.fulfill()
       }
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
           print(pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
       }

       func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
           let config = CXProviderConfiguration(localizedName: "My App")
           //config.iconTemplateImageData = UIImage(named: "logo")!.pngData()
           config.ringtoneSound = "ringtone.caf"
           config.includesCallsInRecents = false;
           config.supportsVideo = true;
           let provider = CXProvider(configuration: config)
           provider.setDelegate(self, queue: nil)
           let update = CXCallUpdate()
           update.remoteHandle = CXHandle(type: .generic, value: "Pete Za")
           update.hasVideo = true
           provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
       }
}

