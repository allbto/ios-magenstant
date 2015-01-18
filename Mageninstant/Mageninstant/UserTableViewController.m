//
//  UserTableViewController.m
//  Mageninstant
//
//  Created by Allan Barbato on 1/18/15.
//  Copyright (c) 2015 Allan Barbato. All rights reserved.
//

#import "UserTableViewController.h"
#import "MessageViewController.h"
#import "UserDataStore.h"
#import "User.h"

static NSString* UserCellIdentifier = @"UserCellIdentifier";

@interface UserTableViewController ()

@property (nonatomic, strong) NSArray* users;
@property (nonatomic, strong) User* user;

@property (nonatomic, strong) UserDataStore* dataStore;

@end

@implementation UserTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataStore = [UserDataStore new];
    _dataStore.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_dataStore watchSocket];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString* username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    
    if ([username length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Username" message:@"Enter your username:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView show];
    }
    else
    {
        [self _connectWithUserName:username];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString* username = [[alertView textFieldAtIndex:0] text];

        [self _connectWithUserName:username];
        [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username"];
    }
}

- (void)_connectWithUserName:(NSString*)username
{
    _user = [User new];
    _user.name = username;
    [_dataStore connectWithUsername:username];
    self.title = @"Friends";
}

/// TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:UserCellIdentifier];
    User* user = nil;
    
    if (_users.count > indexPath.row && (user = [_users objectAtIndex:indexPath.row]))
    {
        cell.textLabel.text = user.name;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self performSegueWithIdentifier:@"messageViewController" sender:self];
}

/// Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier  );
    
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];

    if ([segue.identifier isEqualToString:@"messageViewController"] && _users.count > path.row)
    {
        MessageViewController *messageViewController = segue.destinationViewController;
        messageViewController.mainUser = _user;
        messageViewController.user = [_users objectAtIndex:path.row];
    }
    [self.tableView deselectRowAtIndexPath:path animated:YES];
}

/// IUserView

- (void)userConnected
{
    //
}

- (void)failToConnectUser
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (void)foundListOfUser:(NSArray*)users
{
    self.users = users;
    [self.tableView reloadData];
}

- (void)unableToFindListOfUser
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot update list of users" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

@end
