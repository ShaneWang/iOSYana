//
//  MainTabBarController.h
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MainTabBarController : UITabBarController<UITabBarControllerDelegate, UITabBarDelegate>

@property (nonatomic,retain) IBOutlet UITabBarController *tabController;

@end
