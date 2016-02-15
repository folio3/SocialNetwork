//
//  SDFBFriendsParser.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 11/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import Foundation

class FBFriendsParser: BaseParser {

    /**
     Parse object
     
     - Parameter object: That needs to paresed
     - Parameter parseType: Use enum in sepecfic class to class for a particular parse methods. Default value is Zero
     - Parameter completion: call back.
     
     - Throws: nil
     
     - Returns: nil
     */
    
    override func parse(parseType: Int, object: AnyObject?, completion: ParserCompletionCallback!)  {
        guard let response = self.getJson(object) else {
            return  completion(result: nil, error: nil)
        }
        completion(result:  self.parse(response), error: nil)
        
    }
    
    /**
     Parse objcet
     
     - Parameter response : JSON
     - Parameter context: NSManagedObjectContext
     - Throws: nil
     
     - Returns: nil
     */
    
    private func parse(response: JSON) -> [FacebookContact] {
        var contacts = [FacebookContact]()
        
        for buddyInfo in response["data"].array! {
            let buddy = self.parseBuddy(buddyInfo)
            
            contacts.append(buddy)
        }
        return contacts
    }
    
    private func parseBuddy(response: JSON) -> FacebookContact {
        let name = response["name"].stringValue
        let userId = response["id"].stringValue
        let avatarUri = response["picture"]["data"]["url"].stringValue
        
        let contact = FacebookContact()
        contact.name = name
        contact.userId = userId
        contact.avatarUri = avatarUri
        contact.socialNetwork = "Facebook"
        
        return contact
        
    }
}