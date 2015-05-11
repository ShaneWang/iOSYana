//
//  UserProfileViewController.h
//  YANA
//
//  Created by Shane on 10/23/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserProfileViewController : UIViewController

@property (strong, nonatomic) User *user;

@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *updateButton;

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodPreferencesLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (strong, nonatomic) IBOutlet UITextField *aboutBox;
@property (strong, nonatomic) IBOutlet UITextField *genderBox;
@property (strong, nonatomic) IBOutlet UITextField *ageBox;
@property (strong, nonatomic) IBOutlet UITextField *foodPreferencesBox;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberBox;

@property (strong, nonatomic) NSNumber *privacy;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *about;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSString *foodPreferences;
@property (strong, nonatomic) NSString *phoneNumber;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedController;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)updateButtonClicked:(id)sender;

@property BOOL clearField;

@end
