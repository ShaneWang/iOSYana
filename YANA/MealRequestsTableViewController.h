//
//  MealRequestsTableViewController.h
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "MealRequest.h"

@interface MealRequestsTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *mealRequestsFromSelf;

@property (nonatomic, strong) NSMutableArray *mealRequestsFromOthers;

@property (nonatomic, strong) User *user;

@property (nonatomic, strong) MealRequest *addedSelfRequest;

@property BOOL isUserMealRequest;

@property (nonatomic, strong) MealRequest *requestSelected;

@end
