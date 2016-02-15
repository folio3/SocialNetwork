//
//  SDFacebookGraphService.swift
//  ShreddDemand
//
//  Created by Kabir on 02/10/2015.
//  Copyright © 2015 Folio3. All rights reserved.
//

import Foundation

class FacebookGraphService: NSObject {
    
    typealias FBGCompletionCallback  = (result: AnyObject?, error: NSError?) -> Void
    
    internal enum FBGraphServicePageType: Int {
        case Next, Pervious
    }
    
    /**
    send facebook graph request
    
    - Parameter graphPath: path of facebook
    - Parameter parameters: key value for parameters
    - Parameter completion: call back
    
    - Throws: nil
    
    - Returns: nil
    */
    
    func sendRequest(graphPath: String!, parameters: [NSObject : AnyObject]!, completion: FBGCompletionCallback!) {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: parameters)
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            completion(result: result, error: error)
        }
    }
    
    /**
    send facebook graph request page vise
    
    - Parameter graphPath: path of facebook
    - Parameter parameters: key value for parameters
    - Parameter completion: call back
    - Parameter limit: Optional parameter to allow pagging, max results per request
    - Parameter pageId: Optional parameter requested page Id
    - Parameter pageType: parameter to get previous or next page

    - Throws: nil
    
    - Returns: nil
    */
    
    func sendRequest(graphPath: String!, parameters: [NSObject : AnyObject]!, limit: Int?, pageId: String?, pageType: FBGraphServicePageType, completion: FBGCompletionCallback!) {

        var params = parameters
        if (limit != nil) {
            params["limit"] = "\(limit!)"
            
            switch pageType {
                case .Next:
                 params["after"] = pageId
            case .Pervious:
                params["before"] = pageId
            }
        }
        
        self.sendRequest(graphPath, parameters: params, completion: completion)
    }
    
    /**
    send normal HTPP request via NSURLSession
    
    - Parameter url: file url
    - Parameter completion: call back 
    
    - Throws: nil
    
    - Returns: nil
    */
    func sendRequest(url: NSURL, completion: FBGCompletionCallback!) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, resonse, error) -> Void in
            completion( result: data, error: error)
        }
        
        task.resume()
    }
}