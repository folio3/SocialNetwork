//
//  AlbumTableViewController.swift
//  FacebookDemo
//
//  Created by Hamza Azad on 30/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
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
