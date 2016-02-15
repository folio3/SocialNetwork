//
//  AppDelegate.swift
//  FacebookDemo
//
//  Created by Hamza Azad on 30/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let AppURL = "http://www.yourapp.com"
    static let facebookHandler = FacebookHandler()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation) {
            return true
        }
        
        return false
    }

}

