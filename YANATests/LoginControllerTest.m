//
//  LoginControllerUITest.m
//  YANA
//
//  Created by Gavin Chu on 11/3/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KIF/KIF.h>

@interface LoginControllerTest : KIFTestCase

@end

@implementation LoginControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test1FailLogin {
    [tester enterText:@"iosTest" intoViewWithAccessibilityLabel:@"usernameTextField"];
    [tester enterText:@"wrong" intoViewWithAccessibilityLabel:@"passwordTextField"];
    [tester tapViewWithAccessibilityLabel:@"loginButton"];
    
    // Verify that the login failed with alert message
    [tester waitForViewWithAccessibilityLabel:@"Invalid Credentials"];
    [tester tapViewWithAccessibilityLabel:@"OK"];
}

- (void)test2SuccessfulLogin {
    [tester clearTextFromAndThenEnterText:@"iosTest"
           intoViewWithAccessibilityLabel:@"usernameTextField"];
    [tester clearTextFromAndThenEnterText:@"test"
           intoViewWithAccessibilityLabel:@"passwordTextField"];
    [tester tapViewWithAccessibilityLabel:@"loginButton"];
    
    // close save keychain
    [tester tapViewWithAccessibilityLabel:@"No" traits:UIAccessibilityTraitButton];
    
    // Verify that the login succeeded
    [tester waitForViewWithAccessibilityLabel:@"Meal Requests"];
}

- (void)test3Logout {
    [tester tapViewWithAccessibilityLabel:@"settings" traits:UIAccessibilityTraitButton];
    [tester tapViewWithAccessibilityLabel:@"Logout" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"loginButton"];
}

@end
