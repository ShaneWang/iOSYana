//
//  RestaurantSearchViewController.h
//  YANA
//
//  Created by Shane on 11/2/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealRequest.h"
#import "User.h"


@interface RestaurantSearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *restaurantSearchBar;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *tableData;

@property (nonatomic, strong) NSMutableArray *restaurants;

@property (nonatomic, strong) NSString *searchTerm;

@property (nonatomic, strong) NSString *selectedRestaurant;

@property (nonatomic, strong) MealRequest *mealRequest;

@property (nonatomic, strong) User *user;

@property (nonatomic, strong) NSMutableArray *imageURLs;

@property (nonatomic,retain) NSIndexPath *checkedIndexPath;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *inviteFriendsButton;

@end
