//
//  TwitterContactProtocol.swift
//  TwitterDemo
//
//  Created by Hamza Azad on 08/02/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import Foundation

protocol TwitterContactProtocol {
    
    var userId: String { get set }
    var name: String { get set }
    var avatarUri: String { get set }
    var socialNetwork: String { get set }
    
}