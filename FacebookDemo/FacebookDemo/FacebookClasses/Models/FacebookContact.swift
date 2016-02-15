//
//  FacebookContact.swift
//  TwitterDemo
//
//  Created by Hamza Azad on 30/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import Foundation

protocol FacebookContactPresenting {
    
    var userId: String { get set }
    var name: String { get set }
    var avatarUri: String { get set }
    var socialNetwork: String { get set }
    
}

class FacebookContact: FacebookContactPresenting {
    
    var userId: String = ""
    var name: String = ""
    var avatarUri: String = ""
    var socialNetwork: String = ""
    
}