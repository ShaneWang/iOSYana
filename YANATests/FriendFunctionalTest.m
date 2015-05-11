//
//  FriendFunctionalTest.m
//  YANA
//
//  Created by Gavin Chu on 11/6/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KIF/KIF.h>

@interface FriendFunctionalTest : KIFTestCase

@end

@implementation FriendFunctionalTest

- (void)setUp {
    [super setUp];
    [self login];
    [tester tapViewWithAccessibilityLabel:@"Friends"]; //click on friends tab to start testing on friends stuff
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

- (void)test1SearchAndAddFriend {
    //verify that SearchAndAddFriendViewController is opened
    [tester tapViewWithAccessibilityLabel:@"add" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Friend Search"];
    
    //tap on searchbar and enter "test"
    [tester tapViewWithAccessibilityLabel:nil traits:UIAccessibilityTraitSearchField];
    [tester waitForFirstResponderWithAccessibilityLabel:nil traits:UIAccessibilityTraitSearchField];
    [tester enterTextIntoCurrentFirstResponder:@"gavin"];
    [tester waitForViewWithAccessibilityLabel:nil value:@"gavin" traits:UIAccessibilityTraitSearchField];
    
    //tap on search and verify result
    [tester tapViewWithAccessibilityLabel:@"search" traits:UIAccessibilityTraitButton];
    
    //add "gavin" and check it disappears from list
    [tester tapScreenAtPoint:CGPointMake(300, 130)];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"gavin"];
    
    //add "gavin2" from friend profile page
    [tester tapScreenAtPoint:CGPointMake(100, 130)];
    [tester waitForViewWithAccessibilityLabel:@"Friend Profile"];
    [tester tapViewWithAccessibilityLabel:@"Add" traits:UIAccessibilityTraitButton];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"gavin2"];
    
    //close SearchAndAddFriendViewController
    [tester tapViewWithAccessibilityLabel:@"Done" traits:UIAccessibilityTraitButton];
    UITableView *tableView = (UITableView *)[tester waitForViewWithAccessibilityLabel:@"Friend List"];
    
    //verify that the 2 friends are added to the list
    NSInteger friendCount = [tableView numberOfRowsInSection:1];
    XCTAssertTrue(friendCount == 2, @"There should 2 friends in Friend List!");
}

- (void)test2InviteFriendFromFriendsTableViewController {
    //tap on invite to invite "gavin" from FriendsTableViewController
    [tester tapScreenAtPoint:CGPointMake(300, 170)];
    [tester waitForViewWithAccessibilityLabel:@"Create Meal Request"];
    
    //tap on invite friends to check if "gavin" is selected
    [tester tapViewWithAccessibilityLabel:@"Invite friends" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"gavin" traits:UIAccessibilityTraitSelected];
    
    //close CreateMealRequest
    [tester tapViewWithAccessibilityLabel:@"Back" traits:UIAccessibilityTraitButton];
    [tester tapViewWithAccessibilityLabel:@"cancel" traits:UIAccessibilityTraitButton];
}

- (void)test3InviteFriendFromFriendProfile {
    //tap on row to invite "gavin2" from FriendProfileViewController
    [tester tapScreenAtPoint:CGPointMake(100, 220)];
    [tester waitForViewWithAccessibilityLabel:@"Friend Profile"];
    [tester tapViewWithAccessibilityLabel:@"Invite" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Create Meal Request"];
    
    //tap on invite friends to check if "gavin" is selected
    [tester tapViewWithAccessibilityLabel:@"Invite friends" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"gavin2" traits:UIAccessibilityTraitSelected];
    
    //close CreateMealRequest
    [tester tapViewWithAccessibilityLabel:@"Back" traits:UIAccessibilityTraitButton];
    [tester tapViewWithAccessibilityLabel:@"cancel" traits:UIAccessibilityTraitButton];
}

- (void)test4RemoveFriendFromFriendsTableViewController {
    //verify that there is at least 1 friend in the list
    UITableView *tableView = (UITableView *)[tester waitForViewWithAccessibilityLabel:@"Friend List"];
    NSInteger friendCount = [tableView numberOfRowsInSection:1];
    XCTAssertTrue(friendCount >= 1, @"There should 2 friends in Friend List!");
    
    //slide row to remove "gavin" from FriendsTableViewController
    [tester swipeViewWithAccessibilityLabel:@"Section 1 Row 0" inDirection:KIFSwipeDirectionLeft];
    [tester tapViewWithAccessibilityLabel:@"Delete"];
    
    //verify that "gavin" is gone
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"gavin"];
}

- (void)test5RemoveFriendFromFriendProfile {
    //verify that there is at least 1 friend in the list
    UITableView *tableView = (UITableView *)[tester waitForViewWithAccessibilityLabel:@"Friend List"];
    NSInteger friendCount = [tableView numberOfRowsInSection:1];
    XCTAssertTrue(friendCount >= 1, @"There should at least 1 friend in Friend List!");
    
    //tap on row to remove "gavin2" from FriendProfileViewController
    [tester tapScreenAtPoint:CGPointMake(100, 170)];
    [tester waitForViewWithAccessibilityLabel:@"Friend Profile"];
    [tester tapViewWithAccessibilityLabel:@"Remove" traits:UIAccessibilityTraitButton];
    
    //verify that the screen goes back to friends list and check that "gavin2" is gone
    [tester waitForViewWithAccessibilityLabel:@"Friends"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"gavin2"];
}

- (void)test6HandleRequestsFromOthers {
    UITableView *tableView = (UITableView *)[tester waitForViewWithAccessibilityLabel:@"Friend List"];
    NSInteger friendRequestCount = [tableView numberOfRowsInSection:0];
    NSInteger friendCount = [tableView numberOfRowsInSection:1];
    
    //verify that there is at least 1 friend in friends who added you list
    XCTAssertTrue(friendRequestCount >= 1, @"There should at least 1 friend in friends who added you list.");
    
    //tap on add button for "iosTester2"
    [tester tapScreenAtPoint:CGPointMake(300, 100)];
    
    //check that size of friends who added you list went down by 1
    NSInteger newFriendRequestCount = [tableView numberOfRowsInSection:0];
    XCTAssertEqual(newFriendRequestCount, friendRequestCount - 1);
    
    //check that size of all friends list went up by 1
    NSInteger newFriendCount = [tableView numberOfRowsInSection:1];
    XCTAssertEqual(newFriendCount, friendCount + 1);
    
    //delete friend to reset conditions
    [tester swipeViewWithAccessibilityLabel:@"Section 1 Row 0" inDirection:KIFSwipeDirectionLeft];
    [tester tapViewWithAccessibilityLabel:@"Delete"];
    
    //verify that "gavin" is gone
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"iosTester2"];
}

@end
