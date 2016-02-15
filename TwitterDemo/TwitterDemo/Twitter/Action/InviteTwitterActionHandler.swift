//
//  SDInviteTwitterActionHandler.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 11/01/2016.
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
import Social

class InviteTwitterActionHandler: InviteSocialNetworkActionHandler {

    private var selectedContact: TwitterContact?
    unowned var requestHandler: InviteTwitterRequestHandler {
        let vc = self.viewController as? InviteTwitterFriendsViewController
       return vc!.requestHandler
    }

     override func inviteFriends(contacts: [TwitterContact]?) {

        let contact = contacts?.last
        let message = "@\(contact!.userId) Hello there !"

        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc.setInitialText(message)
            vc.addURL(NSURL(string: AppDelegate.AppURL))
            self.viewController.presentViewController(vc, animated: true, completion: nil)
        }
        else {
            let type = InviteTwitterRequestHandler.RequestType.Invite.rawValue
            self.requestHandler.sendRequest(type, parameters: contacts, completion: { (result, error) -> Void in
                
            })
        }
    }
}