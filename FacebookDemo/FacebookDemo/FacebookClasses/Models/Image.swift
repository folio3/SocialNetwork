//
//  Image.swift
//  FacebookDemo
//
//  Created by Hamza Azad on 30/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import Foundation

protocol ImagePresenting {
    
    var sourceUri: String { get set }
    var width: NSNumber { get set }
    var height: NSNumber { get set }
    var photo: FacebookPhoto? { get set }
    
}

class Image: ImagePresenting {
    
    var sourceUri: String = ""
    var width: NSNumber = 0
    var height: NSNumber = 0
    var photo: FacebookPhoto?
    
}