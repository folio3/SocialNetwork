//
//  SDTwitterHandler.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 08/01/2016.
//  Copyright (c) 2014–2016 Folio3 Pvt Ltd (http://www.folio3.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import Accounts

class TwitterHandler {
    
    let accountStore = ACAccountStore()
    private var apiKey: String!
    private var apiSecret: String!
    
    let appQueriesScheme = "twitter-auth" // put this key into info.plist under queries scheme
    private let credentials = TwitterCredentials()
    
    private var accounts: [ACAccount]?
    
    var twitter: STTwitterAPI! //(OAuthConsumerKey: apiKey, consumerSecret: apiSecret)
    
    typealias SDTwitterLoginCallback  = (username: String?, userId: String?, error: NSError?) -> Void
    var loginCallback: SDTwitterLoginCallback?
    
    required init(apiKey: String, apiSecret: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        
        self.setupTwitter()
    }
    
    private func setupTwitter() {
         let (_, _, authToken, authTokenSecret) = self.getCredentials()
        guard let token = authToken, secret = authTokenSecret else {
            self.twitter = STTwitterAPI(OAuthConsumerKey: apiKey, consumerSecret: apiSecret)
                return
        }
        //if auth token and token secret found authentic user
        self.twitter = STTwitterAPI(OAuthConsumerKey: apiKey, consumerSecret: apiSecret, oauthToken: token, oauthTokenSecret: secret)
        
    }
    
    // MARK: Login
    /*
    *  Note: This method return that the device has valid access token
    */
    func hasAccessToken() -> Bool {
        return credentials.hasToken()
    }
    
    func getCredentials () -> (userName: String?, userId: String?, authToken: String?, authTokenSecret: String?) {
       return (self.credentials.userName, self.credentials.userId, self.credentials.authToken, self.credentials.authTokenSecret)
    }
    
    func login(vc: UIViewController, loginCallback: SDTwitterLoginCallback?) {
        self.loginCallback = loginCallback
        
        chooseAccount(vc) { (accounts) -> Void in
            if accounts != nil && accounts?.count > 0 {
                self.showAccountsInSheet(accounts!, vc: vc)
            }
            else {
                self.loginViaAuth(vc)
            }
        }

    }
    
    func loginViaAuth(vc: UIViewController) {
        self.setupTwitter()
        
        self.twitter.postTokenRequest({ (url, token) -> Void in
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
            }, authenticateInsteadOfAuthorize: false, forceLogin: true, screenName: nil, oauthCallback: "\(self.appQueriesScheme)://twitter_access_tokens/") { (error) -> Void in
                print(error.localizedDescription)
                self.loginCallback?(username: nil, userId: nil, error: error)
        }
        
    }
    
