//
//  SDInviteTwitterFriendsViewController.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 08/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import UIKit

class InviteTwitterFriendsViewController: UITableViewController {
    
    var contacts = [TwitterContact]()
    
    var actionHandler: InviteSocialNetworkActionHandler?
    
    lazy var requestHandler: InviteTwitterRequestHandler = {
        return InviteTwitterRequestHandler(viewController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actionHandler = InviteTwitterActionHandler(vc: self)
        
        if self.requestHandler.hasAccessToken() {
            self.sendRequest(.Friends)
        }
        else {
            self.connect()
        }
    }
    
    func connect() {
        self.sendRequest(.Login)
    }
    
    func sendRequest(type: InviteSocialNetworkRequestHandler.RequestType) {
        self.requestHandler.sendRequestWithDelay(type.rawValue, parameters: nil) { (result, error) -> Void in
            if error == nil {
                if let buddies = result as? [TwitterContact] {
                    self.contacts = buddies.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == NSComparisonResult.OrderedAscending }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.actionHandler?.inviteFriends([self.objectAtIndexPath(indexPath)!])
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> TwitterContact? {
        var contact: TwitterContact?
        contact = self.contacts[indexPath.row]
        return contact
    }
    
    // MARK: Table view datasource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "defaultCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        let contact = self.objectAtIndexPath(indexPath)
        
        cell?.textLabel?.text = contact!.name
        
        return cell!
    }
    
}