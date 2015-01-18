//
//  MessageDataStore.m
//  Mageninstant
//
//  Created by Allan Barbato on 1/18/15.
//  Copyright (c) 2015 Allan Barbato. All rights reserved.
//

#import "MessageDataStore.h"
#import "MessageViewController.h"
#import "User.h"

@implementation MessageDataStore

- (void)watchSocket
{
    [WebSocketDataStore defaultSocket].delegate = self;
}

- (void)sendMessage:(NSString*)message toUsername:(NSString*)username
{
    _username = username;
    [[WebSocketDataStore defaultSocket] sendMessage:message toUsername:username];
}

- (void)didReceiveUserList:(NSArray *)users
{
    //
}

- (void)didReceiveMessage:(NSString*)message fromUser:(User*)user;
{
    if ([user.name isEqualToString:_username])
        [self.delegate didReceiveMessage:message];
}

@end
