//
//  SDFacebookShareHandler.swift
//  ShreddDemand
//
//  Created by Kabir Khan on 11/01/2016.
//  Copyright © 2016 Folio3. All rights reserved.
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