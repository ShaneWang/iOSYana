//
//  MealRequestDetailTableViewController.m
//  YANA
//
//  Created by Shane on 11/20/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "MealRequestDetailTableViewController.h"
#import "APIHelper.h"

@interface MealRequestDetailTableViewController ()

@end

@implementation MealRequestDetailTableViewController

APIHelper *apiHelper;

- (void)viewDidLoad {
    [super viewDidLoad];
    apiHelper = [[APIHelper alloc] init];
    if (self.isUserMealRequest == NO) {
        self.cancelButton.hidden = YES;
    }
    self.typeLabel.text = self.request.type;
    self.mealRequestOwnerLabel.text = self.request.ownerUsername;
    self.restaurantLabel.text = self.request.restaurant;
    self.commentLabel.text = self.request.comment;
    self.timeLabel.text = self.request.time;
    self.invitedFriend = self.request.acceptedUser;
    self.id = self.request.requestid;
    //NSLog(@"invitedFriend's ID is ........%@", self.invitedFriend);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getFriendPhoneNumber {
    
    NSDictionary *response = [apiHelper getProfile:self.invitedFriend targetid:self.invitedFriend];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            NSDictionary *profile = [response objectForKey:@"profile"];
            self.phoneNumber = [profile objectForKey:@"phone_number"];
            //NSLog(@"phone number is %@", self.phoneNumber);
        }
    }
}

- (void)deleteMealRequestWithID {
    NSDictionary *response = [apiHelper deleteMealRequestWithID:self.id];
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            NSLog(@"meal request deleted");
        }
    }
}

- (IBAction)callButtonPressed:(id)sender {
    [self getFriendPhoneNumber];
    if(self.phoneNumber){
        NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",self.phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
        NSLog(@"phone number called %@", phoneCallNum);
    }else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Call Failed"
                              message:@"No one has accepted your meal request or the friend you are trying to call does not have a phone number."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
   
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self deleteMealRequestWithID];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
