//
//  AgeUserTableViewController.h
//  YANA
//
//  Created by Shane on 11/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface AgeUserTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
- (IBAction)saveButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *slider;
- (IBAction)valueChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSNumber *privacy;
@end
