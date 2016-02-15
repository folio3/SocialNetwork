//
//  SDInviteFacebookFrirendsViewController.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 08/01/2016.
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

import UIKit

class InviteFacebookFrirendsViewController: UITableViewController {

    private var contacts = [FacebookContact]()
    
    private var actionHandler: InviteSocialNetworkActionHandler?
    
    private lazy var requestHandler: InviteFacebookRequestHandler = {
        return InviteFacebookRequestHandler(viewController: self)
    }()
    
    override func viewDidLoad() {
        self.configureView()
    }
    
    func configureView() {
        self.actionHandler = InviteFacebookActionHandler(vc: self)
        
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
    
    func sendRequest(type: InviteFacebookRequestHandler.RequestType) {
        self.requestHandler.sendRequestWithDelay(type.rawValue, parameters: nil) { (result, error) -> Void in
            if error == nil {
                if self.requestHandler.hasAccessToken() {
                    if let buddies = result as? [FacebookContact] {
                        self.contacts = buddies.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == NSComparisonResult.OrderedAscending }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.actionHandler?.inviteFriends(nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
        
    func objectAtIndexPath(indexPath: NSIndexPath) -> FacebookContact? {
        var contact: FacebookContact?
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