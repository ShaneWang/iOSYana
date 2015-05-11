//
//  NearbyUsersMapViewController.h
//  YANA
//
//  Created by Gavin Chu on 11/11/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NearbyUsersMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;

@property (strong, nonatomic) NSMutableDictionary *nearbyUsers; //key = username/annotation.title; value = {"annotation" : MKPointAnnotation, "userid" : user_id

@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *range;

@property BOOL hasFilter;
@property BOOL friendsOnly;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSNumber *startAge;
@property (strong, nonatomic) NSNumber *endAge;

@end
