//
//  PhoneNumberUserTableViewController.m
//  YANA
//
//  Created by Shane on 11/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "PhoneNumberUserTableViewController.h"
#import "APIHelper.h"
#import "User.h"
#import "AppDelegate.h"
@interface PhoneNumberUserTableViewController ()

@end

@implementation PhoneNumberUserTableViewController
APIHelper *apiHelper;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initializeUser];
    self.saveButton.enabled = NO;
    if (!self.phoneNumber || [self.phoneNumber intValue] == 0) {
        self.phoneNumberTextField.placeholder = @"(Not specified)";
    } else {
        self.phoneNumberTextField.text = [NSString stringWithFormat:@"%@",self.phoneNumber];
    }
    self.saveButton.enabled = NO;
    self.phoneNumberTextField.keyboardType = UIKeyboardTypeDecimalPad;
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
    NSDictionary *response = [apiHelper editProfile:self.user.userid withPrivacy:self.privacy  about:nil gender:nil age:nil foodPreferences:nil phoneNumber:self.phoneNumberTextField.text];
    
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
