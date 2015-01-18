//
//  UserTableViewController.h
//  Mageninstant
//
//  Created by Allan Barbato on 1/18/15.
//  Copyright (c) 2015 Allan Barbato. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IUserView <NSObject>

- (void)userConnected;
- (void)failToConnectUser;

- (void)foundListOfUser:(NSArray*)users;
- (void)unableToFindListOfUser;

@end

@interface UserTableViewController : UITableViewController <IUserView, UIAlertViewDelegate>

@end