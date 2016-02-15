//
//  SDInviteFriendsViewController.swift
//  ShreddDemand
//
//  Created by Raza Rabbani on 01/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import UIKit

class SDInviteFriendsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        self.loadContacts()
        super.configureView()
        
        self.initializeSearchController(nil)
    }
 
    override func initializeSearchController(searchResultsController: UIViewController?) {
        super.initializeSearchController(searchResultsController)
        self.searchController!.hidesNavigationBarDuringPresentation = false
    }
    
    // MARK : Table view datasource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController!.active && searchController!.searchBar.text != "" {
            return searchContacts.count
        }
        else {
            return contacts.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "IdentifierContactCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? SDInviteFriendsContactsTableViewCell
        
        self.configureCell(cell!, tableView: tableView, atIndexPath: indexPath)
        
        return cell!
    }

    func configureCell(cell: SDInviteFriendsContactsTableViewCell, tableView: UITableView, atIndexPath indexPath: NSIndexPath) {
        let contact: APContact
        if searchController!.active && searchController!.searchBar.text != "" {
            contact = self.searchContacts[indexPath.row]
        } else {
            contact = contacts[indexPath.row]
        }
        cell.contact = contact
    }
    
    
    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SDInviteFriendsContactsTableViewCell {
            self.showActionSheet(cell.contact)
        }
    }
    
    
    func loadContacts() {
        
        let descriptorFirstName = NSSortDescriptor(key: "name.firstName", ascending: true)
        let descriptorLastNameName = NSSortDescriptor(key: "name.lastName", ascending: true)
        
        self.addressBook.sortDescriptors = [descriptorFirstName, descriptorLastNameName]
        self.addressBook.loadContacts({
            (apContacts: [APContact]?, error: NSError?) in
            if let unwrappedContacts = apContacts {
                self.contacts = unwrappedContacts
                self.tableView.reloadData()
            }
        })
    }
    
    func showActionSheet(contact: APContact) {
        let optionMenu = UIAlertController(title: nil, message: "Send invitation to:", preferredStyle: .ActionSheet)
        
        // sms action
        if let phones = contact.phones {
            for phone in phones  {
                if let phoneNumber =  phone.number {
                    let messageAction = UIAlertAction(title: "\(phoneNumber)", style: .Default, handler: {
                        (alert: UIAlertAction!) -> Void in
                        let phoneNumbers: [String] = [phoneNumber]
                        self.actionHandler.configuredMessageComposeViewController("Hey there, have you tried RAD yet? I think you'd like it. http://www.rad.com/", recipients: phoneNumbers)
                    })
                    optionMenu.addAction(messageAction)
                }
            }
        }
        
        // email action
        if let emails = contact.emails {
            for email in emails  {
                if let emailAddress = email.address {
                    let emailAction = UIAlertAction(title: "\(emailAddress)", style: .Default, handler: {
                        (alert: UIAlertAction!) -> Void in
                        self.actionHandler.configuredMailComposeViewController("Join me on RAD?", mailBody: "Hey there, have you tried RAD yet? I think you'd like it. <br/> http://www.rad.com/", isHTML: true, recipients: nil)
                    })
                    optionMenu.addAction(emailAction)
                }
            }
        }
        
        // cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func filterContentForSearchText(searchText: String) {
        self.searchContacts = self.contacts.filter { (contact) in
            return (contact.name?.compositeName?.lowercaseString.containsString((searchText.lowercaseString))) ?? false
        }
        self.tableView.reloadData()
    }
    
    override func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
