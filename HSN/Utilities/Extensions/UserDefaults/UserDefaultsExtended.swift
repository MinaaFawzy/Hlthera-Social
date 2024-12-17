//
//  UserDefaultsExtended.swift
//  OneClickWash
//
//  Copyright © 2016 Appslure. All rights reserved.
//

import Foundation

extension UserDefaults {
    func isTutorialShown() -> Bool {
        return self.bool(forKey: kIsTutorialAlreadyShown)
    }
    
    func setTutorialShownStatus(tutorialShown: Bool) {
        self.set(tutorialShown, forKey: kIsTutorialAlreadyShown)
        self.synchronize()
    }
    
    func isUserLoggedIn() -> Bool {
        return self.bool(forKey: kIsUserLoggedIn)
    }
    
    func setUserLoggedIn(userLoggedIn: Bool) {
        self.set(userLoggedIn, forKey: kIsUserLoggedIn)
        self.synchronize()
    }
    func setHealthPreferences(status: Int) {
        self.set(status, forKey: kHealthStatus)
        self.synchronize()
    }
    
    func isAppInstalled() -> Bool {
        return self.bool(forKey: kIsAppInstalled)
    }
    
    func setAppInstalled(installed: Bool) {
        self.set(installed, forKey: kIsAppInstalled)
        self.synchronize()
    }
    
    func getLoggedInUserId() -> String {
        return String.getString(self.string(forKey: kLoginUserID))
    }
    func getHealthStatus() -> Int {
        return Int(self.integer(forKey: kHealthStatus))
    }
    
    
    func setLoggedInUserId(loggedInUserId: String) {
        self.set(loggedInUserId, forKey: kLoginUserID)
        self.synchronize()
    }
//    func updateSavedSuggestions(suggestions: [SavedLocationsModel]) {
//        do {
//                        UserDefaults.standard.set(try PropertyListEncoder().encode(suggestions), forKey: kSuggestions)
//
//
//
//            self.synchronize()}
//        catch
//                {
//                    print(error.localizedDescription)
//                }
//    }
//    func setAppLocation(location: SavedLocationsModel) {
//        do {
//                        UserDefaults.standard.set(try PropertyListEncoder().encode(location), forKey: kAppLocation)
//
//
//
//            self.synchronize()}
//        catch
//                {
//                    print(error.localizedDescription)
//                }
//    }
//    func getSavedSuggestions() -> [SavedLocationsModel] {
//        var data:[SavedLocationsModel] = []
//        if let storedObject: Data = UserDefaults.standard.data(forKey: kSuggestions)
//                {
//                    do
//                    {
//                        data = try PropertyListDecoder().decode([SavedLocationsModel].self, from: storedObject)
//
//                    }
//                    catch
//                    {
//                        print(error.localizedDescription)
//                    }
//                }
//
//        return data
//    }
//    func getAppLocation() -> SavedLocationsModel {
//        if let storedObject: Data = UserDefaults.standard.data(forKey: kAppLocation)
//                {
//                    do
//                    {
//                         return try PropertyListDecoder().decode(SavedLocationsModel.self, from: storedObject)
//
//                    }
//                    catch
//                    {
//                        print(error.localizedDescription)
//                    }
//                }
//        return SavedLocationsModel()
//    }
    
    
    func setLoggedInAccessToken(loggedInAccessToken: String) {
        self.set(loggedInAccessToken, forKey: kLoggedInAccessToken)
        self.synchronize()
    }
    
    func getLoggedInAccessToken() -> String {
        return String.getString(self.string(forKey: kLoggedInAccessToken))
    }
    
    func setUserSelectedLocation(_ latitude: Double, _ longitude: Double) {
        self.set(latitude, forKey: kLatitude)
        self.set(longitude, forKey: kLongitude)
        self.synchronize()
    }
    
    
    func getSelectedLatitudeAndLongitude() -> (Double, Double) {
        return (Double.getDouble(self.double(forKey: kLatitude)), Double.getDouble(self.double(forKey: kLongitude)))
    }
    
    
    func updateUserPics(_ dict: Dictionary<String, Any>) {
        var dictUserData = getLoggedInUserDetails()
        var arrUserImages = kSharedInstance.getArray(dictUserData[kMediafiles])
        arrUserImages.append(dict)
        
        dictUserData[kMediafiles] = arrUserImages
        setLoggedInUserDetails(loggedInUserDetails: dictUserData)
    }
    
    
    func updateUserLocation(withLatitude latitude: Double, andLongitude longitude: Double) {
        var dictUserData = getLoggedInUserDetails()
        var dictLocation = kSharedInstance.getDictionary(dictUserData[kLocation])
        dictLocation[kLatitude] = latitude
        dictLocation[kLongitude] = longitude
        dictUserData[kLocation] = dictLocation
        setLoggedInUserDetails(loggedInUserDetails: dictUserData)
    }
    
