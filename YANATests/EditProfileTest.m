//
//  EditProfileTest.m
//  YANA
//
//  Created by Shane on 11/7/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KIF/KIF.h>
@interface EditProfileTest : KIFTestCase

@end

@implementation EditProfileTest

- (void)beforeAll {
    [tester clearTextFromAndThenEnterText:@"shaneTest" intoViewWithAccessibilityLabel:@"usernameTextField"];
    [tester clearTextFromAndThenEnterText:@"123" intoViewWithAccessibilityLabel:@"passwordTextField"];
    [tester tapViewWithAccessibilityLabel:@"loginButton"];
    [tester tapViewWithAccessibilityLabel:@"No" traits:UIAccessibilityTraitButton];
    [tester tapViewWithAccessibilityLabel:@"settings"];
}

- (void)test1EditAbout {
    [tester tapViewWithAccessibilityLabel:@"About"];
    [tester clearTextFromAndThenEnterText:@"about the user" intoViewWithAccessibilityLabel:@"aboutBox"];
    [tester waitForViewWithAccessibilityLabel:@"Save"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForViewWithAccessibilityLabel:@"User Profile"];
    [tester waitForViewWithAccessibilityLabel:@"about the user"];
}

- (void)test2EditGender {
    // change gender to female
    [tester tapViewWithAccessibilityLabel:@"Gender"];
    [tester waitForViewWithAccessibilityLabel:@"User Gender"];
    [tester tapViewWithAccessibilityLabel:@"Female"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForViewWithAccessibilityLabel:@"User Profile"];
    [tester waitForViewWithAccessibilityLabel:@"female"];
    // change gender to other
    [tester tapViewWithAccessibilityLabel:@"Gender"];
    [tester waitForViewWithAccessibilityLabel:@"User Gender"];
    [tester tapViewWithAccessibilityLabel:@"Other"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForViewWithAccessibilityLabel:@"User Profile"];
    [tester waitForViewWithAccessibilityLabel:@"other"];
}

- (void)test3EditAge {
    [tester tapViewWithAccessibilityLabel:@"Age"];
    [tester waitForViewWithAccessibilityLabel:@"User Age"];
    [tester clearTextFromAndThenEnterText:@"19" intoViewWithAccessibilityLabel:@"ageBox"];
    [tester waitForViewWithAccessibilityLabel:@"Save"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForViewWithAccessibilityLabel:@"User Profile"];
    [tester waitForViewWithAccessibilityLabel:@"19"];
}

- (void)test4EditFoodPreferences {
    [tester tapViewWithAccessibilityLabel:@"Food Preferences"];
    [tester waitForViewWithAccessibilityLabel:@"User Food Preferences"];
    [tester clearTextFromAndThenEnterText:@"Tacos" intoViewWithAccessibilityLabel:@"foodPreferencesBox"];
    [tester waitForViewWithAccessibilityLabel:@"Save"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForViewWithAccessibilityLabel:@"User Profile"];
    [tester waitForViewWithAccessibilityLabel:@"Tacos"];
}

- (void)test5EditPhoneNumber {
    [tester tapViewWithAccessibilityLabel:@"Phone Number"];
    [tester waitForViewWithAccessibilityLabel:@"User Phone Number"];
    [tester clearTextFromViewWithAccessibilityLabel:@"phoneNumberBox"];
    [tester clearTextFromAndThenEnterText:@"510512512" intoViewWithAccessibilityLabel:@"phoneNumberBox"];
    [tester waitForViewWithAccessibilityLabel:@"Save"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForViewWithAccessibilityLabel:@"User Profile"];
    [tester waitForViewWithAccessibilityLabel:@"510512512"];
}

- (void)test6EditPrivacy {
    //change to Friends Only
    [tester tapViewWithAccessibilityLabel:@"Privacy Settings"];
    [tester waitForViewWithAccessibilityLabel:@"User Privacy Settings"];
    [tester tapViewWithAccessibilityLabel:@"Friends Only"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForViewWithAccessibilityLabel:@"User Profile"];
    [tester waitForViewWithAccessibilityLabel:@"Friends Only"];
    //change to Global
    [tester tapViewWithAccessibilityLabel:@"Privacy Settings"];
    [tester waitForViewWithAccessibilityLabel:@"User Privacy Settings"];
    [tester tapViewWithAccessibilityLabel:@"Everyone"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForViewWithAccessibilityLabel:@"User Profile"];
    [tester waitForViewWithAccessibilityLabel:@"Everyone"];
}

- (void)test7UpdateAll {
    //update about
    [tester tapViewWithAccessibilityLabel:@"About"];
    [tester clearTextFromAndThenEnterText:@"about me" intoViewWithAccessibilityLabel:@"aboutBox"];
    [tester waitForViewWithAccessibilityLabel:@"Save"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForViewWithAccessibilityLabel:@"User Profile"];
    [tester waitForViewWithAccessibilityLabel:@"about me"];
    //update gender
    [tester tapViewWithAccessibilityLabel:@"Gender"];
    [tester waitForViewWithAccessibilityLabel:@"User Gender"];
    [tester tapViewWithAccessibilityLabel:@"Male"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForViewWithAccessibilityLabel:@"User Profile"];
    [tester waitForViewWithAccessibilityLabel:@"male"];
    //update age
    [tester tapViewWithAccessibilityLabel:@"Age"];
    [tester waitForViewWithAccessibilityLabel:@"User Age"];
    [tester clearTextFromAndThenEnterText:@"21" intoViewWithAccessibilityLabel:@"ageBox"];
    [tester waitForViewWithAccessibilityLabel:@"Save"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForViewWithAccessibilityLabel:@"User Profile"];
    [tester waitForViewWithAccessibilityLabel:@"21"];
    //update food preferences
    [tester tapViewWithAccessibilityLabel:@"Food Preferences"];
    [tester waitForViewWithAccessibilityLabel:@"User Food Preferences"];
    [tester clearTextFromViewWithAccessibilityLabel:@"foodPreferencesBox"];
    [tester enterText:@"Cucumbers" intoViewWithAccessibilityLabel:@"foodPreferencesBox"];
    [tester waitForViewWithAccessibilityLabel:@"Save"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForViewWithAccessibilityLabel:@"User Profile"];
    [tester waitForViewWithAccessibilityLabel:@"Cucumbers"];
    //update phone number
    [tester tapViewWithAccessibilityLabel:@"Phone Number"];
    [tester waitForViewWithAccessibilityLabel:@"User Phone Number"];
    [tester clearTextFromViewWithAccessibilityLabel:@"phoneNumberBox"];
    [tester enterText:@"4154164177" intoViewWithAccessibilityLabel:@"phoneNumberBox"];
    [tester waitForViewWithAccessibilityLabel:@"Save"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForViewWithAccessibilityLabel:@"User Profile"];
    [tester waitForViewWithAccessibilityLabel:@"4154164177"];
    //update privacy
    [tester tapViewWithAccessibilityLabel:@"Privacy Settings"];
    [tester waitForViewWithAccessibilityLabel:@"User Privacy Settings"];
    [tester tapViewWithAccessibilityLabel:@"Private"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForViewWithAccessibilityLabel:@"User Profile"];
    [tester waitForViewWithAccessibilityLabel:@"Private"];
}

- (void) afterAll {
    [tester tapViewWithAccessibilityLabel:@"Logout"];
}




@end