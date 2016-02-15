//
//  SDInviteFacebookActionHandler.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 11/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import Foundation

class InviteFacebookActionHandler: InviteSocialNetworkActionHandler {

    private let shareHandler = FacebookShareHandler()
    
    override func inviteFriends(contacts: [FacebookContact]?) {
        let appLink = NSURL(string: AppDelegate.AppURL)!
        shareHandler.inviteFriends(appLink, previewImageURL: nil, vc: self.vc, delegate: nil)
    }
}