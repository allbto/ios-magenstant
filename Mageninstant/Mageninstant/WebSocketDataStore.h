//
//  WebSocketDataStore.h
//  Mageninstant
//
//  Created by Allan Barbato on 1/18/15.
//  Copyright (c) 2015 Allan Barbato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SRWebSocket.h>

@class User;

@protocol ISocketDataStore <NSObject>

- (void)didReceiveUserList:(NSArray*)users;
- (void)didReceiveMessage:(NSString*)message fromUser:(User*)user;

@end

@interface WebSocketDataStore : NSObject <SRWebSocketDelegate>

+ (WebSocketDataStore*)defaultSocket;

- (void)connectWithUsername:(NSString*)username;
- (void)sendMessage:(NSString*)message toUsername:(NSString*)username;

@property (nonatomic, weak) id<ISocketDataStore> delegate;

@end
