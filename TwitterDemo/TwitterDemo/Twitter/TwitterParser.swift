//
//  SDTwitterParser.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 12/01/2016.
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

