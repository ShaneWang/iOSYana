//
//  UserProfileViewController.m
//  YANA
//
//  Created by Shane on 10/23/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "UserProfileViewController.h"
#import "APIHelper.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "KeychainItemWrapper.h"
@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

APIHelper *apiHelper;

static NSString *NONE = @"(none)";
static NSString *NOT_SPECIFIED = @"(not specified)";

- (void)viewDidLoad {
    [super viewDidLoad];
    apiHelper = [[APIHelper alloc] init];
    [self initializeUser];
    [self getProfileInfo];
    [self displayProfileInfo];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"edit"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(editButtonPressed:)];
    self.navigationItem.rightBarButtonItem = editButton;
    [self hideTextField];
    self.ageBox.keyboardType = UIKeyboardTypeDecimalPad;
    self.phoneNumberBox.keyboardType = UIKeyboardTypeDecimalPad;
}

-(void)viewWillLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect visibleRect;
    visibleRect.origin = self.scrollView.contentOffset;
    visibleRect.size = self.scrollView.contentSize;
    self.scrollView.contentSize = CGSizeMake(visibleRect.size.width, visibleRect.size.height+40);
}

- (void)initializeUser{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
}

- (void) hideTextField {
    self.aboutBox.hidden = YES;
    self.ageBox.hidden = YES;
    self.foodPreferencesBox.hidden = YES;
    self.genderBox.hidden = YES;
    self.phoneNumberBox.hidden = YES;
}

- (void) showTextField {
    self.aboutBox.hidden = NO;
    self.ageBox.hidden = NO;
    self.foodPreferencesBox.hidden = NO;
    self.genderBox.hidden = NO;
    self.phoneNumberBox.hidden = NO;
}

- (void) resetTextField {
    self.aboutBox.text = nil;
    self.ageBox.text = nil;
    self.foodPreferencesBox.text = nil;
    self.genderBox.text = nil;
    self.phoneNumberBox.text = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getProfileInfo {
    NSDictionary *response = [apiHelper getProfile:self.user.userid targetid:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){

            self.privacy = [response objectForKey:@"privacy"];
            NSDictionary *profile = [response objectForKey:@"profile"];
            self.about = [profile objectForKey:@"about"];
            self.age = [profile objectForKey:@"age"];
            self.foodPreferences = [profile objectForKey:@"food_preferences"];
            self.gender = [profile objectForKey:@"gender"];
            self.phoneNumber = [profile objectForKey:@"phone_number"];
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

- (void)updateProfile {
    NSDictionary *response = [apiHelper editProfile:self.user.userid withPrivacy:self.privacy  about:self.about gender:self.gender age:self.age foodPreferences:self.foodPreferences phoneNumber:self.phoneNumber];
    
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
}

- (void)displayProfileInfo {
    self.usernameLabel.text = self.user.username;
    self.aboutLabel.text = self.about ? self.about : @"(none)";
    self.genderLabel.text = self.gender ? self.gender : @"(not specified)";
    self.ageLabel.text = ![self.age isEqualToNumber:[NSNumber numberWithInt:0]] ? [NSString stringWithFormat:@"%@", self.age] : @"(not specified)";
    self.foodPreferencesLabel.text = self.foodPreferences ? self.foodPreferences : @"(not specified)";
    self.phoneNumberLabel.text = self.phoneNumber ? self.phoneNumber : @"(not specified)";
}

- (IBAction)logoutClicked:(UIButton *)sender {
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"editAbout"]){


    }
}

- (void)resetValues {
    self.about = nil;
    self.age = nil;
    self.gender = nil;
    self.phoneNumber = nil;
    self.foodPreferences = nil;
}

- (void)editButtonPressed:(id)sender {
    [self showTextField];
    
    if(![self.aboutLabel.text isEqualToString:@"(none)"]){
        self.aboutBox.text = self.aboutLabel.text;
    }else{
        self.aboutBox.placeholder = @"(none)";
    }
    
    if(![self.ageLabel.text isEqualToString:@"(not specified)"]){
        self.ageBox.text = self.ageLabel.text;
    }else{
        self.ageBox.placeholder = @"(not specified)";
    }
    
    if(![self.genderLabel.text isEqualToString:@"(not specified)"]){
        self.genderBox.text = self.genderLabel.text;
    }else{
        self.genderBox.placeholder = @"(not specified)";
    }
    
    if(![self.foodPreferencesLabel.text isEqualToString:@"(not specified)"]){
        self.foodPreferencesBox.text = self.foodPreferencesLabel.text;
    }else{
        self.foodPreferencesBox.placeholder = @"(not specified)";
    }
    
    if(![self.phoneNumberLabel.text isEqualToString:@"(not specified)"]){
        self.phoneNumberBox.text = self.phoneNumberLabel.text;
    }else{
        self.phoneNumberBox.placeholder = @"(not specified)";
    }
}

- (IBAction)updateButtonClicked:(id)sender {
//    [self validateInput];
    
    //[self displayProfileInfo];
    //update text labels
    self.aboutLabel.text = [self.aboutBox.text isEqualToString:@""] ? NONE : self.aboutBox.text;
    self.ageLabel.text = [self.ageBox.text isEqualToString:@""] ? NOT_SPECIFIED : self.ageBox.text;
    self.genderLabel.text = [self.genderBox.text isEqualToString:@""] ? NOT_SPECIFIED : self.genderBox.text;
    self.foodPreferencesLabel.text = [self.foodPreferencesBox.text isEqualToString:@""] ? NOT_SPECIFIED : self.foodPreferencesBox.text;
    self.phoneNumberLabel.text = [self.phoneNumberBox.text isEqualToString:@""] ? NOT_SPECIFIED : self.phoneNumberBox.text;
    
    //update values that need to be sent to server: nil if "(none)" or "(not specified)"
    self.about = self.aboutLabel.text;
    self.age = [NSNumber numberWithInt:[self.ageLabel.text intValue]];
    self.gender = self.genderLabel.text;
    self.foodPreferences = self.foodPreferencesLabel.text;
    self.phoneNumber = self.phoneNumberLabel.text;
    
    [self updateProfile];
    //[self getProfileInfo];
    [self hideTextField];
    [self resetValues];
    
    //set up accessibility values for KIF testing
    [self.aboutLabel setValue:self.aboutLabel.text forKey:@"accessibilityValue"];
    [self.ageLabel setValue:self.ageLabel.text forKey:@"accessibilityValue"];
    [self.genderLabel setValue:self.genderLabel.text forKey:@"accessibilityValue"];
    [self.foodPreferencesLabel setValue:self.foodPreferencesLabel.text forKey:@"accessibilityValue"];
    [self.phoneNumberLabel setValue:self.phoneNumberLabel.text forKey:@"accessibilityValue"];
}

- (IBAction)segmentedControllerValueChanged:(id)sender {
    self.privacy = [NSNumber numberWithInteger:self.segmentedController.selectedSegmentIndex];
}

@end
