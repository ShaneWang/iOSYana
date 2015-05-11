//
//  aboutUserTableViewController.h
//  YANA
//
//  Created by Shane on 11/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface AboutUserTableViewController : UITableViewController
@property (strong, nonatomic) User *user;
@property (nonatomic, strong) NSString *about;
@property (nonatomic, strong) NSNumber *privacy;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UITextField *aboutTextField;
- (IBAction)editingChanged:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
@end
