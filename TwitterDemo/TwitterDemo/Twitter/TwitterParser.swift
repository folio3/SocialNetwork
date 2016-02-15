//
//  SDTwitterParser.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 12/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import Foundation

class TwitterParser {
    
    typealias ParserCompletionCallback = (result: AnyObject?, error: NSError?) -> Void
    
    /**
     Parse object
     
     - Parameter object: That needs to paresed
     - Parameter parseType: Use enum in sepecfic class to class for a particular parse methods. Default value is Zero
     - Parameter completion: call back.
     
     - Throws: nil
     
     - Returns: nil
     */
    
    func parse(parseType: Int, object: AnyObject?, completion: ParserCompletionCallback!)  {
        guard let response = self.getJson(object) else {
            return  completion(result: nil, error: nil)
        }
        
        self.parse(response)
        completion(result: self.parse(response), error: nil)
    }
    
    /**
     Parse objcet
     
     - Parameter response : JSON
     - Parameter context: NSManagedObjectContext
     - Throws: nil
     
     - Returns: nil
     */
    
    private func parse(response: JSON) -> [TwitterContact] {
        var contacts = [TwitterContact]()
        
        for buddyInfo in response.array! {
            let buddy = self.parseBuddy(buddyInfo)
            
            contacts.append(buddy)
        }
        return contacts
    }
    
    private func parseBuddy(response: JSON) -> TwitterContact {
        let name = response["name"].stringValue
        let userId = response["screen_name"].stringValue
        let avatarUri = response["profile_image_url"].stringValue
        
        let contact = TwitterContact()
        contact.name = name
        contact.userId = userId
        contact.avatarUri = avatarUri
        contact.socialNetwork = "Twitter"
        
        return contact
        
    }
    
    func getJson(object: AnyObject?) -> JSON? {
        
        guard let response = object else {
            return nil
        }
        return JSON(response)
    }
    
}

