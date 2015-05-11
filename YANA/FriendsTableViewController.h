//
//  FriendsTableViewController.h
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface FriendsTableViewController : UITableViewController

@property (nonatomic, strong) User *user;

- (IBAction)unwindFromSearchAndAddFriend:(UIStoryboardSegue *)segue;

- (void)sortFriends;

- (void)updateFriends;

@end