    func deleteUserPic(atIndex index: Int) {
        var dictUserData = getLoggedInUserDetails()
        var arrUserImages = kSharedInstance.getArray(dictUserData[kMediafiles])
        let dictPic = kSharedInstance.getDictionary(arrUserImages[index])
        arrUserImages.remove(at: index)
        if NSNumber.getNSNumber(message: dictPic[kIsProfilePicture]).boolValue && arrUserImages.count > 0 {
            var dictProfilePic = kSharedInstance.getDictionary(arrUserImages[0])
            dictProfilePic[kIsProfilePicture] = "1"
            dictUserData[kProfilePicture] = dictProfilePic[kMedia]
            arrUserImages.remove(at: 0)
            arrUserImages.insert(dictProfilePic, at: 0)
        }
        
        dictUserData[kMediafiles] = arrUserImages
        setLoggedInUserDetails(loggedInUserDetails: dictUserData)
    }
    
    func updateUserProfilePic(toIndex newProfilePicIndex: Int) {
        var dictUserData = getLoggedInUserDetails()
        var arrUserImages = kSharedInstance.getArray(dictUserData[kMediafiles])
        
        for i in 0..<arrUserImages.count {
            var dictPic = kSharedInstance.getDictionary(arrUserImages[i])
            if i == newProfilePicIndex {
                dictPic[kIsProfilePicture] = "1"
                dictUserData[kProfilePicture] = dictPic[kMedia]
            } else {
                dictPic[kIsProfilePicture] = "0"
            }
            arrUserImages.remove(at: i)
            arrUserImages.insert(dictPic, at: i)
        }
        
        dictUserData[kMediafiles] = arrUserImages
        setLoggedInUserDetails(loggedInUserDetails: dictUserData)
    }
    
    func updateLoggedInUserData(_ dict: Dictionary<String, Any>) {
        var dictUserData = getLoggedInUserDetails()
        for (key, value) in dict {
            dictUserData[key] = value
        }
        setLoggedInUserDetails(loggedInUserDetails: dictUserData)
    }
    
    func updateEmailVerifiedStatus() {
        var dictUserData = getLoggedInUserDetails()
        dictUserData[kIsEmailVerified] = NSNumber(value: true)
        setLoggedInUserDetails(loggedInUserDetails: dictUserData)
    }
    
    func getLoggedInUserDetails() -> Dictionary<String, Any> {
        guard let dataUser = self.object(forKey: kLoggedInUserDetails) else {
            return ["":""]
        }
        
        guard let userData = dataUser as? Data else {
            return ["":""]
        }
        
        let unarchiver = NSKeyedUnarchiver(forReadingWith: userData)
        guard let userLoggedInDetails = unarchiver.decodeObject(forKey: kLoggedInUserDetails) as? Dictionary <String, Any> else {
            unarchiver.finishDecoding()
            return ["":""]
        }
        unarchiver.finishDecoding()
        return userLoggedInDetails
    }
    
    func getSavedPassword() -> Dictionary<String, Any> {
        guard let dataUser = self.object(forKey: "savedPassword") else {
            return [:]
        }
        
        guard let userData = dataUser as? Data else {
            return [:]
        }
        
        let unarchiver = NSKeyedUnarchiver(forReadingWith: userData)
        guard let userLoggedInDetails = unarchiver.decodeObject(forKey: "savedPassword") as? Dictionary <String, Any> else {
            unarchiver.finishDecoding()
            return [:]
        }
        unarchiver.finishDecoding()
        return userLoggedInDetails
    }
    
    func updateSavedSuggestions(suggestions: [AllUserModel]) {
        do {
            UserDefaults.standard.set(try PropertyListEncoder().encode(suggestions), forKey: kSuggestions)
            self.synchronize()
        }
        catch { print(error.localizedDescription) }
    }

