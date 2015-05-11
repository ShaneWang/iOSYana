//
//  NearbyUsersMapViewController.m
//  YANA
//
//  Created by Gavin Chu on 11/11/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "NearbyUsersMapViewController.h"
#import "APIHelper.h"
#import "AppDelegate.h"
#import "User.h"
#import "Friend.h"
#import "NearbyUsersFilterViewController.h"
#import "FriendProfileViewController.h"
#import "MealRequestsNavigationController.h"
#import "MealRequestsTableViewController.h"
#import "InviteFriendsTableViewController.h"
#import "FriendsNavigationController.h"
#import "FriendsTableViewController.h"


@interface NearbyUsersMapViewController ()

@property (nonatomic,strong) User *user;

@end

@implementation NearbyUsersMapViewController

#pragma mark - Setup

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

APIHelper *apiHelper;

- (void)viewDidLoad {
    [super viewDidLoad];
    apiHelper = [[APIHelper alloc] init];
    [self initializeUser];
    
    //initialize variable for no filter
    self.hasFilter = NO;
    self.friendsOnly = NO;
    self.gender= nil;
    self.startAge = nil;
    self.endAge = nil;
    
    self.mapView.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    #ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    #endif
    [self.locationManager startUpdatingLocation];
    
    [self updateCurrentLocation];
    
    //[self addMockUserAnnotations];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //Whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    self.longitude = [NSNumber numberWithDouble:self.locationManager.location.coordinate.longitude];
    self.latitude = [NSNumber numberWithDouble:self.locationManager.location.coordinate.latitude];
    NSLog(@"latitude: %f longitude: %f", [self.latitude doubleValue], [self.longitude doubleValue]);
    
    //View Area
    CLLocationCoordinate2D userLocation = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation, 1500, 1500);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    self.range = [NSNumber numberWithInt:10];
    
    [self updateCurrentLocation];
    [self getNearbyUsers];
}

- (void)initializeUser{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)unwindFromFilter:(UIStoryboardSegue *)segue {
    NSLog(@"unwindFromFilter with identifier %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"exitFromFilter"]) {
        NSLog(@"exitFromFilter");
        NearbyUsersFilterViewController *source = [segue sourceViewController];
        self.hasFilter = YES;
        self.friendsOnly = source.friendsOnly;
        self.gender = source.gender;
        self.startAge = [NSNumber numberWithInt:source.startAge];
        self.endAge = [NSNumber numberWithInt:source.endAge];
        NSLog(@"received fitlers { friendsOnly: %@ ,\n gender: %@,\n startAge: %@,\n endAge: %@",
              self.friendsOnly ? @"YES" : @"NO", self.gender, self.startAge, self.endAge);
    }else if([segue.identifier isEqualToString:@"cancelFromFilter"]){
        //do nothing
    }
}

- (IBAction)unwindFromCreateMealRequest:(UIStoryboardSegue *)segue {
    NSLog(@"unwindFromCreateMealRequest in nearbyUsers");
    if ([segue.identifier isEqualToString:@"exitFromInviteFriends"]) {
        //update meal request table view with new meal request
        InviteFriendsTableViewController *source = [segue sourceViewController];
        if (source.mealRequestCreated && source.mealRequest) {
            //switch to meal requests tab
            self.tabBarController.selectedIndex = 0;
            MealRequestsNavigationController *requestTab = [self.tabBarController.childViewControllers objectAtIndex:0];
            MealRequestsTableViewController *requestTabView = (MealRequestsTableViewController *)requestTab.topViewController;
            [requestTabView.mealRequestsFromSelf addObject:source.mealRequest];
            [requestTabView.tableView reloadData];
        }else{
            NSLog(@"meal request is null");
        }
    }else if([segue.identifier isEqualToString:@"exitFromCreateMealRequest"]) {
        //clear friend selection
        for(Friend *friend in self.user.friends){
            friend.selected = NO;
        }
    }
}

- (IBAction)unwindFromFriendProfile:(UIStoryboardSegue *)segue {
    NSLog(@"unwindFromFriendProfile");
    if ([segue.identifier isEqualToString:@"exitFromFriendProfile"]) {
        //switch to friend list tab
        self.tabBarController.selectedIndex = 1;
        FriendsNavigationController *friendsTab = [self.tabBarController.childViewControllers objectAtIndex:0];
        FriendsTableViewController *friendsTabView = (FriendsTableViewController *)friendsTab.topViewController;
        [friendsTabView updateFriends];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue for %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"openNearbyUsersFilter"]) {
        NearbyUsersFilterViewController *destViewController = segue.destinationViewController;
        destViewController.hidesBottomBarWhenPushed = YES;
        destViewController.friendsOnly = self.friendsOnly;
        destViewController.gender = self.gender;
        destViewController.startAge = [self.startAge intValue];
        destViewController.endAge = [self.endAge intValue];
    }
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//}

