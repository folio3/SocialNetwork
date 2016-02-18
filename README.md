# SocialNetwork
iOS Swift helper library that provides integration with Facebook and Twitter

## Features

### Facebook

- [x] Sign in
- [x] Friends
- [x] Invite
- [x] Taggable friends
- [x] Albums/Photos
- [x] Share
 
### Twitter

- [x] Sign in
- [x] Friends
- [x] Invite
 
## Usage

### Facebook

```swift
private lazy var requestHandler: InviteFacebookRequestHandler = {
        return InviteFacebookRequestHandler(viewController: self)
    }()
```
> Create a request handler in your class as shown above.

```swift
func sendRequest(type: InviteFacebookRequestHandler.RequestType) {
        self.requestHandler.sendRequestWithDelay(type.rawValue, parameters: nil) { (result, error) -> Void in
            if error == nil {
                if self.requestHandler.hasAccessToken() {
                    if let buddies = result as? [FacebookContact] {
                        self.contacts = buddies.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == NSComparisonResult.OrderedAscending }
                    }
                    // reload table view
                }
            }
        }
    }
```

#### Login
```swift
self.sendRequest(.Login)
```

#### Friends
```swift
self.sendRequest(.Friends)
```

#### Invite
```swift
self.sendRequest(.Invite)
```

### Albums
```swift
static let facebookHandler = FacebookHandler()
```

```swift
facebookHandler.getUserAlbums(1, pageId: nil, pageType: .Next) { (result, error) -> Void in
            self.parser.parse(FBAlbumParser.ParseType.Albums.rawValue, object: result, completion: { (result, error) -> Void in
                if let albums = result as? [FacebookAlbum] {
                    self.albums = albums.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == NSComparisonResult.OrderedAscending }
                }
                // reload table view
            })
        }
```

### Twitter

```swift
lazy var requestHandler: InviteTwitterRequestHandler = {
        return InviteTwitterRequestHandler(viewController: self)
    }()
```
> Create a request handler in your class as shown above.

```swift
func sendRequest(type: InviteSocialNetworkRequestHandler.RequestType) {
        self.requestHandler.sendRequestWithDelay(type.rawValue, parameters: nil) { (result, error) -> Void in
            if error == nil {
                if let buddies = result as? [TwitterContact] {
                    self.contacts = buddies.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == NSComparisonResult.OrderedAscending }
                }
                // reload table view
            }
        }
    }
```

#### Login
```swift
self.sendRequest(.Login)
```

#### Friends
```swift
self.sendRequest(.Friends)
```

### Invite
```swift
override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var actionHandler = InviteTwitterActionHandler(vc: self)
    var contact: TwitterContact?
    contact = self.contacts[indexPath.row]
    actionHandler?.inviteFriends(contact)
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
}

```

## Credits

SocialNetwork is owned and maintained by [Folio3 Pvt Ltd](http://www.folio3.com/). You can follow them on Twitter at [@folio_3](https://twitter.com/folio_3) for project updates and releases.

## License

SocialNetwork is released under the MIT license. See LICENSE for details.
