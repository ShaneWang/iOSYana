//
//  GenderUserTableViewController.m
//  YANA
//
//  Created by Shane on 11/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "GenderUserTableViewController.h"
#import "APIHelper.h"
#import "User.h"
#import "AppDelegate.h"

@interface GenderUserTableViewController ()

@end

@implementation GenderUserTableViewController
APIHelper *apiHelper;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.gender isEqualToString:@"male"]){
        self.genderSelector.selectedSegmentIndex = 0;
    } else if ([self.gender isEqualToString:@"female"]){
        self.genderSelector.selectedSegmentIndex = 1;
    } else if ([self.gender isEqualToString:@"other"]){
        self.genderSelector.selectedSegmentIndex = 2;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initializeUser];
    self.saveButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeUser{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
}

- (IBAction)saveButtonClicked:(id)sender {
    if (self.genderSelector.selectedSegmentIndex == 0) {
          self.gender = @"male";
    } else if (self.genderSelector.selectedSegmentIndex == 1) {
        self.gender = @"female";
    } else if (self.genderSelector.selectedSegmentIndex == 2) {
        self.gender = @"other";
    }
    
    NSDictionary *response = [apiHelper editProfile:self.user.userid withPrivacy:self.privacy  about:nil gender:self.gender age:nil foodPreferences:nil phoneNumber:nil];
    
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
- (IBAction)valueChanged:(id)sender {
    self.saveButton.enabled = YES;
}
@end
