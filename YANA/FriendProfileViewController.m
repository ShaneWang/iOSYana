//
//  FriendProfileViewController.m
//  YANA
//
//  Created by Gavin Chu on 11/5/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "AppDelegate.h"
#import "APIHelper.h"
#import "CreateMealRequestViewController.h"

@interface FriendProfileViewController ()

//properties for profile viewed
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *about;
@property (nonatomic) NSNumber *age;
@property (nonatomic, strong) NSString *foodPreferences;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic) BOOL isMyFriend; //user is following target user
@property (nonatomic) BOOL isFriendWithMe;  //user is followed by target user
@property (nonatomic) int privacy;

@end

@implementation FriendProfileViewController

APIHelper *apiHelper;

NSInteger const PRIVATE = 0;
NSInteger const FRIENDS = 1;
NSInteger const GLOBAL = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUser];
    apiHelper = [[APIHelper alloc] init];
    
    //initialize local private variables
    self.username = nil;
    self.about = nil;
    self.age = nil;
    self.foodPreferences = nil;
    self.gender = nil;
    self.phoneNumber = nil;
    
    [self getProfileInfo];
    [self updateCurrentFriend];
    [self displayProfileInfo];
    [self addToolbar];
}

-(void)viewWillLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect visibleRect;
    visibleRect.origin = self.scrollview.contentOffset;
    visibleRect.size = self.scrollview.contentSize;
    self.scrollview.contentSize = CGSizeMake(visibleRect.size.width, visibleRect.size.height+44);
    //self.scrollview.contentSize = CGSizeMake(320,800);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeUser{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = ad.user;
}

- (void)getProfileInfo {
    NSDictionary *response = [apiHelper getProfile:self.user.userid targetid:self.targetid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            self.privacy = [[response objectForKey:@"privacy"] intValue];
            
            int follow = [[response objectForKey:@"follow"] intValue];
            self.isMyFriend = follow == 1 ? YES : NO;
            
            int followed = [[response objectForKey:@"followed"] intValue];
            self.isFriendWithMe = followed == 1 ? YES : NO;
            
            NSDictionary *profile = [response objectForKey:@"profile"];
            self.username = [profile objectForKey:@"username"];
            self.about = [profile objectForKey:@"about"];
            self.age = [profile objectForKey:@"age"];
            self.foodPreferences = [profile objectForKey:@"food_preferences"];
            self.gender = [profile objectForKey:@"gender"];
            self.phoneNumber = [profile objectForKey:@"phone_number"];
            
            [self printProfileInfo];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Get profile info failed. Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Get profile info failed. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)updateCurrentFriend {
    if(self.isMyFriend){
        for(Friend *f in self.user.friends){
            if([f.friendid isEqualToString:self.targetid]){
                self.currentFriend = f;
            }
        }
    }
}

- (void)displayProfileInfo {
    //username is always visible
    self.usernameLabel.text = self.username ? self.username : @"(error)";
    
    //about is always visible
    self.aboutLabel.text = self.about ? self.about : @"(none)";
    
    //rest of the fields depends on privacy setting; hide label if field is null
    if((self.privacy == PRIVATE) || (self.privacy == FRIENDS && !self.isFriendWithMe)){ //hide all cases
        self.genderLabel.hidden = YES;
        self.genderTitleLabel.hidden = YES;
        self.ageLabel.hidden = YES;
        self.ageTitleLabel.hidden = YES;
        self.foodPreferencesLabel.hidden = YES;
        self.foodPreferencesTitleLabel.hidden = YES;
        self.phoneNumberLabel.hidden = YES;
        self.phoneNumberTitleLabel.hidden = YES;
    }else{ //show all cases
        self.genderLabel.hidden = NO;
        self.genderTitleLabel.hidden = NO;
        self.ageLabel.hidden = NO;
        self.ageTitleLabel.hidden = NO;
        self.foodPreferencesLabel.hidden = NO;
        self.foodPreferencesTitleLabel.hidden = NO;
        self.phoneNumberLabel.hidden = NO;
        self.phoneNumberTitleLabel.hidden = NO;
        self.genderLabel.text = self.gender ? self.gender : @"(not specified)";
        self.ageLabel.text = self.age ? [NSString stringWithFormat:@"%@", self.age] : @"(not specified)";
        self.foodPreferencesLabel.text = self.foodPreferences ? self.foodPreferences : @"(not specified)";
        self.phoneNumberLabel.text = self.phoneNumber ? self.phoneNumber : @"(not specified)";
    }
}

- (void)printProfileInfo {
    NSLog(@" username: %@\n about: %@\n gender: %@\n age: %@\n foodPreferences: %@\n phoneNumber: %@", self.username, self.about, self.gender, self.age, self.foodPreferences, self.phoneNumber);
}

- (void)addToolbar {
    NSArray *toolbarItems;
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if(self.isMyFriend){
        UIBarButtonItem *inviteItem = [[UIBarButtonItem alloc]initWithTitle:@"Invite" style:UIBarButtonItemStyleBordered target:self action:@selector(inviteClicked:)];
        UIBarButtonItem *removeItem = [[UIBarButtonItem alloc]initWithTitle:@"Remove" style:UIBarButtonItemStyleBordered target:self action:@selector(removeClicked:)];
        toolbarItems = [NSArray arrayWithObjects:inviteItem, spaceItem, removeItem, nil];
    }else{
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addClicked:)];
        toolbarItems = [NSArray arrayWithObjects:spaceItem, addItem, spaceItem, nil];
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,screenHeight-44,320,44)];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar setItems:toolbarItems];
    [self.view addSubview:toolbar];
}

- (IBAction)inviteClicked:(id)sender {
    self.currentFriend.selected = YES;
    //segue to create meal request
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateMealRequestNavigationController"];
    viewController.hidesBottomBarWhenPushed = YES;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)removeClicked:(id)sender {
    NSDictionary *response = [apiHelper deleteFriend:self.targetid fromYou:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            [self.user.friends removeObject:self.currentFriend];
            [self saveFriends];
            self.removed = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
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
                              initWithTitle:@"Error"
                              message:@"Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)addClicked:(id)sender {
    NSDictionary *response = [apiHelper addFriend:self.targetid toYou:self.user.userid];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            //create new instance of friend and save it to user
            self.currentFriend = [[Friend alloc] initWithid:self.targetid andUsername:self.username];
            [self.currentFriend toString];
            [self.user.friends addObject:self.currentFriend];
            [self saveFriends];
            [self.navigationController popToRootViewControllerAnimated:YES];
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
                              initWithTitle:@"Error"
                              message:@"Can't add friend. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void) saveFriends{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.user = self.user;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
