//
//  MessageViewController.m
//  Mageninstant
//
//  Created by Allan Barbato on 1/18/15.
//  Copyright (c) 2015 Allan Barbato. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageDataStore.h"
#import "User.h"
#import "DemoModelData.h"

@interface MessageViewController ()

@property (nonatomic, strong) MessageDataStore* dataStore;
@property (nonatomic, strong) NSMutableArray* messages;
@property (strong, nonatomic) DemoModelData *demoData;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.demoData = [[DemoModelData alloc] init];
    
    _dataStore = [MessageDataStore new];
    _dataStore.delegate = self;
    
    _messages = [NSMutableArray new];
    
    self.title = _user.name;

    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.senderId = [_mainUser.name stringByAppendingString:@"_MAIN_USER"];
    self.senderDisplayName = _mainUser.name;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_dataStore watchSocket];
}

/// JSQMessages

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    [_messages addObject:message];
    [_dataStore sendMessage:text toUsername:_user.name];
    [self finishSendingMessageAnimated:YES];
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _messages.count;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [_messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.demoData.outgoingBubbleImageData;
    }
    
    return self.demoData.incomingBubbleImageData;
}

/// IMessageView

- (void)didReceiveMessage:(NSString*)message
{
    JSQMessage *msg = [[JSQMessage alloc] initWithSenderId:_user.name
                                             senderDisplayName:_user.name
                                                          date:[NSDate date]
                                                          text:message];
    [_messages addObject:msg];
    [self.collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
