//
//  SDFBProfileParser.swift
//  ShreddDemand
//
//  Created by Kabir on 15/10/2015.
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

class FBProfileParser: BaseParser {
    
    /**
    Parse objet
    
    - Parameter object: That needs to paresed
    - Parameter parseType: Use enum in sepecfic class to class for a particular parse methods. Default value is Zero
    - Parameter completion: call back.
    
    - Throws: nil
    
    - Returns: nil
    */
    
    override func parse(parseType: Int, object: AnyObject?, completion: ParserCompletionCallback!) {
        guard let response = self.getJson(object) else {
            return  completion(result: nil, error: nil)
        }
        
        completion(result: self.parseUserProfile(response), error: nil)
    }

    func parseUserProfile(response: JSON) -> FacebookUserProfile {
        let birthday = response["profile"]["birthday"].stringValue
        let email = response["profile"]["email"].stringValue
        let gender = response["profile"]["gender"].stringValue
        let name = response["profile"]["name"].stringValue
        let firstName = response["profile"]["first_name"].stringValue
        let lastName = response["profile"]["last_name"].stringValue
        let userId = response["profile"]["id"].numberValue
        let uri = response["profile"]["picture"]["data"]["url"].stringValue

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.dateFromString(birthday)
        
        let profile = FacebookUserProfile()
        
        profile.firstName = firstName
        profile.lastName = lastName
        profile.name = name
        profile.birthday = date
        profile.gender = gender
        profile.userId = userId
        profile.email = email
        profile.socialNetworkAvatarUri = uri
        
//        let socialNetwork = self.parseSocialNetwork(response)
//        socialNetwork.addUserProfile(profile)
//        profile.addSocialNetwork(socialNetwork)
        
        return profile
    }

//    override func parseSocialNetwork(response: JSON) -> SocialNetwork {
//        
//        let appId = response["app_id"].stringValue
//        let identifier = SDBalConstants.SocialNetwork.Facebook.hashValue
//        let name = SDBalConstants.SocialNetwork.Facebook.rawValue
//
//        let network = SocialNetwork.MR_findFirstOrCreateByAttribute("identifier", withValue: identifier, inContext: context)
//        network.appId = appId
//        network.identifier = identifier
//        network.name = name
//        
//        return network
//    }
}