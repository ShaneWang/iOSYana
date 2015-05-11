//
//  PhoneNumberUserTableViewController.h
//  YANA
//
//  Created by Shane on 11/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface PhoneNumberUserTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)editingChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) User *user;
@property (nonatomic, strong) NSNumber *phoneNumber;
@property (nonatomic, strong) NSNumber *privacy;
@end