#pragma mark - API Calls

- (void) updateCurrentLocation{
    NSDictionary *response = [apiHelper updateUserLocation:self.user.userid longitude:self.longitude latitude:self.latitude];
    
    if (response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
        } else {
            NSLog(@"Update location failed. Please check your internet connection or try again later.");
        }
    }else{
        NSLog(@"Update location failed. Please check your internet connection or try again later.");
    }
}

- (void) getNearbyUsers {
    [self clearAnnotations];
    
    self.nearbyUsers = [[NSMutableDictionary alloc] init];
    
    NSDictionary *response = [apiHelper getNearbyUsers:self.user.userid longitude:self.longitude latitude:self.latitude range:self.range friendsOnly:self.friendsOnly gender:self.gender startAge:self.startAge endAge:self.endAge];
    
    if(response){
        int statusCode = [[response objectForKey:@"errCode"] intValue];
        
        if([apiHelper.statusCodeDictionary[[NSString stringWithFormat: @"%d", statusCode]] isEqualToString:apiHelper.SUCCESS]){
            
            //get an array of nearby users
            NSArray *nearbyUsers = [response objectForKey:@"users"];
            NSLog(@"nearby user size: %d", [nearbyUsers count]);
            
            //create annotations and add them to self.nearbyUsers
            for(NSDictionary *user in nearbyUsers){
                
                NSString *userid = [user objectForKey:@"_id"];
                NSString *username = [user objectForKey:@"username"];
                
                NSDictionary *profile = [user objectForKey:@"profile"];
                NSString *about = nil;
                if(profile){
                    about = [profile objectForKey:@"about"];
                }
                
                //get latitude and longitude for creating annotation
                NSNumber *latitude = [user objectForKey:@"latitude"];
                NSNumber *longitude = [user objectForKey:@"longitude"];
                
                MKPointAnnotation *userAnnotation = [[MKPointAnnotation alloc] init];
                userAnnotation.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
                userAnnotation.title = username;
                if(about){
                    userAnnotation.subtitle = about;
                }
               // NSLog(@"user lat: %f long: %f", userAnnotation.coordinate.latitude, userAnnotation.coordinate.longitude);
                
                //add annotation to map view
                [self.mapView addAnnotation:userAnnotation];
                
                //save annotation and userid in self.nearbyUsers for access later
                NSDictionary *nearbyUser = [[NSDictionary alloc] initWithObjectsAndKeys:userAnnotation, @"annotation", userid, @"userid", nil];
                
                [self.nearbyUsers setObject:nearbyUser forKey:userAnnotation.title];
            }
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Get nearby users failed. Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Server Error"
                              message:@"Get nearby users failed. Please check your internet connection or try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - LocationManager tools

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceLat {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}
- (NSString *)deviceLon {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceAlt {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
}

#pragma mark - Map Annotations

- (void)addMockUserAnnotations {
    MKPointAnnotation *user1 = [[MKPointAnnotation alloc] init];
    user1.coordinate = CLLocationCoordinate2DMake(37.867427, -122.250);
    user1.title = @"User 1";
    user1.subtitle = @"about: this user is gavin and he has a long about message";
    [self.mapView addAnnotation:user1];
    
    MKPointAnnotation *user2 = [[MKPointAnnotation alloc] init];
    user2.coordinate = CLLocationCoordinate2DMake(37.867427, -122.2575);
    user2.title = @"User 2";
    [self.mapView addAnnotation:user2];
    
    MKPointAnnotation *user3 = [[MKPointAnnotation alloc] init];
    user3.coordinate = CLLocationCoordinate2DMake(37.862, -122.253364);
    user3.title = @"User 3";
    user3.subtitle = @"about: short";
    [self.mapView addAnnotation:user3];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"NearbyUserPin"];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.image = [UIImage imageNamed:@"locationPin"];
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKPointAnnotation *userAnnotation = (MKPointAnnotation *)annotation;
        NSLog(@"%@ Clicked", userAnnotation.title);
        NSDictionary *selectedUser = [[NSDictionary alloc] init];
        selectedUser = [self.nearbyUsers objectForKey:userAnnotation.title];
        FriendProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendViewController"];
        if(selectedUser){
            viewController.targetid = selectedUser[@"userid"];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Can't open friend profile. Please check your internet connection or try again later."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)clearAnnotations {
    for(id <MKAnnotation> annotation in self.mapView.annotations){
        if(![annotation isKindOfClass:[MKUserLocation class]]){
            [self.mapView removeAnnotation:annotation];
        }
    }
}

@end
