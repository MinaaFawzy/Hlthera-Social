//
//  AboutChallengeDetails.swift
//  HSN
//
//  Created by Kaustubh Rastogi on 25/11/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class AboutChallengeDetails: UIViewController {
    
    @IBOutlet weak var viewAboutChallenge: UIView!
    var allFitness = [AllChallenges]()
    var allDesription:AllChallenges?
   
    
    @IBOutlet weak var labelChallengeName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var labelStartTime: UILabel!
    
    @IBOutlet weak var labelEndTime: UILabel!
    
    
    @IBOutlet weak var labelGoals: UILabel!
    
    
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var imageAboutChallenge: UIImageView!
    var AcceptedId:Int?
  //  var AcceptedId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AcceptedApi()
        DispatchQueue.main.async {
            self.viewAboutChallenge.applyGradient(colours: [#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.9137254902, alpha: 1)])
        }
    }
    
    func initialSetup(){
        self.labelChallengeName.text = self.allDesription?.name
        self.labelDate.text = self.allDesription?.start_date
        self.labelStartTime.text = self.allDesription?.start_time
        self.labelEndTime.text = self.allDesription?.end_time
        self.labelGoals.text = self.allDesription?.goals
     
        self.textDescription.text = self.allDesription?.description
        self.imageAboutChallenge.downlodeImage(serviceurl: String.getString(kBucketUrl+(self.allDesription?.images ?? "")), placeHolder: nil )
    }
    
    @IBAction func buttonBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonAcceptTap(_ sender: UIButton) {
        
        
        self.AcceptedApi()
//        guard let nextVc = self.storyboard?.instantiateViewController(identifier: ChallengePointsVC.getStoryboardID()) as? ChallengePointsVC else {return}
//        self.navigationController?.pushViewController(nextVc, animated: true)

    }
    
    func AcceptedApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [
            ApiParameters.kChallengesId:AcceptedId
        ]

        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.DescriptionChallenge,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?)  in

            CommonUtils.showHudWithNoInteraction(show: false)

            if errorType == .requestSuccess {

                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {

                case 200:
                    let data = kSharedInstance.getDictionary(dictResult["data"])
                    self.allDesription = AllChallenges(data: data)
                    self.initialSetup()
                 default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
        
}
