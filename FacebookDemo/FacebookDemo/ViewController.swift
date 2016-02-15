//
//  ViewController.swift
//  FacebookDemo
//
//  Created by Hamza Azad on 30/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let parser = FBProfileParser()
    
    @IBOutlet weak var lblText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func login() {
        AppDelegate.facebookHandler.logout()
        AppDelegate.facebookHandler.loginFromViewController(self, completion: { (result, error, cancelled) -> Void in
            if var info = result as? [String: AnyObject] {

                AppDelegate.facebookHandler.getUserProfile({ (result, error) -> Void in
                    if let profileInfo = result {
                        info["profile"] = profileInfo
                        self.parser.parse(0, object: info, completion: { (result, error) -> Void in
                            if error == nil {
                                self.lblText.text = "You are logged in as \((result as! FacebookUserProfile).name)"
                            }
                        })
                    }
                })
            }
        })
    }

    @IBAction func logout() {
        AppDelegate.facebookHandler.logout()
    }

}

