//
//  MealRequestsTableViewController.m
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "MealRequestsTableViewController.h"
#import "AppDelegate.h"
#import "APIHelper.h"
#import "MealRequestWithButtonsTableViewCell.h"
#import "MealRequestWithoutButtonsTableViewCell.h"
#import "CreateMealRequestViewController.h"
#import "UserProfileViewController.h"
#import "InviteFriendsTableViewController.h"
#import "Friend.h"
#import "MealRequestDetailTableViewController.h"

@interface MealRequestsTableViewController ()

@end

@implementation MealRequestsTableViewController

static NSString * const requestWithButtonsCellIdentifier = @"requestWithButtons";
static NSString * const requestWithoutButtonsCellIdentifier = @"requestWithoutButtons";

APIHelper *apiHelper;

#pragma mark - Segue

- (IBAction)unwindFromCreateMealRequest:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"exitFromInviteFriends"]) {
        //update meal request table view with new meal request
        InviteFriendsTableViewController *source = [segue sourceViewController];
        if (source.mealRequestCreated && source.mealRequest) {
            //reformat time before updating to meal request list
            source.mealRequest.time = [self reformatUnixTime:source.mealRequest.time];
            [self.mealRequestsFromSelf addObject:source.mealRequest];
            [self.tableView reloadData];
        }else{
            NSLog(@"meal request is null");
        }
    }else if([segue.identifier isEqualToString:@"exitFromCreateMealRequest"]) {
        //clear friend selection
        for(Friend *friend in self.user.friends){
            friend.selected = NO;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue for %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"openCreateMealRequest"]) {
        CreateMealRequestViewController *destViewController = segue.destinationViewController;
        destViewController.hidesBottomBarWhenPushed = YES;
    } else if([segue.identifier isEqualToString:@"openUserProfile"]) {
        UserProfileViewController *destViewController = segue.destinationViewController;
        destViewController.hidesBottomBarWhenPushed = YES;
    } else if ([segue.identifier isEqualToString:@"showMealRequest"]) {
        MealRequestDetailTableViewController *destViewController = segue.destinationViewController;
        destViewController.isUserMealRequest = self.isUserMealRequest;
        destViewController.request = self.requestSelected;
    }
}

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    apiHelper = [[APIHelper alloc]init];
    [self initializeUser];
    [self initializeMealRequests];
    
    //for testing purposes
    [self.tableView setIsAccessibilityElement:YES];
    [self.tableView setAccessibilityLabel:@"Meal Request List"];
   
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor redColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshMealRequestList)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeUser {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = ad.user;
}

- (void)initializeMockUser {
    self.user = [[User alloc] initWithUserid:@"userid" username:@"Gavin"];
}

- (void)initializeMealRequests {
    self.mealRequestsFromSelf = [[NSMutableArray alloc] init];
    self.mealRequestsFromOthers = [[NSMutableArray alloc] init];
    
    for (MealRequest *mealRequest in self.user.mealRequests){
        if(mealRequest.isSelf){
            [self.mealRequestsFromSelf addObject:mealRequest];
        }else{
            [self.mealRequestsFromOthers addObject:mealRequest];
        }
    }
}