    func loginViaAccounts(vc: UIViewController, hasAccounts:((Bool? -> Void)?)) {
        self.setupTwitter()
        
        chooseAccount(vc) { (accounts) -> Void in
            if let _ = accounts {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showAccountsInSheet(accounts!, vc: vc)
                }
            }
        }
    }

    private func loginViaAccount(account :ACAccount) {
        self.twitter = STTwitterAPI.twitterAPIOSWithAccount(account, delegate: nil)
        
        self.twitter.verifyCredentialsWithUserSuccessBlock({ (username, userId) -> Void in
            self.credentials.setCredientials(username, userId: userId)
            
            self.loginCallback?(username: username, userId: userId, error: nil)
            }) { (error) -> Void in
               self.loginCallback?(username: nil, userId: nil, error: error)
                
        }
    }

    private func chooseAccount(vc: UIViewController, completion:(([ACAccount]? -> Void)?)) {
        let account = ACAccountStore()
        let accountType = account.accountTypeWithAccountTypeIdentifier(
            ACAccountTypeIdentifierTwitter)
        
        account.requestAccessToAccountsWithType(accountType, options: nil,
            completion: {(success: Bool, error: NSError!) -> Void in
                
                if success {
                    let accounts = account.accountsWithAccountType(accountType) as? [ACAccount]
                    completion?(accounts)
                }
                else {
                completion?(nil)
                }
        })
    }
    
    private func showAccountsInSheet(accounts: [ACAccount], vc: UIViewController) {
        self.accounts = accounts
        
        let alert = UIAlertController(title: "Twitter Accounts", message: "Select an account:", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        for account in accounts {
            alert.addAction(UIAlertAction(title: "@\(account.username)", style: .Default, handler: {(alertAction) in
                
                let myAccounts =  self.accounts?.filter({ (selectedAccount) -> Bool in
                        "@\(selectedAccount.username)" == alertAction.title
                   })
                if let myAccount = myAccounts?.first {
                    self.loginViaAccount(myAccount)
                }
                
            }))
        }
        
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: Logout
    func logout () {
        self.credentials.removeCrediential()
    
    }
    // MARK: Application events
    
    func application(application: UIApplication!, openURL url: NSURL!, sourceApplication: String!, annotation: AnyObject!) -> Bool {
        var open = false
        if url.scheme == appQueriesScheme {
             let parameterInfo = self.getParametersFromQueryString(url.query!)
            guard let token = parameterInfo["oauth_token"], verifier = parameterInfo["oauth_verifier"] else {
                return open
            }
            self.postAccessTokenRequest(verifier, token: token, success: { (success) -> Void in
                open = success
            })
        }
        
        
        return open
    }
    
    private func getParametersFromQueryString(queryString: String) -> [String: String] {
        let queryComponents = queryString.componentsSeparatedByString("&")
        var info = [String: String]()
        
        for (_, s) in queryComponents.enumerate() {
            let pair = s.componentsSeparatedByString("=")
            if pair.count != 2 {
                continue
            }
            let key = pair[0]
            let value = pair[1]
            info[key] = value
        }
        return info
    }
    
    private func postAccessTokenRequest(verifier: String!, token: String!, success:((Bool -> Void))) {
        self.twitter.postAccessTokenRequestWithPIN(verifier, successBlock: { (oauthToken, oauthTokenSecret, userId, username) -> Void in

            self.credentials.setCredientials(username, userId: userId, authToken: oauthToken, authSecret: oauthTokenSecret)
            
            success(true)
            
            self.loginCallback?(username: username, userId: userId, error: nil)
            }) { (error) -> Void in
               
                self.loginCallback?(username: nil, userId: nil, error: error)
                success(false)
        }
    }
    

    // MARK: Twitter Credentials

    private class TwitterCredentials {
        private let userNamekey = "twitter.api.username"
        private let userIdkey = "twitter.api.userId"
        private let oauthTokenKey = "twitter.api.oauthTokenKey"
        private let oauthTokenSecretKey = "twitter.api.oauthTokenSecretKey"
        
        private let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var userName: String? {
            set (value) {
                userDefaults.setObject(value, forKey: userNamekey)
            }
            get {
                return  userDefaults.valueForKey(userNamekey) as? String
            }
        }
        
        var userId: String? {
            set (value) {
                userDefaults.setObject(value, forKey: userIdkey)
            }
            get {
                return  userDefaults.valueForKey(userIdkey) as? String
            }
        }

        var authToken: String? {
            set (value) {
                userDefaults.setObject(value, forKey: oauthTokenKey)
            }
            get {
                return  userDefaults.valueForKey(oauthTokenKey) as? String
            }
        }
        
        var authTokenSecret: String? {
            set (value) {
                userDefaults.setObject(value, forKey: oauthTokenSecretKey)
            }
            get {
                return  userDefaults.valueForKey(oauthTokenSecretKey) as? String
            }
        }
        
        func setCredientials(userName: String, userId: String) {
            self.userName = userName
            self.userId = userId
        }
        
        func setCredientials(userName: String, userId: String, authToken: String, authSecret: String) {
            self.userName = userName
            self.userId = userId
            self.authToken = authToken
            self.authTokenSecret = authSecret
        }
        
        func removeCrediential() {
            self.userName = nil
            self.userId = nil
            self.authToken = nil
            self.authTokenSecret = nil
        }
        
        func hasToken() -> Bool {
            guard let userName = self.userName where userName.characters.count > 0, let userId = self.userId where userId.characters.count > 0 else {
                return false
            }
            return true
        }
    }
}