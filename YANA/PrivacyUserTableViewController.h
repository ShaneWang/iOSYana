//
//  PrivacyUserTableViewController.h
//  YANA
//
//  Created by Shane on 11/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface PrivacyUserTableViewController : UITableViewController
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSNumber *privacy;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
- (IBAction)saveButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *privacySelector;
- (IBAction)valueChanged:(id)sender;

@end