- (void)refreshMealRequestList {
    [self getAllRequests];
    [self initializeUser];
    [self initializeMealRequests];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)getAllRequests {
    self.user.mealRequests = [[NSMutableArray alloc] init];
    
    NSDictionary *response = [apiHelper getAllMealRequests:self.user.userid];
    
    if (response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            NSArray *requests = [response objectForKey:@"requests"];
            for(NSDictionary *request in requests){
                NSString *requestid = request[@"_id"];
                NSString *ownerid = request[@"owner_id"];
                NSString *ownerUsername = request[@"owner_username"];
                NSString *mealTime = [self reformatUnixTime:request[@"meal_time"]];
                NSString *mealType = request[@"meal_type"];
                NSString *restaurant = request[@"restaurant"];
                NSString *comment = request[@"comment"];
                NSString *acceptedUser = request[@"accepted_user"];
                NSMutableArray *declinedUsers = request[@"declined_users"];
                
                MealRequest *mealRequest = [[MealRequest alloc] initWithRequestId:requestid ownerid:ownerid ownername:ownerUsername type:mealType time:mealTime restaurant:restaurant comment:comment acceptedUser:acceptedUser declinedUsers:declinedUsers selfId:self.user.userid];
                [self.user.mealRequests addObject:mealRequest];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Get all meal requests failed. Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Server Error"
                              message:@"Get all meal requests failed. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (NSString *)reformatUnixTime:(NSString *)unixTime {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[unixTime intValue]];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setLocale:[NSLocale currentLocale]];
    [timeFormatter setDateFormat:@"h:mm a"];
    return [timeFormatter stringFromDate:date];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return [self.mealRequestsFromSelf count];
    else if(section == 1)
        return [self.mealRequestsFromOthers count];
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        if([self.mealRequestsFromSelf count]){
            return @"Your Requests";
        }else{
            return nil;
        }
    }

    if(section == 1){
        if([self.mealRequestsFromOthers count]){
            return @"Requests From Others";
        }else{
            return nil;
        }
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) { //self requests
        MealRequest *request = self.mealRequestsFromSelf[indexPath.row];
        MealRequestWithoutButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithoutButtonsCellIdentifier];
        NSString *title = [self constructTitleForSelf:request];
        NSString *message = [self constructMessageForSelf:request];
        [cell.mealLabel setText:title];
        [cell.messageLabel setText:message];
        return cell;
    } else { //other requests
        MealRequest *request = self.mealRequestsFromOthers[indexPath.row];
        
        if (request.matched) {
            if ([self.user.userid isEqualToString:request.acceptedUser]){
                MealRequestWithoutButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithoutButtonsCellIdentifier];
                NSString *title = [self constructTitleForOther:request];
                NSString *message = @"You have accepted this request.";
                [cell.mealLabel setText:title];
                [cell.messageLabel setText:message];
                return cell;
            } else {
                MealRequestWithoutButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithoutButtonsCellIdentifier];
                NSString *title = [self constructTitleForOther:request];
                NSString *message = @"Someone else accepted this request.";
                [cell.mealLabel setText:title];
                [cell.messageLabel setText:message];
                return cell;
            }
        } else {
            if(request.responded){
                if(request.accepted){
                    MealRequestWithoutButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithoutButtonsCellIdentifier];
                    NSString *title = [self constructTitleForOther:request];
                    NSString *message = @"You have accepted this request.";
                    [cell.mealLabel setText:title];
                    [cell.messageLabel setText:message];
                    return cell;
                }else{
                    MealRequestWithoutButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithoutButtonsCellIdentifier];
                    NSString *title = [self constructTitleForOther:request];
                    NSString *message = @"You have declined this request.";
                    [cell.mealLabel setText:title];
                    [cell.messageLabel setText:message];
                    return cell;
                }
            }else{
                MealRequestWithButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestWithButtonsCellIdentifier];
                NSString *title = [self constructTitleForOther:request];
                [cell.mealLabel setText:title];
                cell.acceptButton.tag = indexPath.row;
                cell.declineButon.tag = indexPath.row;
                [cell.acceptButton addTarget:self action:@selector(acceptButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.declineButon addTarget:self action:@selector(declineButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.isUserMealRequest = YES;
        self.requestSelected = self.mealRequestsFromSelf[indexPath.row];
        NSLog(@"request owner is...... %@", self.requestSelected.ownerUsername);
    } else {
        self.isUserMealRequest = NO;
        self.requestSelected = self.mealRequestsFromOthers[indexPath.row];
        NSLog(@"request owner is...... %@", self.requestSelected.ownerUsername);

    }
    [self performSegueWithIdentifier:@"showMealRequest" sender:self];
}


- (NSString *)constructTitleForSelf:(MealRequest *)request{
    return [NSString stringWithFormat:@"Requested %@ at %@\n%@",
            [request.type isEqualToString:@"other"] ? @"a meal" : request.type,
            request.time,
            ([request.restaurant isEqualToString:@""] || !request.restaurant) ? @"(Location TBD)" : [NSString stringWithFormat:@"@ %@", request.restaurant]];
}

- (NSString *)constructMessageForSelf:(MealRequest *)request{
    if (request.matched){
        NSString *friendName = [self getUsernameByid:request.acceptedUser];
        return [NSString stringWithFormat:@"%@ accepted your request!", friendName];
    }else{
        return @"Waiting for response.";
    }
}

- (NSString *)constructTitleForOther:(MealRequest *)request{
    return [NSString stringWithFormat:@"%@: %@ at %@\n%@ ",
            request.ownerUsername,
            [request.type isEqualToString:@"other"] ? @"a meal" : request.type,
            request.time,
            ([request.restaurant isEqualToString:@""] || !request.restaurant) ? @"(Location TBD)" : [NSString stringWithFormat:@"@ %@", request.restaurant]];
}

//used for accepted user
- (NSString *)getUsernameByid:(NSString *)userid {
    
    NSDictionary *response = [apiHelper searchUserById:userid];
    
    if (response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            return response[@"username"];
        }
    }
    return nil;
}

- (IBAction)acceptButtonClicked:(UIButton *)sender {
    MealRequest *request = self.mealRequestsFromOthers[sender.tag];
    
    NSDictionary *response = [apiHelper handleMealRequestsForRequest:request.requestid WithAction:@"accept" ForUser:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            request.acceptedUser = self.user.userid;
            request.matched = YES;
            request.responded = YES;
            request.accepted = YES;
            [self.tableView reloadData];
            
        }else if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.MEAL_REQUEST_EXPIRED]){
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Request Expired"
                                  message:@"Sorry, someone else accepted this request before you."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Server Error"
                              message:@"Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
    //delete after integration with live data
    request.acceptedUser = self.user.userid;
    request.matched = YES;
    request.responded = YES;
    request.accepted = YES;
    [self.tableView reloadData];
}

- (IBAction)declineButtonClicked:(UIButton *)sender {
    MealRequest *request = self.mealRequestsFromOthers[sender.tag];
    
    NSDictionary *response = [apiHelper handleMealRequestsForRequest:request.requestid WithAction:@"decline" ForUser:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            request.responded = YES;
            request.accepted = NO;
            [self.tableView reloadData];
            
        }else if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.MEAL_REQUEST_EXPIRED]){
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Request Expired"
                                  message:@"Sorry, someone else accepted this request before you."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Server Error"
                              message:@"Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }

    //delete after integration with live data
    request.responded = YES;
    request.accepted = NO;
    [self.tableView reloadData];
}

@end
