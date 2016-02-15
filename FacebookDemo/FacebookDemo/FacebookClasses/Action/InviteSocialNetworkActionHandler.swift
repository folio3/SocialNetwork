//
//  SDInviteSocialNetworkActionHandler.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 11/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import UIKit

class InviteSocialNetworkActionHandler {
    
    unowned var viewController: UIViewController
    
    required init(vc: UIViewController) {
        self.viewController = vc
    }
    
    var vc: UIViewController {
        return self.viewController
    }
    
    func inviteFriends(contacts: [FacebookContact]?) {
        //override this method
    }
}