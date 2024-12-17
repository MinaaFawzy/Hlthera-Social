//
//  AppDelegate.swift
//  HSN
//
//  Created by Kartikeya on 09/04/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

//Cannot find 'MobileFFmpegConfig' in scope
import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import Firebase
import Realm
import RealmSwift
import FBSDKCoreKit
import GiphyUISDK
import GoogleMaps
import GooglePlaces
import LocalAuthentication
import Stripe
import AVKit
//import netfox

let signInConfig = "226044830409-10ghqar11j8pu3iopvqq8nrkapjg6ki0.apps.googleusercontent.com"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var error: NSError?
    let context = LAContext()
    var window: UIWindow?
    var strDuration:String? = "0 min"
    var providerDelegate: ProviderDelegate!
    let callManager = CallManager()
    var callback:(()->())?
    var viewToShow = LoungeMeetingView()
    var isShowLounge = true
    var tabBarController : JBTabBarController?
    // set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.portrait
    var promotionType = "post"
    var loungeId = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        //  MobileFFmpegConfig.disableRedirection()
        Giphy.configure(apiKey: "6uidFzsvzgVpxtmc1dOrUhZutJ22mkE6")
        GMSPlacesClient.provideAPIKey("AIzaSyBkOupVAfj_PNfVmHLK9P4RYn3lFAQmtj0")
        
        
        // GMSPlacesClient.provideAPIKey("AIzaSyCU9ktEBufzG5ofud0nXGP3ZcP2ee_0L18") //AIzaSyC7sHWZhO_DYJgbsIRw98a6b8DConumItA") //todo emojizone
        GMSServices.provideAPIKey("AIzaSyCU9ktEBufzG5ofud0nXGP3ZcP2ee_0L18") //AIzaSyC7sHWZhO_DYJgbsIRw98a6b8DConumItA")
        
        UIApplication.shared.statusBarStyle = .darkContent
        // STPAPIClient.shared().publishableKey = "pk_test_51I9Qp6HYt9LR9IA3gP8DzBqBU61K7fK53IDh9PFllKUDlPpcFslBvBvtqpqXqN9A4ELSdAm7lJ9Y4ZzmbqfQ8TKK00GYUfBppq"
        StripeAPI.defaultPublishableKey = "pk_test_51I9Qp6HYt9LR9IA3gP8DzBqBU61K7fK53IDh9PFllKUDlPpcFslBvBvtqpqXqN9A4ELSdAm7lJ9Y4ZzmbqfQ8TKK00GYUfBppq"
        //  STPAPIClient.shared.
        STPAPIClient.shared.publishableKey = "pk_test_51I9Qp6HYt9LR9IA3gP8DzBqBU61K7fK53IDh9PFllKUDlPpcFslBvBvtqpqXqN9A4ELSdAm7lJ9Y4ZzmbqfQ8TKK00GYUfBppq"
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
        IQKeyboardManager.shared.toolbarTintColor = UIColor(named: "12")
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        initialSetup()
        initializeRealmDB()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        //  GIDSignIn.sharedInstance()?.clientID = "226044830409-10ghqar11j8pu3iopvqq8nrkapjg6ki0.apps.googleusercontent.com"
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        providerDelegate = ProviderDelegate(callManager: callManager)
        
        Messaging.messaging().delegate = self
        
        //confrigNotification(application:application)
        // Override point for customization after application launch.
        // MARK: - Status Bar Background Color Setup
        let backgroundColor = UIColor(red: 245, green: 247, blue: 249)
        if #available(iOS 13.0, *) {
            let statusBarAppearance = UINavigationBarAppearance()
            statusBarAppearance.backgroundColor = backgroundColor
            statusBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            UINavigationBar.appearance().scrollEdgeAppearance = statusBarAppearance
            UINavigationBar.appearance().standardAppearance = statusBarAppearance
        } else {
            UINavigationBar.appearance().barTintColor = backgroundColor
        }
        //UIViewController().setStatusBarBackgroundColor(color: backgroundColor)
        // Remove back button text
