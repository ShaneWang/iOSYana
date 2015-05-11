//
//  UserProfileTableViewController.h
//  YANA
//
//  Created by Shane on 11/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserProfileTableViewController : UITableViewController
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodPreferencesLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *privacyLabel;
@property (strong, nonatomic) NSNumber *privacy;
@property (strong, nonatomic) NSNumber *age;
- (IBAction)logoutClicked:(id)sender;

@end
