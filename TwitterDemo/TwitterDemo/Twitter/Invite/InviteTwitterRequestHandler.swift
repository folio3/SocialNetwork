//
//  SDInviteTwitterRequestHandler.swift
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

import Foundation

class InviteTwitterRequestHandler: InviteSocialNetworkRequestHandler {

    let twitterHandler = AppDelegate.twitterHandler
    private let parser = TwitterParser()
    
    private var accountName: String? {
        let (userName, _, _, _) = self.twitterHandler.getCredentials()
        return userName
    }
    
    override func hasAccessToken() -> Bool {
        return twitterHandler.hasAccessToken()
    }
    
    override func performLogin(completion: RHCompletionCallback) {
        twitterHandler.logout()
        guard let vc = self.viewController else {
            completion(result: nil, error: nil)
            return
        }
        
        twitterHandler.login(vc) { (username, userId, error) -> Void in
            if error == nil {
                self.sendRequest(RequestType.Friends.rawValue, parameters: nil, completion: completion)
            }
        }
    }
    
    override func getFriends(completion: RHCompletionCallback) {
       
        guard let userName = self.accountName else {
            return
        }
        
        self.twitterHandler.twitter.getFollowersForScreenName(userName
            , successBlock: { (response) -> Void in
                
                self.parser.parse(0, object: response, completion: { (result, error) -> Void in
                    completion(result: result, error: error)
                })
            
            }) { (error) -> Void in
                completion(result: nil, error: error)
        }
    }
    
    override func inviteFriends(parameters: AnyObject?, completion: RHCompletionCallback) {
        guard let contacts = parameters as? [TwitterContact] where contacts.count > 0 else {
            return
        }
        
        let contact = contacts.last
        let message = "Hello there @\(contact!.userId)!"
        
        self.twitterHandler.twitter.postStatusUpdate(message, inReplyToStatusID: nil, latitude: nil, longitude: nil, placeID: nil, displayCoordinates: nil, trimUser: nil, successBlock: { (response) -> Void in
            
            let message = "Invitation sent successfully !"
            let response = ["message" : message]
            
            completion(result: response, error: nil)
            
            }) { (error) -> Void in
                
                
                completion(result: nil, error: error)
        }
    }
}