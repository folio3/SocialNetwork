//
//  SDFBAlbumParser.swift
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

class FBAlbumParser: BaseParser {

    enum ParseType: Int {
        case Albums, AlbumPhotos
    }
    
    /**
    Parse objet
    
    - Parameter object: That needs to paresed
    - Parameter parseType: Use enum in sepecfic class to class for a particular parse methods. Default value is Zero
    - Parameter completion: call back.
    
    - Throws: nil
    
    - Returns: nil
    */
    
    override func parse(parseType: Int, object: AnyObject?, completion: ParserCompletionCallback!) {
        if let type = ParseType(rawValue: parseType) {
            switch type {
                
            case .Albums:
                self.parseAlbums(object, completion: completion)
            case .AlbumPhotos:
                self.parsePhotos(object, completion: completion)
            }
        }

    }
    
    private func parseAlbums(object: AnyObject?, completion: ParserCompletionCallback!) {
        
        guard let response = self.getJson(object) else {
            return  completion(result: nil, error: nil)
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        
        var albums = [FacebookAlbum]()
        for info in response["data"].arrayValue {
            
            let identifier = NSNumber(longLong: Int64(info["id"].stringValue)!)
            let name =  info["name"].stringValue
            let createdTime = info["created_time"].stringValue
            let count  = info["count"].number
            let avartarUri  = info["picture"]["data"]["url"].stringValue
            
            let album = FacebookAlbum()
            album.identifier = identifier
            album.name = name
            album.created = dateFormatter.dateFromString(createdTime)
            album.count = count!
            album.avatarUri = avartarUri
            
            albums.append(album)
        }
        
        completion(result: albums, error: nil)
    }
    
    private func parsePhotos(object: AnyObject?, completion: ParserCompletionCallback!) {
        
        guard let response = self.getJson(object) else {
            return  completion(result: nil, error: nil)
        }
        
        var photos = [FacebookPhoto]()
        for info in response["result"]["data"].arrayValue {
            let photo = self.parsePhoto(info)
            photos.append(photo)
        }
        
        completion(result: photos, error: nil)
    }
    
    private func parsePhoto(info: JSON) -> FacebookPhoto {
        let identifier = NSNumber(longLong: Int64(info["id"].stringValue)!)
        let avartarUri  = info["picture"].stringValue

        let photo = FacebookPhoto()
        
        photo.identifier = identifier
        photo.avatarUri = avartarUri
        
        for image in info["images"].arrayValue {
            self.parseImage(image, photo: photo)
        }
        
        return photo
    }
    
    private func parseImage(info: JSON, photo: FacebookPhoto) {
        let sourceUri = info["source"].stringValue
        let width =  info["width"].number
        let height = info["height"].number
        
        let image = Image()
        image.sourceUri = sourceUri
        image.width = width!
        image.height = height!
        
        photo.addImage(image)
        image.photo = photo
    }
    
    private func parsePageInfo(object: AnyObject?) -> [String: String]? {
    
        guard let response = self.getJson(object) else {
            return nil
        }
    
        let previous =  response["paging"]["cursors"]["before"].stringValue
        let next =  response["paging"]["cursors"]["after"].stringValue
        
        return ["next": next, "previous": previous]
    }

}