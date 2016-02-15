//
//  SDFBProfileParser.swift
//  ShreddDemand
//
//  Created by Kabir on 15/10/2015.
//  Copyright © 2015 Folio3. All rights reserved.
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