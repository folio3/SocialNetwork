//
//  SDFacebookRequestGraphService.swift
//  ShreddDemand
//
//  Created by Kabir on 26/10/2015.
//  Copyright (c) 2014–2016 Folio3 Pvt Ltd (http://www.folio3.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
