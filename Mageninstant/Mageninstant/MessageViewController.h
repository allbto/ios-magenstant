//
//  MessageViewController.h
//  Mageninstant
//
//  Created by Allan Barbato on 1/18/15.
//  Copyright (c) 2015 Allan Barbato. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import <JSQMessagesViewController/JSQMessages.h>

@class User;

@protocol IMessageView <NSObject>

- (void)didReceiveMessage:(NSString*)message;

@end

@interface MessageViewController : JSQMessagesViewController <IMessageView>

@property (nonatomic, retain) User* mainUser;
@property (nonatomic, retain) User* user;

@end
