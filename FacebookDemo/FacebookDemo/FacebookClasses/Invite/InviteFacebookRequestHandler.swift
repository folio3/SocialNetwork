//
//  SDInviteFacebookRequestHandler.swift
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