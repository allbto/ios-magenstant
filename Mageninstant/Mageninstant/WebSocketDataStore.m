//
//  WebSocketDataStore.m
//  Mageninstant
//
//  Created by Allan Barbato on 1/18/15.
//  Copyright (c) 2015 Allan Barbato. All rights reserved.
//

#import "WebSocketDataStore.h"
#import <SRWebSocket.h>
#import "User.h"

@interface WebSocketDataStore ()

@property (nonatomic, strong) SRWebSocket* ws;
@property (nonatomic, strong) NSMutableArray* requestsBeforeOpen;

@end

@implementation WebSocketDataStore

+ (WebSocketDataStore*)defaultSocket
{
    static dispatch_once_t token;
    static WebSocketDataStore* socket;
    
    dispatch_once(&token, ^{
        socket = [WebSocketDataStore new];
    });

    return socket;
}

- (id)init
{
    if ((self = [super init]))
    {
        NSString *urlString = @"ws://localhost:5050/ws";
        _ws = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
        _ws.delegate = self;
        [_ws open];
        _requestsBeforeOpen = [NSMutableArray new];
    }
    return self;
}

- (void)connectWithUsername:(NSString*)username
{
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:@{
                                                                  @"msg_type" : @"connection",
                                                                  @"username" : username
                                                                  } options:0 error:&err];
    [_requestsBeforeOpen addObject:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
}

- (void)sendMessage:(NSString*)message toUsername:(NSString*)username
{
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:@{
                                                                  @"msg_type" : @"message",
                                                                  @"username" : username,
                                                                  @"content" : message
                                                                  } options:0 error:&err];
    [_ws send:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    for (NSString* request in _requestsBeforeOpen)
    {
        [_ws send:request];
    }
    [_requestsBeforeOpen removeAllObjects];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([[json objectForKey:@"msg_type"] isEqualToString:@"update_clients"])
    {
        NSArray* clients = [json objectForKey:@"clients"];
        NSMutableArray* clientList = [NSMutableArray new];
        
        for (NSString* client in clients)
        {
            User* user = [User new];
            user.name = client;
            [clientList addObject:user];
        }
        [self.delegate didReceiveUserList:clientList];
    }
    else if ([[json objectForKey:@"msg_type"] isEqualToString:@"message"])
    {
        User* user = [User new];
        user.name = [json objectForKey:@"from"];
        [self.delegate didReceiveMessage:[json objectForKey:@"content"] fromUser:user];
    }
}

@end
