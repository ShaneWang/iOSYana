//
//  FriendProfileViewController.h
//  YANA
//
//  Created by Gavin Chu on 11/5/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Friend.h"

@interface FriendProfileViewController : UIViewController

@property (nonatomic, strong) NSString* targetid; //id of profile viewed
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Friend *currentFriend;
@property (nonatomic) BOOL removed;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodPreferencesLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *genderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodPreferencesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberTitleLabel;

@end
