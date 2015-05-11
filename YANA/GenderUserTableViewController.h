//
//  GenderUserTableViewController.h
//  YANA
//
//  Created by Shane on 11/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface GenderUserTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
- (IBAction)saveButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderSelector;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) User *user;
- (IBAction)valueChanged:(id)sender;
@property (strong, nonatomic) NSNumber *privacy;
@end
