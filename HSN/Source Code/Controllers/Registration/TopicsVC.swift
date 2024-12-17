//
//  TopicsVC.swift
//  HSN
//
//  Created by Mina Fawzy on 21/08/2023.
//  Copyright © 2023 Kartikeya. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout

class TopicsVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var interestSelectedLabel: UILabel!
    @IBOutlet weak var HealthAndWellnessSelectedLabel: UILabel!
    @IBOutlet weak var interestCollection: UICollectionView!
    @IBOutlet weak var HealthAndWellnessCollection: UICollectionView!

    var interests:[TopicsModel] = []
    var healthWellness:[InterestModel] = []
    var interestsSelected = 0
    var healthAndWellnessSelected = 0
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollections()
        getInterests()
        getHealthWellness()
    }
    
}

//MARK: - IBActions
extension TopicsVC {
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
        kSharedAppDelegate?.moveToHomeScreen()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if interests.filter({$0.isSelected}).isEmpty{
            CommonUtils.showToast(message: "Please select atleast one Interest")
            return
        }
        if healthWellness.filter({$0.isSelected}).isEmpty{
            CommonUtils.showToast(message: "Please select atleast one Interest")
            return
        }
        addInterestApi()
        addHealthWellnessApi()
    }
}

//MARK: - methods
extension TopicsVC {
    func setupCollections() {
        interestCollection.delegate = self
        interestCollection.dataSource = self
        interestCollection.register(UINib(nibName: SelectInterestCVC.identifier, bundle: nil), forCellWithReuseIdentifier: SelectInterestCVC.identifier)
        HealthAndWellnessCollection.delegate = self
        HealthAndWellnessCollection.dataSource = self
        HealthAndWellnessCollection.register(UINib(nibName: SelectInterestCVC.identifier, bundle: nil), forCellWithReuseIdentifier: SelectInterestCVC.identifier)
        if let flowLayout = interestCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 5
            flowLayout.sectionInset.left = 15
            flowLayout.sectionInset.right = 15
            flowLayout.minimumInteritemSpacing = 5
        }

        let alignedFlowLayout = AlignedCollectionViewFlowLayout(
            horizontalAlignment: .left,
            verticalAlignment: .top
        )
        interestCollection.collectionViewLayout = alignedFlowLayout
        if let flowLayout2 = HealthAndWellnessCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout2.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//            flowLayout2.estimatedItemSize = CGSize(width: 1, height: 1)
            flowLayout2.minimumLineSpacing = 5
            flowLayout2.minimumInteritemSpacing = 5
            flowLayout2.sectionInset.left = 15
            flowLayout2.sectionInset.right = 15
        }
        let alignedFlowLayout2 = AlignedCollectionViewFlowLayout(
            horizontalAlignment: .left,
            verticalAlignment: .top
        )
        HealthAndWellnessCollection.collectionViewLayout = alignedFlowLayout2
        
    }
}

