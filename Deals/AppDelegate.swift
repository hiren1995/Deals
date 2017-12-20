//
//  AppDelegate.swift
//  Deals
//
//  Created by Mohit on 20/09/17.
//  Copyright © 2017 Mohit Thakkar. All rights reserved.
//

import UIKit
import UserNotifications
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import GoogleMaps
import GooglePlaces


var tempLatitude:Double?
var tempLongitude:Double?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate,CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var arrMessageIDs = [Any]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        getLatLong()
        
        
        // Override point for customization after application launch.
    
        GMSServices.provideAPIKey("AIzaSyCIDNIaKIzmR_UnzvBhJje8IHbiGCJKQII")
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        for family in UIFont.familyNames {
            let sName: String = family as String
            print("family: \(sName)")
            
            for name in UIFont.fontNames(forFamilyName: sName) {
                print("name: \(name as String)")
            }
        }
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        var storyboard = UIStoryboard()
        
        let language: String = NSLocale.preferredLanguages[0]
        if (language == "ar") {
            storyboard = UIStoryboard(name: "Main_Arabic", bundle: nil)
            isArabic = true
        }
        else{
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            isArabic = false
        }
        
        // IF Opening from Notification Open specific Screen else Open home screen
        if (launchOptions?[.remoteNotification] as? [String: AnyObject]) != nil
        {
            // Parse Notification Data
            let launchDict = launchOptions! as NSDictionary
            let userInfo = launchDict.object(forKey: UIApplicationLaunchOptionsKey.remoteNotification) as? NSDictionary
            
            let aps = userInfo?["gcm.notification.data"] as? String
            // print(aps)
            
            let data = aps?.data(using: .utf8)
            
            var jsonDictionary : NSDictionary = [:]
            do {
                jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
            } catch {
                print(error)
            }
            print(jsonDictionary)
            let strType = jsonDictionary["notification_from"] as? String
            if strType == "message"
            {
                let catList = storyboard.instantiateViewController(withIdentifier: "chatList") as! ChatList
                catList.strIsUpdate = true
                catList.strChatRandomID = jsonDictionary["chat_random_id"] as! String
                self.window?.rootViewController = catList
            }
            else{
                let notificationView = storyboard.instantiateViewController(withIdentifier: "notification") as! Notifications
                self.window?.rootViewController = notificationView
            }
        }
        else{
            
            //        isArabic = udefault.bool(forKey: "IsArabic")
            //
            //        if isArabic{
            //            storyboard = UIStoryboard(name: "Main_Arabic", bundle: nil)
            //        }
            //        else{
            //            storyboard = UIStoryboard(name: "Main", bundle: nil)
            //        }
            
            //  storyboard = UIStoryboard(name: "Main", bundle: nil)
            let login = UserDefaults.standard.bool(forKey: "Login")
            
            if login{
                let initialView = storyboard.instantiateViewController(withIdentifier: "HomeView")
                let menuView = storyboard.instantiateViewController(withIdentifier: "MenuView")
                
                let mainView : SWRevealViewController = SWRevealViewController(rearViewController: menuView, frontViewController: initialView)
                mainView.rightViewController = menuView
                
                self.window?.rootViewController = mainView
            }
            else{
                let initialView = storyboard.instantiateViewController(withIdentifier: "LanguageView")
                self.window?.rootViewController = initialView
            }
        }

        self.window?.makeKeyAndVisible()
        return true
    }
    //To get Device Token or Firebase Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        // FCM Token
        if let refreshedToken = InstanceID.instanceID().token(){
            print("InstanceID token: \(refreshedToken)")
            udefault.setValue(refreshedToken, forKey: "DeviceToken")
        }
         connectToFcm()
    }
    
    func connectToFcm() {
        Messaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String)
    {
        print("Firebase registration token: \(fcmToken)")
        udefault.setValue(fcmToken, forKey: "DeviceToken")
        udefault.synchronize()
    }
    
    //Called if unable to register for APNS.
    private func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }

    //Push Notification Methods
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        //Opening Specific Screen
//       self.application(application, didReceiveRemoteNotification: userInfo) { (UIBackgroundFetchResult) in
//        
//        let aps = userInfo["gcm.notification.data"] as? String
//        // print(aps)
//        
//        let data = aps?.data(using: .utf8)
//        
//        var jsonDictionary : NSDictionary = [:]
//        do {
//            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
//        } catch {
//            print(error)
//        }
//        print("Notification Data is:\(jsonDictionary)")
//        
//        
//        let strType = jsonDictionary["notification_from"] as? String
//        if strType == "message"{
//            udefault.set(true, forKey: "ISNewMSG")
//            if udefault.object(forKey: "ChatIDArray") != nil{
//                
//            }
//            else{
//                var tempArray = NSMutableArray()
//                let temp : String = jsonDictionary.object(forKey: "chat_random_id") as! String
//                tempArray.insert(temp, at: 0)
//                udefault.setValue(tempArray, forKey: "ChatIDArray")
//                udefault.synchronize()
//            }
//        }
//        else{
//            udefault.set(true, forKey: "ISNewNotification")
//        }
//
//        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
    
        // Print full message.
        print(userInfo)
        
        let aps = userInfo["gcm.notification.data"] as? String
        // print(aps)
        
        let data = aps?.data(using: .utf8)
        
        var jsonDictionary : NSDictionary = [:]
        do {
            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
        } catch {
            print(error)
            
        }
        print("Notification Data is:\(jsonDictionary)")
        
        if isKeyPresentInUserDefaults(key: "roomids")
        {
            //            strChatRandomID
            if jsonDictionary["chat_random_id"] != nil
            {
                // now val is not nil and the Optional has been unwrapped, so use it
                var roomids : [Int]  = UserDefaults.standard.object(forKey: "roomids") as! [Int]
                if let totalfup = (jsonDictionary["chat_random_id"] as? NSString)?.doubleValue
                {
                    roomids.append(Int(totalfup))
                }
                UserDefaults.standard.set(roomids, forKey: "roomids")
                UserDefaults.standard.synchronize()
            }
            
            
        }
        else
        
        {
            if jsonDictionary["chat_random_id"] != nil
            {
                // now val is not nil and the Optional has been unwrapped, so use it
                var roomids = [Int]()
                
                if let totalfup = (jsonDictionary["chat_random_id"] as? NSString)?.doubleValue
                {
                    roomids.append(Int(totalfup))
                }
                UserDefaults.standard.set(roomids, forKey: "roomids")
                UserDefaults.standard.synchronize()

            }
    }
        
        let strType = jsonDictionary["notification_from"] as? String
        if strType == "message"{
            udefault.set(true, forKey: "ISNewMSG")
        }
        else{
            udefault.set(true, forKey: "ISNewNotification")
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        let aps = userInfo["gcm.notification.data"] as? String
        // print(aps)
        
        let data = aps?.data(using: .utf8)
        
        var jsonDictionary : NSDictionary = [:]
        do {
            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
        } catch {
            print(error)
        }
        print("Notification Data is:\(jsonDictionary)")
        
        let strType = jsonDictionary["notification_from"] as? String
        if strType == "message"{
            udefault.set(true, forKey: "ISNewMSG")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MessageNotification"), object: jsonDictionary)
        }
        else{
            udefault.set(true, forKey: "ISNewNotification")
        }
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func getLatLong()
    {
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        let x = locationManager.location
        print(x?.coordinate.latitude)
        print(x?.coordinate.longitude)
        
        tempLatitude = x?.coordinate.latitude
        tempLongitude = x?.coordinate.longitude
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let mylocation = locations.last
        
        
        //mylocation!.coordinate.latitude, mylocation!.coordinate.longitude
        
        tempLatitude = mylocation!.coordinate.latitude.magnitude
        tempLongitude = mylocation!.coordinate.longitude.magnitude
        
        print(tempLatitude)
        print(tempLongitude)
        
        locationManager.stopUpdatingLocation()
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

