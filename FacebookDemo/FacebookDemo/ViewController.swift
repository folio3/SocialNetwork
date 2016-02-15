//
//  ViewController.swift
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

