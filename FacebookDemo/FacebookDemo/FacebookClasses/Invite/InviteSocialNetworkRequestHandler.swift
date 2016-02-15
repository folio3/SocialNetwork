//
//  SDInviteSocialNetworkRequestHandler.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 08/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import UIKit

public typealias RHCompletionCallback = (result: AnyObject?, error: NSError?) -> Void

class InviteSocialNetworkRequestHandler {

    weak var viewController: UIViewController?
    
    enum RequestType: Int {
        case Friends, Login, Invite
    }
    
    required init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func sendRequestWithDelay(requestType: Int, parameters: AnyObject?, completion: RHCompletionCallback) {
        // Delay the request
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.sendRequest(requestType, parameters: parameters, completion: completion)
        }
    }
    
    func sendRequest(requestType: Int, parameters: AnyObject?, completion: RHCompletionCallback) {
        if let type = RequestType(rawValue: requestType) {
            switch type {
                
            case .Friends:
                self.getFriends(completion)
        
            case .Login:
                self.performLogin(completion)
            
            case .Invite:
                self.inviteFriends(parameters, completion: completion)
            }
    
        }
    }
    func performLogin(completion: RHCompletionCallback) {
        //override this method
    }
    
    
    func getFriends(completion: RHCompletionCallback) {
        //override this method
    }
    
    func inviteFriends(parameters: AnyObject?, completion: RHCompletionCallback) {
        //override this method
    }
    
    func hasAccessToken() -> Bool {
        //override this method.
        return false
    }
}