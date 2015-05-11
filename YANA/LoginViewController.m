//
//  MainViewController.m
//  warmup2
//
//  Created by Gavin Chu on 9/27/14.
//  Copyright (c) 2014 cs169. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "APIHelper.h"
#import "User.h"
#import "MainTabBarController.h"
#import "KeychainItemWrapper.h"

@interface LoginViewController ()

@property (nonatomic, strong) User *user;

@end

@implementation LoginViewController

APIHelper *apiHelper;

- (void)viewDidLoad
{
    [super viewDidLoad];
    apiHelper = [[APIHelper alloc]init];
    _loginView.readPermissions = @[@"public_profile", @"email"];
    _loginView.delegate = self;
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)viewDidAppear:(BOOL)animated {
    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserAuthToken" accessGroup:nil];
    if ([keychainWrapper objectForKey: (__bridge id)(kSecAttrAccount)] != nil) {
        self.usernameText.text = [keychainWrapper objectForKey: (__bridge id)(kSecAttrAccount)];
        self.passwordText.text = [keychainWrapper objectForKey: (__bridge id)(kSecValueData)];
    }
    if ([self isUserLogged] && self.loggedOut == NO) {
        [self.loginButton sendActionsForControlEvents: UIControlEventTouchUpInside];
    } else {
        NSLog(@"user is not logged");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(UIButton *)sender {
    NSDictionary *response = [apiHelper loginWithUsername:self.usernameText.text andPassword:self.passwordText.text];
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        // request succeeded
        if (statusCode == 1) {
            KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc]    initWithIdentifier:@"UserAuthToken" accessGroup:nil];
            NSString *oldUsername = [keychainWrapper objectForKey: (__bridge id)(kSecAttrAccount)];
            NSString *oldPassword = [keychainWrapper objectForKey: (__bridge id)(kSecValueData)];
            if (![oldUsername isEqualToString:self.usernameText.text] || ![oldPassword isEqualToString:self.passwordText.text]) {
                UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"Save username and password?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles: @"Delete all credentials", nil];
                [sheet showInView:self.view];
            }
        }
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            NSString *userid = [response objectForKey:@"user_id"];
            self.user = [[User alloc] initWithUserid:userid username:self.usernameText.text];
            [self performSegueWithIdentifier:@"openMain" sender:self];
            
        }else if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.WRONG_USERNAME_OR_PASSWORD]){
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid Credentials"
                                  message:@"Wrong username or password."
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
}

- (IBAction)createUser:(UIButton *)sender {
    NSDictionary *response = [apiHelper createUserWithUsername:self.usernameText.text andPassword:self.passwordText.text];
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            NSString *userid = [response objectForKey:@"user_id"];
            self.user = [[User alloc] initWithUserid:userid username:self.usernameText.text];
            //keychain
            KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc]    initWithIdentifier:@"UserAuthToken" accessGroup:nil];
            NSString *olduser = [keychainWrapper objectForKey: (__bridge id)(kSecAttrAccount)];
            if (![olduser isEqualToString:self.usernameText.text]) {
                UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"Save username and password?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles: @"Delete all credentials", nil];
                [sheet showInView:self.view];
            }
            
            [self performSegueWithIdentifier:@"openMain" sender:self];
        }else if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.INVALID_USERNAME]){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid Username"
                                  message:@"Username is empty or it's too long."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.INVALID_PASSWORD]){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid Password"
                                  message:@"Password is too long."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.USERNAME_ALREADY_EXISTS]){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Invalid Username"
                                  message:@"Username already exists"
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"openMain"]) {
        AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        ad.user = self.user;
        [self registerDeviceToken];
    } else {
        return;
    }
}

- (void)registerDeviceToken{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(ad.deviceToken){
        NSDictionary *response = [apiHelper updateDeviceToken:ad.deviceToken forUser:ad.user.userid];
        if(response){
            int statusCode = [[response objectForKey:@"errCode"] intValue];
            if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
                //do nothing
            }else{
                NSLog(@"Can't register device. Please check your internet connection or try again later.");
            }
        }else{
            NSLog(@"Can't register device. Please check your internet connection or try again later.");
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
    
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *choice = [actionSheet buttonTitleAtIndex: buttonIndex];
    if ([choice isEqualToString: @"Yes"]) {
        // Save user info in the keychain
        KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserAuthToken" accessGroup:nil];
        [keychainWrapper setObject:self.usernameText.text forKey:(__bridge id)(kSecAttrAccount)];
        [keychainWrapper setObject:self.passwordText.text forKey:(__bridge id)(kSecValueData)];
    } else if ([choice isEqualToString: @"Delete all credentials"]){
        KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserAuthToken" accessGroup:nil];
        [keychainWrapper resetKeychainItem];
    }
}
- (BOOL)isUserLogged
{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserAuthToken" accessGroup:nil];
    NSString *username = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
    NSString *password = [wrapper objectForKey:(__bridge id)kSecValueData];
    BOOL isLogged = ([username length] > 0 && [password length] > 0);
    return isLogged;
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSDictionary *response = [apiHelper loginWithFacebook:user.id AndUsername:user.name AndEmail:[user objectForKey: @"email"]];
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];

        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            NSString *userid = [response objectForKey:@"user_id"];
            self.user = [[User alloc] initWithUserid:userid username:[user objectForKey: @"email"]];
            NSLog(self.user.userid);
            [self performSegueWithIdentifier:@"openMain" sender:self];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Server Error"
                              message:@"Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

//- (IBAction)textFieldDidEnd:(id)sender {
//    if ([sender isEqual: self.usernameText]){
//        if ([self.usernameText.text length] == 0) {
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:@"Invalid Username"
//                                        message:@"Username cannot be empty."
//                                        delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                otherButtonTitles:nil];
//            [alert show];
//        }
//    }
//}

@end
