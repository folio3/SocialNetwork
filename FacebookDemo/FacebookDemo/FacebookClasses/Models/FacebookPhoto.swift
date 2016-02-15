//
//  FacebookPhoto.swift
//  FacebookDemo
//
//  Created by Hamza Azad on 30/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import Foundation

protocol FacebookPhotoPresenting {
    
    var identifier: NSNumber? { get set }
    var avatarUri: String { get set }
    var album: FacebookAlbum? { get set }
    var images: [Image] { get set }
    
    func addImage(image: Image)
}

class FacebookPhoto: FacebookPhotoPresenting {
    
    var identifier: NSNumber? = nil
    var avatarUri: String = ""
    var album: FacebookAlbum?
    var images: [Image] = [Image]()
    
    func addImage(image: Image) {
        images.append(image)
    }
}