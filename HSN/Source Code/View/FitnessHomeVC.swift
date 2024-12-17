//
//  FitnessHomeVC.swift
//  HSN
//
//  Created by Kaustubh Rastogi on 24/11/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class FitnessHomeVC: UIViewController {

    @IBOutlet weak var collectionViewProfile: UICollectionView!
    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var tableViewFitness: UITableView!
    
    
    
    
    @IBOutlet weak var buttonPublic: UIButton!
    
    @IBOutlet weak var viewDown: UIView!
    
    @IBOutlet weak var viewConnections: UIView!
    
    
   
    var callback:(()->())?
    var allFitness = [AllChallenges]()
    //var idAccepted:String = ""
    var idAccepted:Int = 0
    var identity:Int = 0
    
   
       
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllFitness(type: 1)
        self.viewConnections.isHidden = true
        
        DispatchQueue.main.async {
            //self.viewFitnessHome.applyGradient(colours: [#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.9137254902, alpha: 1)])
            self.viewTable.applyGradient(colours: [#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.9137254902, alpha: 1)])
            
            
        }
        self.tableViewFitness.delegate = self
        self.tableViewFitness.dataSource = self
        
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func buttonPublicTapped(_ sender: UIButton) {
        self.viewConnections.isHidden = false
        self.viewDown.isHidden = true
       // tableViewFitness.reloadData()
        getAllFitness(type: 2)
        
        
    }
    
    
    
    @IBAction func buttonConnectionsPublicTapped(_ sender: UIButton) {
        getAllFitness(type: 1)
        self.viewDown.isHidden = false
        self.viewConnections.isHidden = true
    }
    @IBAction func buttonBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func buttonCreateChallengeTapped(_ sender: UIButton) {
        
            guard let nextVc = self.storyboard?.instantiateViewController(identifier: ChallengeDetailsVC.getStoryboardID()) as? ChallengeDetailsVC else {return}
            self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    @IBAction func buttonYourChallengesTap(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: MyChallengesVC.getStoryboardID()) as? MyChallengesVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    func getAllFitness(type:Int){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        let url = ServiceName.allFitness
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in

            CommonUtils.showHudWithNoInteraction(show: false)

            if errorType == .requestSuccess {

                let dictResult = kSharedInstance.getDictionary(result)

                switch Int.getInt(statusCode) {
                case 200:
                    let data = kSharedInstance.getDictionary(dictResult["data"])
                    let array = kSharedInstance.getArray(withDictionary: data["data"])
                    let dicArr = kSharedInstance.getDictionaryArray(withDictionary: data["data"])
                    self.allFitness = dicArr.map({AllChallenges(data: $0)})
                    self.tableViewFitness.reloadData()
                   
                 //   let data = //kSharedInstance.getArray(dictResult["data"]).map{AllChallenges(data:kSharedInstance.getDictionary($0)) }
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
    func AcceptedApi(id:Int){
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [
            ApiParameters.kChallengesId:idAccepted,
           // ApiParameters.kChallengesId:allFitness.first?.id
        ]
        
        

        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.AcceptedChallenges,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?)  in

            CommonUtils.showHudWithNoInteraction(show: false)

            if errorType == .requestSuccess {

                let dictResult = kSharedInstance.getDictionary(result)

                switch Int.getInt(statusCode) {

                case 200:
                    //break
                   
//             guard let vc = UIStoryboard(name: Storyboards.kFitness, bundle: nil).instantiateViewController(withIdentifier: AboutChallengeDetails.getStoryboardID()) as? AboutChallengeDetails else { return }
                    
//                    vc.allFitness = self.allFitness
//                   vc.AcceptedId = self.idAccepted
//            self.navigationController?.pushViewController(vc, animated: true)
                    
                    guard let vc = UIStoryboard(name: Storyboards.kFitness, bundle: nil).instantiateViewController(withIdentifier: AboutChallengeDetails.getStoryboardID()) as? AboutChallengeDetails else { return }
                    
//                    let objId = self.allFitness[indexPath].id
//                    self.AcceptedApi(id: objId)
                   
                    vc.AcceptedId = self.identity
                   self.navigationController?.pushViewController(vc, animated: true)


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
    

extension FitnessHomeVC : UITableViewDataSource , UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFitness.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:HomeFitnessTVC .identifier, for: indexPath) as! HomeFitnessTVC
        
        let obj = allFitness[indexPath.row]
        
        cell.labelPrice.text = obj.goals
        cell.labelDate.text = obj.start_date
        cell.labelStartTime.text = obj.start_time
        cell.labelEndTime.text = obj.end_time
        cell.BodyTestName.text = obj.name
        cell.labelDescription.text = obj.description

        cell.collection.reloadData()
        
        cell.id = obj.id
        self.idAccepted = obj.id
        cell.imageBanner.downlodeImage(serviceurl: String.getString(kBucketUrl+obj.images), placeHolder: nil )
        cell.callBack = {
            
           // self.AcceptedApi()
        }
//        cell.callBackcollect = {
//            self.allFitness[indexPath.row].userdata.first?.user_profile_pic
//        }
        
       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.AcceptedApi(id: identity)
//        guard let vc = UIStoryboard(name: Storyboards.kFitness, bundle: nil).instantiateViewController(withIdentifier: AboutChallengeDetails.getStoryboardID()) as? AboutChallengeDetails else { return }
        
        let objId = self.allFitness[indexPath.row].id

        self.identity = objId
        
        //self.AcceptedApi(id: objId)
       
        //vc.AcceptedId = objId
//       self.navigationController?.pushViewController(vc, animated: true)

        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    


}


    
   

//extension FitnessHomeVC : UICollectionViewDelegate , UICollectionViewDataSource  , UICollectionViewDelegateFlowLayout{
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return allFitness.first?.userdata.count ?? 0
//
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewPicCVC", for: indexPath) as! CollectionViewPicCVC
//        let obj1 = allFitness[indexPath.row].userdata.first?.user_profile_pic ?? ""
//       // cell.imageProfilePic.downlodeImage(serviceurl: String.getString(kBucketUrl+obj1), placeHolder: nil )
//        print("--->",obj1)
//        return cell
//
//
//    }
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//
//
//            return CGSize(width: 50, height: 50)
//
//
//    }
//
//
//}
//
//
//
//
//
//
