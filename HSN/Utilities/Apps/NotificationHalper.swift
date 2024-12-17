////
////  NotificationHalper.swift
////  Rimo
////
////  Created by fluper on 20/09/19.
////  Copyright © 2019 Fluper. All rights reserved.
////
//
//import Foundation
//import Firebase
//import FirebaseMessaging
//import UserNotifications
//import NotificationCenter
//
//let AppsNotificationHalper = NotificationHalper.sharedInstanse
//
//
////MARK:- Class for Push Notifications
//class NotificationHalper:  UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate, MessagingDelegate {
//
//    //Static variable For Static Variable
//    internal static let sharedInstanse = NotificationHalper()
//
//
//    //MARK:- Func For Notifilcations
//    func notificationSetup(application : UIApplication) {
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
//        Messaging.messaging().delegate = self
//    }
//
//    func notificationFunction() {
//        Messaging.messaging().subscribe(toTopic: "Companions Request") { error in
//            print("Subscribed to Companions Request topic")
//        }
//        Messaging.messaging().subscribe(toTopic: "Companions Request") { error in
//            print("Subscribed to Companions Request topic")
//        }
//        Messaging.messaging().subscribe(toTopic: "Companions Request") { error in
//            print("Subscribed to Companions Request topic")
//        }
//        Messaging.messaging().subscribe(toTopic: "Companions Request") { error in
//            print("Subscribed to Companions Request topic")
//        }
//        Messaging.messaging().subscribe(toTopic: "Companions Request") { error in
//            print("Subscribed to CompletedEvent topic")
//        }
//    }
//
//
//    private func registerForPushNotification(_ application: UIApplication) {
//
//        let current = UNUserNotificationCenter.current()
//        current.delegate = self
//        Messaging.messaging().delegate = self
//
//        current.requestAuthorization(options: [.alert, .badge, .sound]) { (flag, error) in
//            if error == nil {
//                DispatchQueue.main.async {
//                    application.registerForRemoteNotifications()
//                }
//            }
//        }
//    }
//
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Firebase registration token: \(fcmToken)")
//        let dataDict:[String: String] = ["token": fcmToken]
//        UserDefaults.standard.set(fcmToken, forKey: Keys.kDeviceToken)
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
//    }
//
//    @objc func refreshToken(notification: Notification) {
//
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instance ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//                UserDefaults.standard.set(result.token, forKey: Keys.kDeviceToken)
//            }
//        }
//    }
//
//
//    // when app is in foreground - this method gets called when a notification arrives
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        print(#function)
//        let apsData = kSharedInstance.getDictionary(notification.request.content.userInfo)
//        let userInformation = kSharedInstance.getDictionary(apsData["aps"])
//        print(userInformation)
//        completionHandler([.alert, .badge, .sound])
//    }
//
//
//
//
//    // background - nothing ll happen on notification arrival until it gets tapped // gets called everytime when user tap on notification from banner
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print(#function)
//        let apsData = kSharedInstance.getDictionary(response.notification.request.content.userInfo)
//
//        let userInformation = kSharedInstance.getDictionary(apsData["aps"])
//        print(userInformation)
//        completionHandler()
//    }
//
//}
