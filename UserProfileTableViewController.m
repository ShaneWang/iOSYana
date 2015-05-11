//
//  UserProfileTableViewController.m
//  YANA
//
//  Created by Shane on 11/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "UserProfileTableViewController.h"
#import "APIHelper.h"
#import "AppDelegate.h"
#import "AboutUserTableViewController.h"
#import "FoodPreferencesUserTableViewController.h"
#import "AgeUserTableViewController.h"
#import "PhoneNumberUserTableViewController.h"
#import "LoginViewController.h"
#import "KeychainItemWrapper.h"
#import "GenderUserTableViewController.h"
#import "PrivacyUserTableViewController.h"
@interface UserProfileTableViewController ()

@end

@implementation UserProfileTableViewController
APIHelper *apiHelper;

- (void)viewDidLoad {
    [super viewDidLoad];
    apiHelper = [[APIHelper alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initializeUser];
    [self displayProfileInfo];
}
- (void)viewDidAppear:(BOOL)animated{
    [self displayProfileInfo];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeUser{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
}

#pragma mark - Table view data source
- (void)displayProfileInfo {
    NSDictionary *response = [apiHelper getProfile:self.user.userid targetid:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            self.privacy = [response objectForKey:@"privacy"];
            if ([self.privacy isEqualToNumber:[NSNumber numberWithInt:0]]) {
                self.privacyLabel.text = @"Private";
            }
            if ([self.privacy isEqualToNumber:[NSNumber numberWithInt:1]]) {
                self.privacyLabel.text = @"Friends Only";
            }
            if ([self.privacy isEqualToNumber:[NSNumber numberWithInt:2]]) {
                self.privacyLabel.text = @"Everyone";
            }
            
            NSDictionary *profile = [response objectForKey:@"profile"];
            self.age = [profile objectForKey:@"age"];
            self.usernameLabel.text = self.user.username;
            self.aboutLabel.text = [profile objectForKey:@"about"];
            self.ageLabel.text = [profile objectForKey:@"age"]? [NSString stringWithFormat: @"%@", [profile objectForKey:@"age"]] : @"";
            self.foodPreferencesLabel.text = [profile objectForKey:@"food_preferences"];
            self.genderLabel.text = [profile objectForKey:@"gender"];
            self.phoneNumberLabel.text = [profile objectForKey:@"phone_number"];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Server Error"
                                  message:@"Get profile info failed. Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Connection Error"
                              message:@"Get profile info failed. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:@"editAbout"]){
         AboutUserTableViewController *controller = segue.destinationViewController;
         controller.about = self.aboutLabel.text;
         controller.privacy = self.privacy;
     }
     if([segue.identifier isEqualToString:@"editFoodPreferences"]){
         FoodPreferencesUserTableViewController *controller1 = segue.destinationViewController;
         controller1.foodPreferences = self.foodPreferencesLabel.text;
         controller1.privacy = self.privacy;
     }
     if([segue.identifier isEqualToString:@"editAge"]){
         AgeUserTableViewController *controller2 = segue.destinationViewController;
         controller2.age = self.age;
         controller2.privacy = self.privacy;
     }
     if([segue.identifier isEqualToString:@"editPhoneNumber"]){
         PhoneNumberUserTableViewController *controller3 = segue.destinationViewController;
         controller3.phoneNumber = [NSNumber numberWithInt:[self.phoneNumberLabel.text intValue]];
         controller3.privacy = self.privacy;
     }
     if([segue.identifier isEqualToString:@"editGender"]){
         GenderUserTableViewController *controller4 = segue.destinationViewController;
         controller4.gender = self.genderLabel.text;
         controller4.privacy = self.privacy;
     }
     if([segue.identifier isEqualToString:@"editPrivacy"]){
         PrivacyUserTableViewController *controller5 = segue.destinationViewController;
         controller5.privacy = self.privacy;
     }
 }


- (IBAction)logoutClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LoginViewController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    
    //keychain
    loginController.loggedOut = YES;
    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserAuthToken" accessGroup:nil];
    [keychainWrapper setObject:@"" forKey:(__bridge id)(kSecValueData)];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.user = nil;
    
    [self presentViewController:loginController
                       animated:YES
                     completion:nil];
}
@end
