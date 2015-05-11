//
//  AppDelegate.h
//  YANA
//
//  Created by Gavin Chu on 10/13/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) User *user;

@property (nonatomic, strong) NSString *deviceToken;

@property (nonatomic, strong) NSString *selectedRestaurant;

@end

