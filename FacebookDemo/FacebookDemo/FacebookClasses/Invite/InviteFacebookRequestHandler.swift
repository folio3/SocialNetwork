//
//  SDInviteFacebookRequestHandler.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 08/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import Foundation

class InviteFacebookRequestHandler: InviteSocialNetworkRequestHandler {

    private let facebookHandler = FacebookHandler()
    private let parser = FBFriendsParser()
    
    override func hasAccessToken() -> Bool {
        return facebookHandler.hasAccessToken()
    }
    
    override func performLogin(completion: RHCompletionCallback) {
        facebookHandler.logout()
        guard let vc = self.viewController else {
            completion(result: nil, error: nil)
            return
        }
        
        facebookHandler.loginFromViewController(vc, completion: { (result, error, cancelled) -> Void in
            if var _ = result as? [String: AnyObject] {
                self.sendRequest(RequestType.Friends.rawValue, parameters: nil, completion: completion)
            }
            else {
                completion(result: nil, error: error)
            }
        })

    }
    
    override func getFriends(completion: RHCompletionCallback) {
        self.facebookHandler.getUserFrinds { (result, error) -> Void in
            self.parser.parse(0, object: result, completion: { (result, error) -> Void in
                completion(result: result, error: error)
            })
        }
    }
}