//
//  MessageDataStore.h
//  Mageninstant
//
//  Created by Allan Barbato on 1/18/15.
//  Copyright (c) 2015 Allan Barbato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebSocketDataStore.h"

@protocol ISocketDataStore;
@protocol IMessageView;

@interface MessageDataStore : NSObject <ISocketDataStore>

@property (nonatomic, weak) id<IMessageView> delegate;
@property (nonatomic, strong) NSString* username;

- (void)watchSocket;
- (void)sendMessage:(NSString*)message toUsername:(NSString*)username;

@end
