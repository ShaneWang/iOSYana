//
//  FoodPreferencesUserTableViewController.m
//  YANA
//
//  Created by Shane on 11/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "FoodPreferencesUserTableViewController.h"
#import "APIHelper.h"
#import "User.h"
#import "AppDelegate.h"
@interface FoodPreferencesUserTableViewController ()

@end

@implementation FoodPreferencesUserTableViewController
APIHelper *apiHelper;
- (void)viewDidLoad {
    [super viewDidLoad];
    apiHelper = [[APIHelper alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initializeUser];
    self.saveButton.enabled = NO;
    if (!self.foodPreferences || [self.foodPreferences isEqualToString:@""]) {
        self.foodPreferencesTextField.placeholder = @"(None)";
    } else {
        self.foodPreferencesTextField.text = self.foodPreferences;
    }
    self.foodPreferencesTextField.keyboardType = UIKeyboardTypeDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeUser{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
}

- (IBAction)saveButtonPressed:(id)sender {
    NSDictionary *response = [apiHelper editProfile:self.user.userid withPrivacy:self.privacy  about:nil gender:nil age:nil foodPreferences:self.foodPreferencesTextField.text phoneNumber:nil];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Server Error"
                                  message:@"Update failed. Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Connection Error"
                              message:@"Update failed. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editingChanged:(id)sender {
    self.saveButton.enabled = YES;
}
@end
