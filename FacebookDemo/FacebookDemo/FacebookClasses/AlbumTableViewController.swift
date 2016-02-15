//
//  AlbumTableViewController.swift
//  FacebookDemo
//
//  Created by Hamza Azad on 30/01/2016.
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

import UIKit

class AlbumTableViewController: UITableViewController {

    private let parser = FBAlbumParser()
    private var albums = [FacebookAlbum]()
    
    override func viewDidLoad() {
        AppDelegate.facebookHandler.getUserAlbums(1, pageId: nil, pageType: .Next) { (result, error) -> Void in
            self.parser.parse(FBAlbumParser.ParseType.Albums.rawValue, object: result, completion: { (result, error) -> Void in
                if let albums = result as? [FacebookAlbum] {
                    self.albums = albums.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == NSComparisonResult.OrderedAscending }
                }
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> FacebookAlbum? {
        var album: FacebookAlbum?
        album = self.albums[indexPath.row]
        return album
    }
    
    // MARK: Table view datasource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "albumCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        let album = self.objectAtIndexPath(indexPath)
        
        cell?.textLabel?.text = album!.name
        
        return cell!
    }
    
}