//        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.clear,
//                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 0)]
//        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
//#if DEBUG
//        NFX.sharedInstance().start()
//#endif
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        kSharedUserDefaults.setPostDraft(postDraft: "")
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        handleReceiveNotification(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        handleReceiveNotification(userInfo: userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func moveToWalkthrough() {
        let story = UIStoryboard(name: "Main", bundle:nil)
        guard let vc = story.instantiateViewController(withIdentifier: WalkthroughVC.getStoryboardID()) as? WalkthroughVC else { return }
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func moveToSplash() {
        let story = UIStoryboard(name: "Main", bundle:nil)
        guard let vc = story.instantiateViewController(withIdentifier: SplashVC.getStoryboardID()) as? SplashVC else { return }
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func moveToLoginScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: LoginVC.getStoryboardID()) as! LoginVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func moveToHomeScreen(index: Int = 0) {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: JBTabBarController.getStoryboardID()) as! JBTabBarController
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
        //            vc.selectedIndex = 0
        //        })
        vc.selectedIndex = 0
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: true)
        
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    
    func logout() {
        kSharedUserDefaults.setUserLoggedIn(userLoggedIn: false)
        kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: [:])
        kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: "")
        kSharedUserDefaults.updateSavedSuggestions(suggestions: [])
        moveToLoginScreen()
    }
    
    func loginWithFaceId(completion: @escaping ((Int)->())) {
        
        let reason = "Identify yourself!"
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error){
            
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        completion(1)
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default,handler: {data in completion(0)}))
                        UIApplication.shared.windows.first?.rootViewController?.present(ac, animated: true, completion: nil)
                    }
                }
            }
        }else{
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default,handler: {data in completion(2)}))
            
            UIApplication.shared.windows.first?.rootViewController?.present(ac, animated: true, completion: nil)
        }
    }
    
    func isFaceIDSupported(completion: @escaping ((Bool) -> ())) {
        _ = "Identify yourself!"
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            completion(true)
            //context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, authenticationError) in
            //}
        } else {
            completion(false)
        }
    }
    
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        //handleReceiveNotification(userInfo: userInfo)
        completionHandler([[.alert, .sound,.badge]])
        
    }
    
    func handleReceiveNotification(userInfo: [AnyHashable: Any]){
        let dic : [String : Any] = userInfo["notification"] as! [String : Any]
        //        let alert : [String: Any] = d["alert"] as! [String:Any]
        //        let body : String = alert["body"] as! String
        let notify_type : String =  String.getString(dic["notify_type"])
        let type_id : String = String.getString(dic["type_id"])
        //        print("body \(body)")
        //        print("title \(title)")
        //        print(userInfo)
        print(userInfo)
        switch Int.getInt(notify_type) {
        case 1:
            let story = UIStoryboard(name: Storyboards.kHome, bundle:nil)
            guard let vc = story.instantiateViewController(withIdentifier: ViewEventVC.getStoryboardID()) as? ViewEventVC else { return }
            vc.eventId = type_id
            vc.isCameFromNotififications = true
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.setNavigationBarHidden(true, animated: true)
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        case 2:
            let story = UIStoryboard(name: Storyboards.kHome, bundle:nil)
            guard let vc = story.instantiateViewController(withIdentifier: ViewGroupVC.getStoryboardID()) as? ViewGroupVC else { return }
            vc.groupId = type_id
            vc.isCameFromNotififications = true
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.setNavigationBarHidden(true, animated: true)
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        case 3:
            let story = UIStoryboard(name: Storyboards.kChat, bundle:nil)
            guard let vc = story.instantiateViewController(withIdentifier: ChatViewController.getStoryboardID()) as? ChatViewController else { return }
            vc.receiverid = type_id
            vc.isCameFromNotififications = true
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.setNavigationBarHidden(true, animated: true)
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        default:break
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        handleReceiveNotification(userInfo: userInfo)
        completionHandler()
    }
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        kSharedUserDefaults.setDeviceToken(deviceToken: fcmToken!)
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
    }
    func application(application: UIApplication,
                     didRegisterForRemoteNotification4sWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Messaging.messaging().apnsToken = deviceToken
        kSharedUserDefaults.setDeviceToken(deviceToken: token)
    }
}


extension AppDelegate {
    
    func initialSetup() {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
    }
    
    func initializeRealmDB() {
        var config = Realm.Configuration(
            
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            
            schemaVersion: 4,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            
            migrationBlock: { migration, oldSchemaVersion in
                
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                
                if (oldSchemaVersion < 3) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })
        
        Realm.Configuration.defaultConfiguration = config
        config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
    }
}

