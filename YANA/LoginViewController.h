//
//  MainViewController.h
//  warmup2
//
//  Created by Gavin Chu on 9/27/14.
//  Copyright (c) 2014 cs169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <FBLoginViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property  BOOL loggedOut;
@end
