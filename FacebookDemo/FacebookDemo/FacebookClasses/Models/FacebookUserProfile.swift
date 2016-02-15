//
//  FacebookUserProfile.swift
//  FacebookDemo
//
//  Created by Hamza Azad on 30/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import Foundation

protocol FacebookUserProfilePresenting {
    
    var firstName: String { get set }
    var lastName: String { get set }
    var name: String { get set }
    var birthday: NSDate? { get set }
    var gender: String { get set }
    var userId: NSNumber? { get set }
    var email: String { get set }
    var socialNetworkAvatarUri: String { get set }
    
}

class FacebookUserProfile: FacebookUserProfilePresenting {
    
    var firstName: String = ""
    var lastName: String = ""
    var name: String = ""
    var birthday: NSDate?
    var gender: String = ""
    var userId: NSNumber?
    var email: String = ""
    var socialNetworkAvatarUri: String = ""
    
}