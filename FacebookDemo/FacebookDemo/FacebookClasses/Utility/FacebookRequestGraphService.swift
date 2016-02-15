//
//  SDFacebookRequestGraphService.swift
//  ShreddDemand
//
//  Created by Kabir on 26/10/2015.
//  Copyright © 2015 Folio3. All rights reserved.
//

import Foundation

class FacebookRequestGraphService: FacebookGraphService {

    let readPermissions = ["public_profile", "email", "user_friends", "user_birthday", "user_photos"]
    
    /**
    Fetch logged in user's facebook profile
    
    - Parameter completion: call back
    
    - Throws: nil
    
    - Returns: nil
    */
    func getUserProfile(completion: FBGCompletionCallback?) {
        let params = ["fields": "id, first_name, last_name, name, email, birthday, gender, picture.width(150).height(150)"]
        
        self.sendRequest("me", parameters: params, completion: completion)

    }
    
    /**
    Fetch logged in user's Albums profile
    
    - Parameter limit: Optional parameter to allow pagging, max results per request
    - Parameter pageId: Optional parameter requested page Id
    - Parameter pageType: parameter to get previous or next page
    - Parameter completion: call back
    
    - Throws: nil
    
    - Returns: nil
    */
    func getUserAlbums(limit: Int?, pageId: String?, pageType: FBGraphServicePageType, completion: FBGCompletionCallback?) {
        let params = ["fields": "id, name, count, created_time, picture.width(150).height(150)"]
    
        self.sendRequest("me/albums", parameters: params, limit: limit, pageId: pageId, pageType: pageType, completion: completion)
    }
    
    /**
    Fetch logged in user's Albums profile
    
    - Parameter albumId: id of album
    - Parameter limit: Optional parameter to allow pagging, max results per request
    - Parameter pageId: Optional parameter requested page Id
    - Parameter pageType: parameter to get previous or next page
    - Parameter completion: call back
    
    - Throws: nil
    
    - Returns: nil
    */
    func getUserAlbumPhotos(albumId: NSNumber, limit: Int?, pageId: String?, pageType: FBGraphServicePageType, completion: FBGCompletionCallback?) {
        
        let params = ["fields": "id, picture.width(100).height(100), images"]

        self.sendRequest("\(albumId)/photos", parameters: params, limit: limit, pageId: pageId, pageType: pageType, completion: completion)
    }
    
    /**
     Fetch logged in user's taggable friends profile

     - Parameter completion: call back
     
     
     - Throws: nil
     
     - Returns: nil
     */
    func getUserTaggableFrinds(completion: FBGCompletionCallback?) {
        let params = ["fields": "id, name, picture.width(100).height(100)"]
        self.sendRequest("me/taggable_friends", parameters: params, limit: 1000, pageId: nil, pageType: .Next, completion: completion)
    }

    /**
     Fetch logged in user's taggable friends profile
     
     - Parameter completion: call back
     
     
     - Throws: nil
     
     - Returns: nil
     */
    func getUserFrinds(completion: FBGCompletionCallback?) {
        let params = ["fields": "id, name, picture.width(100).height(100)"]
        self.sendRequest("me/friends", parameters: params, limit: 1000, pageId: nil, pageType: .Next, completion: completion)
    }
}
