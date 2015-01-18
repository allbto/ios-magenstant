//
//  UserDataStore.h
//  Mageninstant
//
//  Created by Allan Barbato on 1/18/15.
//  Copyright (c) 2015 Allan Barbato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebSocketDataStore.h"

@protocol IUserView;

@interface UserDataStore : NSObject <ISocketDataStore>

@property (nonatomic, weak) id<IUserView> delegate;
@property (nonatomic, strong) NSString* username;

- (void)watchSocket;
- (void)connectWithUsername:(NSString*)username;

@end