//MARK: - Collection funcs
extension TopicsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var labelText = ""
        if collectionView == interestCollection {
            labelText = interests[indexPath.row].topicName
        } else {
            labelText = healthWellness[indexPath.row].name
        }
        
       let label = UILabel()
       label.text = labelText
       label.numberOfLines = 0
       label.lineBreakMode = .byWordWrapping

       let maxSize = CGSize(width: collectionView.frame.width, height: .greatestFiniteMagnitude)
       let labelSize = label.sizeThatFits(maxSize)
        
       return CGSize(width: labelSize.width + 24, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == interestCollection {
            return interests.count
        } else {
            return healthWellness.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == interestCollection {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectInterestCVC.identifier, for: indexPath) as! SelectInterestCVC
            cell.labelName.text = interests[indexPath.row].topicName
            
            if interests[indexPath.row].isSelected == true {
                cell.intrestNameVeiw.backgroundColor = UIColor(named: "cbe4fa")
//                interestsSelected += 1
//                interestSelectedLabel.text = String.getString(interestsSelected)
            }
            else{
                cell.intrestNameVeiw.backgroundColor = UIColor(hex: "f5f7f9")
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectInterestCVC.identifier, for: indexPath) as! SelectInterestCVC
            cell.labelName.text = healthWellness[indexPath.row].name
            
            if healthWellness[indexPath.row].isSelected {
                cell.intrestNameVeiw.backgroundColor = UIColor(named: "cbe4fa")
//                healthAndWellnessSelected += 1
//                HealthAndWellnessSelectedLabel.text = String.getString(healthAndWellnessSelected)
            }
            else{
                cell.intrestNameVeiw.backgroundColor = UIColor(named: "f5f7f9")
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == interestCollection {
            if interestsSelected < 5 || interests[indexPath.row].isSelected {
                interests[indexPath.row].isSelected = !interests[indexPath.row].isSelected
                if interests[indexPath.row].isSelected {
                    interestsSelected += 1
                } else {
                    interestsSelected -= 1
                }
                interestSelectedLabel.text = String.getString(interestsSelected)
                self.interestCollection.reloadData()
            }
        } else {
            if healthAndWellnessSelected < 5 || healthWellness[indexPath.row].isSelected {
                healthWellness[indexPath.row].isSelected = !healthWellness[indexPath.row].isSelected
                if healthWellness[indexPath.row].isSelected {
                    healthAndWellnessSelected += 1
                } else {
                    healthAndWellnessSelected -= 1
                }
                HealthAndWellnessSelectedLabel.text = String.getString(healthAndWellnessSelected)
                self.HealthAndWellnessCollection.reloadData()
            }
        }
    }
    
    
}

//MARK: - get intrested data
extension TopicsVC {
    func getInterests(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.getInterestsTopics,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["data"])
                    self.interests = data.map{TopicsModel(data: kSharedInstance.getDictionary($0))}
                    self.interestCollection.reloadData()
                    self.HealthAndWellnessCollection.reloadData()
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
    func getHealthWellness(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.get_health_wellness,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["data"])
                    self.healthWellness = data.map{InterestModel(data: kSharedInstance.getDictionary($0))}
                    self.HealthAndWellnessCollection.reloadData()
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
    
    func addInterestApi() {
        CommonUtils.showHudWithNoInteraction(show: true)

        var params:[String:Any] = [ApiParameters.kdob:"",
                                   ApiParameters.kGender:"",
                                   ApiParameters.interests:interests.filter{$0.isSelected}.map{$0.topicId}.joined(separator: ","),

        ]



        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.add_interest,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in

            CommonUtils.showHudWithNoInteraction(show: false)

            if errorType == .requestSuccess {

                let dictResult = kSharedInstance.getDictionary(result)

                switch Int.getInt(statusCode) {

                case 200:

                    let data = kSharedInstance.getDictionary(dictResult["user_data"])
                    UserData.shared.saveData(data: data)
//                    guard let nextvc = self.storyboard?.instantiateViewController(withIdentifier: UserImageVC.getStoryboardID()) as? UserImageVC else { return }
//                    self.navigationController?.pushViewController(nextvc, animated: true)
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
    
    func addHealthWellnessApi() {
        CommonUtils.showHudWithNoInteraction(show: true)

        let params:[String:Any] = [
            "user_id" : UserData.shared.id,
            ApiParameters.health_wellness_id: healthWellness.filter{$0.isSelected}.map{$0.id}.joined(separator: ",")
        ]



        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.add_health_wellness,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in

            CommonUtils.showHudWithNoInteraction(show: false)

            if errorType == .requestSuccess {

                let dictResult = kSharedInstance.getDictionary(result)

                switch Int.getInt(statusCode) {

                case 200:

                    let data = kSharedInstance.getDictionary(dictResult["user_data"])
                    UserData.shared.saveData(data: data)
                    guard let nextvc = self.storyboard?.instantiateViewController(withIdentifier: UserImageVC.getStoryboardID()) as? UserImageVC else { return }
                    self.navigationController?.pushViewController(nextvc, animated: true)
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

