//
//  SDFacebookHandler.swift
//  ShreddDemand
//
//  Created by Kabir on 02/10/2015.
//  Copyright © 2015 Folio3. All rights reserved.
//

import Foundation

class FacebookHandler: FacebookRequestGraphService {
    
    typealias FBGLoginCompletionCallback  = (result: AnyObject?, error: NSError?, cancelled: Bool?) -> Void
    var loginCompletionCallback: FBGLoginCompletionCallback?
    var graphService = FacebookRequestGraphService()
    
    private let loginManager = FBSDKLoginManager()
    
    // MARK: Login
    /*
     *  Note: This method return that the device has valid access token
     */
    func hasAccessToken() -> Bool {
        return FBSDKAccessToken.currentAccessToken() != nil
    }
    
    /*
     *  Note: This method is use to get native facebook button.
     */
    func getFacebookLoginButton() -> FBSDKLoginButton {
        let loginButton : FBSDKLoginButton = FBSDKLoginButton()
        loginButton.readPermissions = self.readPermissions
        //loginButton.delegate = self
        return loginButton

    }
    
    /*
     *  Note: This method is use to perform login via custom button
     */
    func loginFromViewController(vc: UIViewController!, completion: FBGLoginCompletionCallback?) {
        loginManager.logInWithReadPermissions(self.readPermissions, fromViewController: vc) { (result, error) -> Void in
            var info: [String: AnyObject]?
            if (error == nil && !result.isCancelled) {
                info = ["token": result.token.tokenString, "user_id": result.token.userID, "app_id": result.token.userID,
                "granted_permissions": result.grantedPermissions, "declined_permissions": result.declinedPermissions]
            }
            if completion != nil {
                let cancelled = (result != nil) ? result.isCancelled : false
                completion!(result: info, error: error, cancelled: cancelled)
            }
        }
    }
    
    func logout() {
        loginManager.logOut()
    }
}

extension FacebookHandler: FBSDKLoginButtonDelegate {

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }

}