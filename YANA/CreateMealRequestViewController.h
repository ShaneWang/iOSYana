//
//  CreateMealRequestViewController.h
//  YANA
//
//  Created by Shane on 10/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "MealRequest.h"

@interface CreateMealRequestViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *typeButtons;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) IBOutlet UITextField *restaurantTextBox;
@property (strong, nonatomic) NSString *restaurant;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) MealRequest *mealRequest;
@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UITextField *commentTextBox;

@end
