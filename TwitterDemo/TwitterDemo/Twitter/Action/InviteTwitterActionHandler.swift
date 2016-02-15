//
//  SDInviteTwitterActionHandler.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 11/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
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