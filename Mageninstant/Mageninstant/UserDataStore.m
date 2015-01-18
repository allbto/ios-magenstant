//
//  UserDataStore.m
//  Mageninstant
//
//  Created by Allan Barbato on 1/18/15.
//  Copyright (c) 2015 Allan Barbato. All rights reserved.
//

#import "UserDataStore.h"
#import "UserTableViewController.h"
#import "User.h"


@interface UserDataStore ()

@end

@implementation UserDataStore

- (void)watchSocket
{
    [WebSocketDataStore defaultSocket].delegate = self;
}

- (void)connectWithUsername:(NSString*)username
{
    [[WebSocketDataStore defaultSocket] connectWithUsername:username];
}

/// WebSocket

- (void)didReceiveUserList:(NSArray *)users
{
    [self.delegate foundListOfUser:users];
}

- (void)didReceiveMessage:(NSString *)message fromUser:(User *)user
{
    //
}

@end
