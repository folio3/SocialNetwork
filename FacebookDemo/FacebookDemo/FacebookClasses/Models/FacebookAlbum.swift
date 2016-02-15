//
//  FacebookAlbum.swift
//  FacebookDemo
//
//  Created by Hamza Azad on 30/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import Foundation

protocol FacebookAlbumPresenting {
    
    var identifier: NSNumber? { get }
    var name: String { get }
    var created: NSDate? { get }
    var count: NSNumber { get  }
    var avatarUri: String { get  }
    var photos: [FacebookPhoto] { get }
    
    func addPhoto(photo: FacebookPhoto)
}

class FacebookAlbum: FacebookAlbumPresenting {
    
    var identifier: NSNumber?
    var name: String = ""
    var created: NSDate?
    var count: NSNumber = 0
    var avatarUri: String = ""
    var photos: [FacebookPhoto] = [FacebookPhoto]()
    
    func addPhoto(photo: FacebookPhoto) {
        photos.append(photo)
    }
}