    func getSavedSuggestions() -> [AllUserModel] {
        var data:[AllUserModel] = []
        if let storedObject: Data = UserDefaults.standard.data(forKey: kSuggestions)
                {
                    do
                    {
                        data = try PropertyListDecoder().decode([AllUserModel].self, from: storedObject)
                        
                    }
                    catch
                    {
                        print(error.localizedDescription)
                    }
                }
        
        return data
    }
    
    func setLoginWithFaceId(enable: Bool) {
       self.set(enable, forKey: "kIsFaceIdEnable")
       self.synchronize()
    }
   
    func isFaceIdEnable() -> Bool {
       return self.bool(forKey: "kIsFaceIdEnable")
    }
    
    func setLoggedInUserDetails(loggedInUserDetails: Dictionary<String, Any>) {
        if loggedInUserDetails.isEmpty {
            self.set(nil, forKey: kLoggedInUserDetails)
            self.synchronize()
            return
        }
        
        let userData = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: userData)
        archiver.encode(loggedInUserDetails, forKey: kLoggedInUserDetails)
        archiver.finishEncoding()
        self.set(userData, forKey: kLoggedInUserDetails)
        self.synchronize()
    }
    
    func setPasswordDetails(data: Dictionary<String, Any>) {
        if data.isEmpty {
            self.set(nil, forKey: "savedPassword")
            self.synchronize()
            return
        }
        
        let userData = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: userData)
        archiver.encode(data, forKey: "savedPassword")
        archiver.finishEncoding()
        self.set(userData, forKey: "savedPassword")
        self.synchronize()
    }
    
    func setDeviceToken(deviceToken: String) {
        self.set(deviceToken, forKey: kDeviceToken)
        self.synchronize()
    }
    
    func getDeviceToken() -> String {
        return String.getString(self.string(forKey: kDeviceToken))
    }
    
    func setPostDraft(postDraft: String) {
        self.set(postDraft, forKey: kPostDraft)
        self.synchronize()
    }
    
    func getPostDraft() -> String {
        return String.getString(self.string(forKey: kPostDraft))
    }
    
    func setLounge(lounge: [String : Any]) {
        self.set(lounge, forKey: kLounge)
        self.synchronize()
    }
    
    func getLounge() -> [String : Any] {
        return kSharedInstance.getDictionary(self.object(forKey: kLounge))
    }
    
    func setExclusiveActive(isActive: Bool) {
        self.set(isActive, forKey: kExclusiveActive)
        self.synchronize()
    }
    
    func getExclusiveActive() -> Bool {
        return self.bool(forKey: kExclusiveActive)
    }
    
    
    
    //For audio/video call
//    func setChennalName(chennalName: String)
//    {
//        self.set(chennalName, forKey:CallIdentifiers.kChannelName)
//        self.synchronize()
//    }
//    
//    func getChennalName() -> String
//    {
//        return String.getString(self.string(forKey: CallIdentifiers.kChannelName))
//    }
//    
//    func setCallerId(name: String) {
//        self.set(name, forKey:CallIdentifiers.kCallerId)
//        self.synchronize()
//    }
//    
//    func getCallerId() -> String {
//        return String.getString(self.string(forKey:CallIdentifiers.kCallerId))
//    }
//    
//    func setAppointmentId(name: String) {
//        self.set(name, forKey:CallIdentifiers.bookingID)
//        self.synchronize()
//    }
//    
//    func getAppointmentId() -> String {
//        return String.getString(self.string(forKey:CallIdentifiers.bookingID))
//    }
//    
//    func setCallId(name: String) {
//        self.set(name, forKey:CallIdentifiers.kCallId)
//        self.synchronize()
//    }
//    
//    func getCallId() -> String {
//        return String.getString(self.string(forKey:CallIdentifiers.kCallId))
//    }
//    
//    func setCallerName(name: String)
//    {
//        self.set(name, forKey:CallIdentifiers.kCallerName)
//        self.synchronize()
//    }
//    
//    func getCallerName() -> String
//    {
//        return String.getString(self.string(forKey: CallIdentifiers.kCallerName))
//    }
//    
//    func setProfileImg(name: String)
//    {
//        self.set(name, forKey:CallIdentifiers.kProfileImg)
//        self.synchronize()
//    }
//    
//    func getProfileImg() -> String
//    {
//        return String.getString(self.string(forKey: CallIdentifiers.kProfileImg))
//    }
    
}
