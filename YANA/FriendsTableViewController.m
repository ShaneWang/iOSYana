//
//  FriendsTableViewController.m
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "AppDelegate.h"
#import "APIHelper.h"
#import "Friend.h"
#import "AddFriendTableViewCell.h"
#import "InviteFriendTableViewCell.h"
#import "SearchAndAddFriendNavigationController.h"
#import "SearchAndAddFriendViewController.h"
#import "UserProfileViewController.h"
#import "FriendProfileViewController.h"
#import "MealRequestsTableViewController.h"
#import "InviteFriendsTableViewController.h"
#import "MealRequestsNavigationController.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

static NSString * const addFriendCellIdentifier = @"addFriendCell";
static NSString * const inviteFriendCellIdentifier = @"inviteFriendCell";

APIHelper *apiHelper;

#pragma mark - Segue

- (IBAction)unwindFromSearchAndAddFriend:(UIStoryboardSegue *)segue {
    [self updateFriends];
}

- (IBAction)unwindFromCreateMealRequest:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"exitFromInviteFriends"]) {
        //update meal request table view with new meal request
        InviteFriendsTableViewController *source = [segue sourceViewController];
        if (source.mealRequestCreated && source.mealRequest) {
            //switch to meal requests tab
            self.tabBarController.selectedIndex = 0;
            MealRequestsNavigationController *requestTab = [self.tabBarController.childViewControllers objectAtIndex:0];
            MealRequestsTableViewController *requestTabView = (MealRequestsTableViewController *)requestTab.topViewController;
            [requestTabView.mealRequestsFromSelf addObject:source.mealRequest];
            [requestTabView.tableView reloadData];
        }else{
            NSLog(@"meal request is null");
        }
    }else if([segue.identifier isEqualToString:@"exitFromCreateMealRequest"]) {
        //clear friend selection
        for(Friend *friend in self.user.friends){
            friend.selected = NO;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue for %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"openSearchAndAddFriend"]) {
        SearchAndAddFriendNavigationController *destViewController = segue.destinationViewController;
        destViewController.hidesBottomBarWhenPushed = YES;
    }else if([segue.identifier isEqualToString:@"openUserProfile"]) {
        UserProfileViewController *destViewController = segue.destinationViewController;
        destViewController.hidesBottomBarWhenPushed = YES;
    }else if([segue.identifier isEqualToString:@"inviteToMealRequest"]) {
        
    }
}

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserWithSortedFriends];
    apiHelper = [[APIHelper alloc] init];
    
    //fix UI warning messages
    self.tableView.rowHeight = 44;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    //for testing purposes
    [self.tableView setIsAccessibilityElement:YES];
    [self.tableView setAccessibilityLabel:@"Friend List"];
    
    // Initialize the refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor redColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshFriendList)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeUserWithSortedFriends {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = ad.user;
    [self sortFriends];
}

#pragma mark - Friend List Management

//update friends in this view controller only
- (void)updateFriends{
    [self initializeUserWithSortedFriends];
    [self.tableView reloadData];
}

- (void)sortFriends{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendUsername" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    //sort alphabetically
    NSArray *sortedArray;
    sortedArray = [self.user.friendsWhoAddedYou sortedArrayUsingDescriptors:sortDescriptors];
    [self.user.friendsWhoAddedYou removeAllObjects];
    [self.user.friendsWhoAddedYou addObjectsFromArray:sortedArray];
    
    sortedArray = [self.user.friends sortedArrayUsingDescriptors:sortDescriptors];
    [self.user.friends removeAllObjects];
    [self.user.friends addObjectsFromArray:sortedArray];
}

//update friends to global user object
- (void) saveFriends{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.user = self.user;
}

- (void)refreshFriendList {
    [self getAllFriends];
    [self getFriendsWhoAddedYou];
    [self updateFriends];
    [self.refreshControl endRefreshing];
}

