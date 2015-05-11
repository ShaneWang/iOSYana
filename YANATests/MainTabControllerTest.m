//
//  MainTabControllerTest.m
//  YANA
//
//  Created by Gavin Chu on 11/3/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KIF/KIF.h>

@interface MainTabControllerTest : KIFTestCase

@end

@implementation MainTabControllerTest

- (void)setUp {
    [super setUp];
    [self login];
}

- (void)tearDown {
    [self logout];
    [super tearDown];
}

- (void)login {
    [tester enterText:@"iosTest" intoViewWithAccessibilityLabel:@"usernameTextField"];
    [tester enterText:@"test" intoViewWithAccessibilityLabel:@"passwordTextField"];
    [tester tapViewWithAccessibilityLabel:@"loginButton"];
    [tester tapViewWithAccessibilityLabel:@"No" traits:UIAccessibilityTraitButton];
}

- (void)logout {
    [tester tapViewWithAccessibilityLabel:@"settings" traits:UIAccessibilityTraitButton];
    [tester tapViewWithAccessibilityLabel:@"Logout" traits:UIAccessibilityTraitButton];
}

- (void)test1SwitchingTabs {
    //verify switched to Friends tab
    [tester tapViewWithAccessibilityLabel:@"Friends" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Friends" traits:UIAccessibilityTraitStaticText];
    
    //verify switched back to Meal Requests tab
    [tester tapViewWithAccessibilityLabel:@"Requests" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Meal Requests" traits:UIAccessibilityTraitStaticText];
    
    //verify switched to Nearby Users tab
    [tester tapViewWithAccessibilityLabel:@"Nearby Users" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Nearby Users" traits:UIAccessibilityTraitStaticText];
    
    //verify switched to Friends tab again
    [tester tapViewWithAccessibilityLabel:@"Friends" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Friends" traits:UIAccessibilityTraitStaticText];
}

- (void)test2OpenCreateMealRequest {
    [tester tapViewWithAccessibilityLabel:@"Requests" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Meal Requests" traits:UIAccessibilityTraitStaticText];
    
    //verify that CreateMealRequestViewController is opened
    [tester tapViewWithAccessibilityLabel:@"add" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Create Meal Request"];
    
    //return to home screen
    [tester tapViewWithAccessibilityLabel:@"cancel" traits:UIAccessibilityTraitButton];
}

- (void)test3OpenSearchAndAddFriend {
    [tester tapViewWithAccessibilityLabel:@"Friends" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Friends" traits:UIAccessibilityTraitStaticText];
    
    //verify that SearchAndAddFriendViewController is opened
    [tester tapViewWithAccessibilityLabel:@"add" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Friend Search"];
    
    //return to home screen
    [tester tapViewWithAccessibilityLabel:@"Done"];
}

- (void)test4OpenNearbyUsersFilter {
    [tester tapViewWithAccessibilityLabel:@"Nearby Users" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Nearby Users" traits:UIAccessibilityTraitStaticText];
    
    //verify that SearchAndAddFriendViewController is opened
    [tester tapViewWithAccessibilityLabel:@"Filter" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Filter Options"];
    
    //return to home screen
    [tester tapViewWithAccessibilityLabel:@"Done"];
    [tester tapViewWithAccessibilityLabel:@"Requests" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Meal Requests" traits:UIAccessibilityTraitStaticText];
}

@end
