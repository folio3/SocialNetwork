//
//  SDInviteTwitterRequestHandler.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 08/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
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