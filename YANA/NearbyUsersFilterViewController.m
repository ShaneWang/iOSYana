//
//  NearbyUsersFilterViewController.m
//  YANA
//
//  Created by Gavin Chu on 11/18/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "NearbyUsersFilterViewController.h"
#import "NearbyUsersMapViewController.h"

@interface NearbyUsersFilterViewController ()

@end

@implementation NearbyUsersFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resumeFilters];
}

//preset filter to last filtered state
- (void)resumeFilters {
    [self configureFriendsOnlySwitch];
    [self configureGenderSegmentControl];
    [self configureAgeSlider];
    
    NSLog(@"resumed fitlers { friendsOnly: %@ ,\n gender: %@,\n startAge: %d,\n endAge: %d",
          self.friendsOnly ? @"YES" : @"NO", self.gender, self.startAge, self.endAge);
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateSliderLabels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureFriendsOnlySwitch {
    if(self.friendsOnly){
        [self.friendsOnlySwitch setOn:YES animated:NO];
    }else{
        [self.friendsOnlySwitch setOn:NO animated:NO];
    }
}

- (void)configureGenderSegmentControl {
    if([self.gender isEqualToString:@"Male"]){
        [self.genderSegmentControl setSelectedSegmentIndex:1];
    }else if([self.gender isEqualToString:@"Female"]){
        [self.genderSegmentControl setSelectedSegmentIndex:2];
    }else if([self.gender isEqualToString:@"Other"]){
        [self.genderSegmentControl setSelectedSegmentIndex:3];
    }else{
        [self.genderSegmentControl setSelectedSegmentIndex:0];
    }
}

- (void)configureAgeSlider{
    if(self.startAge == 0 && self.endAge == 0){//age range never initialized
        self.startAge = 0;
        self.endAge = 50;
    }
    self.ageRangeSlider.lowerValue = [self getNormalizeAge:self.startAge];
    self.ageRangeSlider.upperValue = [self getNormalizeAge:self.endAge];
    
    [self initializeAgeLabels];
}

- (void)initializeAgeLabels{
    //programmatically add age label positioned above slider center
    self.lowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.ageRangeSlider.lowerCenter.x + self.ageRangeSlider.frame.origin.x, self.ageRangeSlider.center.y - 30.0f, 20, 20)];
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.ageRangeSlider.lowerValue];
    [self.view addSubview:self.lowerLabel];
    
    self.upperLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.ageRangeSlider.upperCenter.x + self.ageRangeSlider.frame.origin.x, self.ageRangeSlider.center.y - 30.0f, 20, 20)];
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.ageRangeSlider.upperValue];
    [self.view addSubview:self.upperLabel];
}

- (void)updateSliderLabels{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.ageRangeSlider.lowerCenter.x + self.ageRangeSlider.frame.origin.x);
    lowerCenter.y = (self.ageRangeSlider.center.y - 30.0f);
    self.lowerLabel.center = lowerCenter;
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", [self getActualAgeFromNormalizedAge:self.ageRangeSlider.lowerValue]];
    
    
    CGPoint upperCenter;
    upperCenter.x = (self.ageRangeSlider.upperCenter.x + self.ageRangeSlider.frame.origin.x);
    upperCenter.y = (self.ageRangeSlider.center.y - 30.0f);
    self.upperLabel.center = upperCenter;
    self.upperLabel.text = [NSString stringWithFormat:@"%d", [self getActualAgeFromNormalizedAge:self.ageRangeSlider.upperValue]];
    
}

// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender{
    [self updateSliderLabels];
    self.startAge = [self getActualAgeFromNormalizedAge:self.ageRangeSlider.lowerValue];
    self.endAge = [self getActualAgeFromNormalizedAge:self.ageRangeSlider.upperValue];
}

- (IBAction)friendsOnlySwitched:(UISwitch *)sender {
    if(sender.isOn){
        self.friendsOnly = YES;
    }else{
        self.friendsOnly = NO;
    }
}

- (IBAction)genderSelected:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 0){
        self.gender = nil;
    }else if(sender.selectedSegmentIndex == 1){
        self.gender = @"male";
    }else if(sender.selectedSegmentIndex == 2){
        self.gender = @"female";
    }else if(sender.selectedSegmentIndex == 3){
        self.gender = @"other";
    }
}

#define MAX_AGE ((float)50)

- (float)getNormalizeAge:(int)actualAge {
    return actualAge/MAX_AGE;
}

- (int)getActualAgeFromNormalizedAge:(float)normalizedAge {
    return normalizedAge * MAX_AGE;
}

@end
