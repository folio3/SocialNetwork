//
//  SDFacebookShareHandler.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 11/01/2016.
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

class FacebookShareHandler {

    enum ShareType: Int {
        case Message, Post
    }
    
    func getShareLink(url: NSURL, text: String?, people: [String]?) -> FBSDKShareLinkContent {
        let content =  FBSDKShareLinkContent()
        content.contentURL = url
        content.peopleIDs = people
        return content
    }
    
    func getShareDialog(url: NSURL, text: String?, people: [String]?) -> FBSDKShareDialog {
        let dialog =  FBSDKShareDialog()
        dialog.shareContent = self.getShareLink(url, text: text, people: people)
        return dialog
    }
    
    func getMessageDialog(url: NSURL, text: String?, people: [String]?) -> FBSDKMessageDialog {
        let dialog =  FBSDKMessageDialog()
        dialog.shareContent = self.getShareLink(url, text: text, people: people)
        return dialog
    }
    
    func shareContent(fromViewController vc: UIViewController!, content:FBSDKSharingContent!) {
        FBSDKShareDialog.showFromViewController(vc, withContent: content, delegate: nil)
    }
    
    func shareContent(type: ShareType, url: NSURL, text: String?, people: [String]?, vc: UIViewController!) {
        if type == .Message {
            let dialog = self.getMessageDialog(url, text: text, people: people)
            if dialog.canShow() {
                dialog.show()
            }
        
        }
        else {
            let content = self.getShareLink(url, text: text, people: people)
            FBSDKShareDialog.showFromViewController(vc, withContent: content, delegate: nil)
        }
    }
    
    
    func inviteFriends(appLink: NSURL, previewImageURL: NSURL?, vc: UIViewController!, delegate: FBSDKAppInviteDialogDelegate?) {
        let content = FBSDKAppInviteContent()
        content.appLinkURL = appLink
        content.appInvitePreviewImageURL = previewImageURL
        
        FBSDKAppInviteDialog.showFromViewController(vc, withContent: content, delegate: delegate)
    }
}