//extension AppDelegate:UNUserNotificationCenterDelegate{
//    func confrigNotification(application:UIApplication) {
//        UNUserNotificationCenter.current().delegate = self
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(options: authOptions){_,_ in
//        }
//        application.registerForRemoteNotifications()
//        UIApplication.shared.registerForRemoteNotifications()
//        self.registerForPushNotification(application)
//    }
//    private func registerForPushNotification(_ application: UIApplication) {
//        let current = UNUserNotificationCenter.current()
//        current.delegate = self
//        current.requestAuthorization(options: [.alert, .badge, .sound]) { (flag, error) in
//            if error == nil {
//                DispatchQueue.main.async {
//                    application.registerForRemoteNotifications()
//                }
//            }
//        }
//    }
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenParts = deviceToken.map { data -> String in return String(format: "%02.2hhx", data) }
//        let token = tokenParts.joined()
//
//        UserDefaults.standard.set(token, forKey: "device_token")
//        kSharedUserDefaults.setDeviceToken(deviceToken: token)
//
//        let dataDict:[String: String] = ["token": token]
//    }
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print(userInfo)
//    }
//
//
//    //MARK:- when app is in foreground - this method gets called when a notification arrives
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .badge, .sound])
//    }
//    //MARK:-  background - nothing ll happen on notification arrival until it gets tapped // gets called everytime when user tap on notification from banner
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = kSharedInstance.getDictionary(response.notification.request.content.userInfo)
//        print(userInfo)
//        let aps = userInfo[("aps")] as? NSDictionary
//        let alert = aps?["alert"] as? NSDictionary
//        let body = String.getString(alert?["body"])
//        completionHandler()
//    }
//
//}
extension AppDelegate {
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return handleDeepLinkUrl(userActivity.webpageURL)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool{
        //first launch after install
        return handleDeepLinkUrl(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{
        //first launch after install for older iOS version
        return handleDeepLinkUrl(url)
    }
    
    //    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    //                if let incomingurl  = userActivity.webpageURL{
    //                    print("incomming Url link ......", incomingurl)
    //                    let linkhandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingurl) { (dynamic, err) in
    //                        guard err == nil else{
    //                            print(err?.localizedDescription)
    //                            return}
    //                        if let dynamicLink = dynamic {
    //                            self.handledIncommingDynamicLink(dynamicLink)
    //                        }
    //                    }
    //                    if linkhandled{
    //                        return true
    //                    }else{
    //                        return false
    //                    }
    //                }
    //                return false
    //            }
    //
    //
    //
    //
    func handledIncommingDynamicLink(_ link: DynamicLink){
        guard let url = link.url else {
            print("no link found")
            return}
        print("my incomming link parametewr is...........................",url.absoluteString)
        guard (link.matchType == .unique || link.matchType == .default) else{
            print("not a strong enough the match type")
            return
        }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryitem = components.queryItems else{return}
        if components.path == "/"{
            if let id = queryitem.first(where: {$0.name == "id"}){
                guard let idValue = id.value else{return}
                if kSharedUserDefaults.isUserLoggedIn(){
                    
                    
                    let storyBoard = UIStoryboard(name: Storyboards.kLounge, bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: AudioRoomVC.getStoryboardID()) as! AudioRoomVC
                    
                    vc.roomId = idValue
                    let navigationController = UINavigationController(rootViewController: vc)
                    navigationController.setNavigationBarHidden(true, animated: true)
                    UIApplication.shared.windows.first?.rootViewController = navigationController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    
                    
                    
                    
                    
                    //                        if typeVc == "Coupon"{
                    //                            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                    //                            let vc = storyBoard.instantiateViewController(withIdentifier: "CouponVC") as? CouponVC
                    //                                vc?.isFromLink = true
                    //                                vc?.couponId = idValue
                    //                            let navigationController = UINavigationController(rootViewController: vc!)
                    //                            navigationController.setNavigationBarHidden(true, animated: true)
                    //                            self.window?.rootViewController = navigationController
                    //                        }else if typeVc == "Offer"{
                    //                            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                    //                            let vc = storyBoard.instantiateViewController(withIdentifier: "offerVC") as? offerVC
                    //                            vc?.isFromLink = true
                    //                            vc?.offerId = idValue
                    //                            let navigationController = UINavigationController(rootViewController: vc!)
                    //                            navigationController.setNavigationBarHidden(true, animated: true)
                    //                            self.window?.rootViewController = navigationController
                    //                        }else if typeVc == "StarKid"{
                    //
                    //
                    //
                    //                            let storyBoard = UIStoryboard.init(name: Storyboard.kStoryboardHome, bundle: nil)
                    //
                    //                            guard let vc = storyBoard.instantiateViewController(withIdentifier: Identifiers.kOurStarViewController) as? OurStarViewController else { return }
                    //
                    //                            vc.deeplinkId = idValue
                    //                            let navigationController = UINavigationController(rootViewController: vc)
                    //                            navigationController.setNavigationBarHidden(true, animated: true)
                    //                            self.window?.rootViewController = navigationController
                    //
                    //                        }else{
                    //                            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                    //                            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC
                    //                            vc?.isFronLink = true
                    //                            vc?.product_id = Int.getInt(idValue)
                    //                            let navigationController = UINavigationController(rootViewController: vc!)
                    //                            navigationController.setNavigationBarHidden(true, animated: true)
                    //                            self.window?.rootViewController = navigationController
                    //
                    //                        }
                    
                }else{
                    kSharedAppDelegate?.moveToLoginScreen()
                }
            }
        }
    }
}

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value?.removingPercentEncoding?.removingPercentEncoding
    }
}

func handleDeepLinkUrl(_ url: URL?) -> Bool {
    if let link = url {
        let linkhandled = DynamicLinks.dynamicLinks().handleUniversalLink(link) { (dynamic, err) in
            guard err == nil else {
                print(err?.localizedDescription)
                return }
            if let dynamicLink = dynamic {
                kSharedAppDelegate?.handledIncommingDynamicLink(dynamicLink)
            }
        }
        if linkhandled {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
    
}

extension UIViewController {
    func setStatusBarBackgroundColor(_ color: UIColor) {
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = color
            UIApplication.shared.windows.first?.addSubview(statusBar)
        } else {
            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
            statusBar.backgroundColor = color
        }
    }
}
