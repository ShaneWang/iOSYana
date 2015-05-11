//
//  User.h
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSMutableArray *friends; //array of Friend
@property (nonatomic, strong) NSMutableArray *friendsWhoAddedYou; //array of Friend Requests
@property (nonatomic, strong) NSMutableArray *mealRequests; //array of MealRequest

- (instancetype) initWithUserid:(NSString *)userid
                       username:(NSString *)username;

- (void) toString;

@end
