//
//  CreateMealRequestViewController.m
//  YANA
//
//  Created by Shane on 10/19/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "CreateMealRequestViewController.h"
#import "InviteFriendsTableViewController.h"
#import "AppDelegate.h"
#import "MealRequest.h"
#import "RestaurantSearchViewController.h"


@interface CreateMealRequestViewController ()

@end

@implementation CreateMealRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUser];
    
    //set default type and time
    [self setTimePickerForOther];
    self.type = @"other";
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.restaurantTextBox setText:@""];
    appDelegate.selectedRestaurant = @"";
}

- (void) viewDidAppear:(BOOL)animated {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.restaurantTextBox setText:appDelegate.selectedRestaurant];
}

/* Pass the MealRequest Object to InviteFriendsViewController */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"inviteFriendsButton"]){
        NSLog(@"Preparing for segue to InviteFriendsViewController");

        //Create MealRequest object
        self.mealRequest = [self prepareMealRequest];
        
        //pass MealRequest object to InviteFriendViewController
        InviteFriendsTableViewController *controller = segue.destinationViewController;
        controller.mealRequest = self.mealRequest;
        
        [controller.mealRequest toString];
    }
    if([segue.identifier isEqualToString:@"searchRestaurantButton"]){
        NSLog(@"Preparing for segue to RestaurantSearchViewController");
        
        //Create MealRequest object
        self.mealRequest = [self prepareMealRequest];
        
        //pass MealRequest object to InviteFriendViewController
        RestaurantSearchViewController *controller = segue.destinationViewController;
        controller.mealRequest = self.mealRequest;
    }
}

- (MealRequest *)prepareMealRequest {
    NSTimeInterval unixTime = [[self.timePicker date] timeIntervalSince1970];
    self.time = [NSString stringWithFormat:@"%d", (int)unixTime];
    return[[MealRequest alloc] initWithUserid:self.user.userid username:self.user.username type:self.type time:self.time restaurant:self.restaurantTextBox.text comment:self.commentTextBox.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// initialize User
- (void)initializeUser {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
}

- (void)setTimePickerForOther {
    //solution from http://stackoverflow.com/questions/12739962/uidatepicker-setting-wrong-time
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
    [components setCalendar:calendar];
    NSInteger hour = components.hour;
    NSInteger minute = components.minute;
    
    if (minute > 25) {
        minute = 0;
        hour += 1;
    } else {
        minute = 30;
    }
    
    // Now we set the componentns to our rounded values
    components.hour = hour;
    components.minute = minute;
    
    // Now we get the date back from our modified date components.
    NSDate *toNearestHalfHour = [components date];
    [self.timePicker setDate: toNearestHalfHour];
    
    // Set current time as minimum date
//    NSDate *currentTime = [NSDate date];
//    [self.timePicker setMinimumDate:currentTime];
    
    //set max date to the next day
    components.day++;
    [self.timePicker setMaximumDate:[components date]];
}

- (IBAction)mealTypeSelected:(id)sender {
    NSLog(@"mealTypeSelected");
    
    /* Get current NSDate components */
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSDateComponents *currComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |NSHourCalendarUnit fromDate:[NSDate date]];
    NSInteger currDay = [currComponents day];
    NSInteger currMonth = [currComponents month];
    NSInteger currYear = [currComponents year];
    NSInteger currHour = [currComponents hour];
    
    NSInteger nextDay = currDay + 1;
    
    if (self.typeButtons.selectedSegmentIndex == 0) {
        [components setYear:currYear];
        [components setMonth:currMonth];
        if (currHour > 9) {
            [components setDay:nextDay];
        } else {
            [components setDay:currDay];
        }
        [components setHour:9];
        [components setMinute:0];
        NSDate *date = [calendar dateFromComponents:components];
        [self.timePicker setDate: date];
        self.type = @"breakfast";
    }
    if (self.typeButtons.selectedSegmentIndex == 1) {
        [components setYear:currYear];
        [components setMonth:currMonth];
        if (currHour > 12) {
            [components setDay:nextDay];
        } else {
            [components setDay:currDay];
        }
        [components setHour:12];
        [components setMinute:0];
        NSDate *date = [calendar dateFromComponents:components];
        [self.timePicker setDate: date];
        self.type = @"lunch";
    }
    if (self.typeButtons.selectedSegmentIndex == 2) {
        [components setYear:currYear];
        [components setMonth:currMonth];
        if (currHour > 19) {
            [components setDay:nextDay];
        } else {
            [components setDay:currDay];
        }
        [components setHour:19];
        [components setMinute:0];
        NSDate *date = [calendar dateFromComponents:components];
        [self.timePicker setDate: date];
        self.type = @"dinner";
    }
    if (self.typeButtons.selectedSegmentIndex == 3) {
        [self setTimePickerForOther];
        self.type = @"other";
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self animateTextField: textField up: YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up {
    const int movementDistance = 150; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (IBAction)yelpSearchButtonClicked:(UIButton *)sender {
    if ([self checkValidTime]) {
        [self performSegueWithIdentifier:@"searchRestaurantButton" sender:sender];
    } else {
        [self displayInvalidTimeError];
    }
}

- (IBAction)inviteFriendsButtonClicked:(UIButton *)sender {
    if ([self checkValidTime]) {
        [self performSegueWithIdentifier:@"inviteFriendsButton" sender:sender];
    } else {
        [self displayInvalidTimeError];
    }
}

- (BOOL)checkValidTime {
    NSDate *currentTime = [NSDate date];
    NSDate *timePickerTime = [self.timePicker date];
    NSComparisonResult result = [timePickerTime compare:currentTime];
    if (result == NSOrderedAscending) {
        return NO;
    } else {
        return YES;
    }
}

- (void)displayInvalidTimeError {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Invalid Time"
                          message:@"The time you have selected has already passed. Please select a time in the future."
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

@end