- (void)getAllFriends{
    self.user.friends = [[NSMutableArray alloc] init];
    
    NSDictionary *response = [apiHelper getFriendList:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            NSArray *friends = [response objectForKey:@"friends"];
            
            for(NSDictionary *friend in friends){
                Friend *f = [[Friend alloc] initWithid:friend[@"to_id"] andUsername:friend[@"to_username"]];
                [self.user.friends addObject:f];
            }
            
            [self saveFriends];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Server Error"
                                  message:@"Get all friends failed. Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Get all friends failed. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)getFriendsWhoAddedYou{
    self.user.friendsWhoAddedYou = [[NSMutableArray alloc] init];
    
    NSDictionary *response = [apiHelper getFriendRequests:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            NSArray *friends = [response objectForKey:@"friends"];
            
            for(NSDictionary *friend in friends){
                Friend *f = [[Friend alloc] initWithid:friend[@"from_id"] andUsername:friend[@"from_username"]];
                [self.user.friendsWhoAddedYou addObject:f];
            }
            
            [self saveFriends];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Server Error"
                                  message:@"Can't get friends who added you. Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Can't get friends who added you. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.user.friends count] || [self.user.friendsWhoAddedYou count]) {
        //clear empty message
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        if(section == 0)
            return [self.user.friendsWhoAddedYou count];
        else if(section == 1)
            return [self.user.friends count];
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No friends found.\nPlease add friends by\npressing the \"+\" button.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        if([self.user.friendsWhoAddedYou count]){
            return @"Friends Who Added You";
        }else{
            return nil;
        }
    }
    if(section == 1){
        return @"All Friends";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        AddFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addFriendCellIdentifier forIndexPath:indexPath];
        
        Friend *friend = self.user.friendsWhoAddedYou[indexPath.row];
        
        [cell.friendUsername setText:friend.friendUsername];
        
        cell.addButton.tag = indexPath.row;
        [cell.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //for testing purposes
        [cell setAccessibilityLabel:[NSString stringWithFormat:@"Section %ld Row %ld", (long)indexPath.section, (long)indexPath.row]];
        return cell;
    }else{
        InviteFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteFriendCellIdentifier forIndexPath:indexPath];
        
        Friend *friend = self.user.friends[indexPath.row];
        [cell.friendUsername setText:friend.friendUsername];
        
        cell.inviteButton.tag = indexPath.row;
        [cell.inviteButton addTarget:self action:@selector(inviteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //for testing purposes
        [cell setAccessibilityLabel:[NSString stringWithFormat:@"Section %ld Row %ld", (long)indexPath.section, (long)indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Friend *selectedFriend;
    if(indexPath.section == 0){
        selectedFriend = self.user.friendsWhoAddedYou[indexPath.row];
    }else{
        selectedFriend = self.user.friends[indexPath.row];
    }
    FriendProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendViewController"];
    if(selectedFriend){
        viewController.targetid = selectedFriend.friendid;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Can't open friend profile. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

// Enable swipe to delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

BOOL deleted = NO;

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if(indexPath.section == 0){
            [self.user.friendsWhoAddedYou removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else if(indexPath.section == 1){
            Friend *friend = self.user.friends[indexPath.row];
            [self deleteFriend:friend];
            if(deleted){
                [self.user.friends removeObject:friend];
                deleted = NO;
            }
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - Actions

- (IBAction)addButtonClicked:(UIButton *)sender {
    Friend *friend = self.user.friendsWhoAddedYou[sender.tag];
    
    //update server
    NSDictionary *response = [apiHelper addFriend:friend.friendid toYou:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            [self.user.friendsWhoAddedYou removeObject:friend];
            [self.user.friends addObject:friend];
            [self saveFriends];
            [self.tableView reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Server Error"
                                  message:@"Add friend failed. Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Add friend failed. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)inviteButtonClicked:(UIButton *)sender {
    Friend *friend = self.user.friends[sender.tag];
    friend.selected = YES;
}

- (void)deleteFriend:(Friend *)friend {
    //update server
    NSDictionary *response = [apiHelper deleteFriend:friend.friendid fromYou:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            deleted = YES;
            [self.user.friends removeObject:friend];
            [self saveFriends];
            [self.tableView reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Server Error"
                                  message:@"Delete friend failed. Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Delete friend failed. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
