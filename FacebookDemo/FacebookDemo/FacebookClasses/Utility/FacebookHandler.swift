//
//  SDFacebookHandler.swift
//  ShreddDemand
//
//  Created by Kabir on 02/10/2015.
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