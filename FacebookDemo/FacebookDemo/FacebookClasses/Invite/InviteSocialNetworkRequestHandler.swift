//
//  SDInviteSocialNetworkRequestHandler.swift
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