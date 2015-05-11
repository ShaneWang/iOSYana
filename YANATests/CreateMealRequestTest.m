//
//  CreateMealRequestTest.m
//  YANA
//
//  Created by Shane on 11/9/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KIF/KIF.h>
@interface CreateMealRequestTest : KIFTestCase

@end

@implementation CreateMealRequestTest

- (void)beforeAll {
    [tester enterText:@"shaneTest" intoViewWithAccessibilityLabel:@"usernameTextField"];
    [tester enterText:@"123" intoViewWithAccessibilityLabel:@"passwordTextField"];
    [tester tapViewWithAccessibilityLabel:@"loginButton"];
    [tester tapViewWithAccessibilityLabel:@"No" traits:UIAccessibilityTraitButton];
}

- (void)test1CreateMealRequestWithTypeOther {
    [tester tapScreenAtPoint:CGPointMake(300, 20)];
    [tester waitForViewWithAccessibilityLabel:@"Create Meal Request"];
    [tester enterText:@"Top Dog" intoViewWithAccessibilityLabel:@"restaurantTextField"];
    [tester tapViewWithAccessibilityLabel:@"Invite friends"];
    [tester waitForViewWithAccessibilityLabel: @"Invite Friends"];
    //select the first friend
    [tester tapViewWithAccessibilityLabel:@"shane" traits:UIAccessibilityTraitStaticText];
    //wait for Done button to become enabled
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Done" traits:UIAccessibilityTraitNotEnabled];
    //click on Done button
    [tester tapViewWithAccessibilityLabel:@"Done" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Meal Requests"];
}

- (void) afterAll {
    [tester tapViewWithAccessibilityLabel:@"settings" traits:UIAccessibilityTraitButton];
    [tester tapViewWithAccessibilityLabel:@"Logout" traits:UIAccessibilityTraitButton];
}




@end