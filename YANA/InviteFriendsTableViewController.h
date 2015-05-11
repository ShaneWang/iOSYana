//
//  InviteFriendsTableViewController.h
//  YANA
//
//  Created by Shane on 10/21/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealRequest.h"
#import "User.h"

@interface InviteFriendsTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *allFriends;
@property (nonatomic, strong) NSMutableArray *selectedFriends;
@property (nonatomic, strong) MealRequest *mealRequest;
@property (nonatomic, strong) User *user;
@property BOOL mealRequestCreated;
@end
