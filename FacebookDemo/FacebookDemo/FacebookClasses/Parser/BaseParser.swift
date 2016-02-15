//
//  SDBaseParser.swift
//  ShreddDemand
//
//  Created by Kabir on 15/10/2015.
//  Copyright © 2015 Folio3. All rights reserved.
//

import Foundation

class BaseParser {

    typealias ParserCompletionCallback = (result: AnyObject?, error: NSError?) -> Void
    
    func getJson(object: AnyObject?) -> JSON? {
    
        guard let response = object else {
            return nil
        }
        return JSON(response)
    }
    
    /**
    Parse object
    
    - Parameter object: That needs to paresed
    - Parameter ParseType: Use enum in sepecfic class to class for a particular parse methods. Default value is Zero
    - Parameter completion: call back.
    
    - Throws: nil
    
    - Returns: nil
    */
    
    func parse(parseType: Int, object: AnyObject?, completion: ParserCompletionCallback!) {
        // Overrid this method
    }
    
    /**
    Parse page info
    
    - Parameter response: json object
    
    - Throws: nil
    
    - Returns: Page info
    */
    func parsePageInfo(response: JSON) -> [String: NSNumber?] {
        let info = response["meta"]["pagination"]
        
        let currentPage = info["current_page"].number
        let limit = info["per_page"].number
        let totoalPages = info["total_pages"].number
        let recordCount = info["count"].number

        let pageInfo = ["currentPage": currentPage, "limit": limit, "totoalPages": totoalPages, "recordCount": recordCount]
        
        return pageInfo
    }

}