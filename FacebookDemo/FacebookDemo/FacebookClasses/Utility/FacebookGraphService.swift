//
//  SDFacebookGraphService.swift
//  ShreddDemand
//
//  Created by Kabir on 02/10/2015.
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