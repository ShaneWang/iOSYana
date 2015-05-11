//
//  MealRequest.m
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "MealRequest.h"

@interface MealRequest ()

@end

@implementation MealRequest

//used by CreateMealRequestViewController
- (instancetype) initWithUserid:(NSString *)ownerid
                       username:(NSString *)username
                           type:(NSString *)type
                           time:(NSString *)time
                     restaurant:(NSString *)restaurant
                        comment:(NSString *)comment {
    self = [super init];
    if(self){
        self.ownerid = ownerid;
        self.ownerUsername = username;
        self.type= type;
        self.time = time;
        self.restaurant = restaurant;
        self.comment = comment;
        
        self.isSelf = YES;
        self.matched = NO;
        self.responded = NO;
        self.accepted = NO;
    }
    return self;
}

//used by InviteFriendsViewController
- (void) addInvitedFriends:(NSMutableArray *)friends {
    self.invitedFriends = friends;
}

- (instancetype) initWithRequestId:(NSString *)requestid
                           ownerid:(NSString *)ownerid
                         ownername:(NSString *)ownerUsername
                              type:(NSString *)type
                              time:(NSString *)time
                        restaurant:(NSString *)restaurant
                           comment:(NSString *)comment
                      acceptedUser:(NSString *)acceptedUser
                     declinedUsers:(NSMutableArray *)declinedUsers
                            selfId:(NSString *)selfid{
    self = [super init];
    if(self){
        self.requestid = requestid;
        self.ownerid = ownerid;
        self.ownerUsername= ownerUsername;
        self.type = type;
        self.time = time;
        self.restaurant = restaurant;
        self.comment = comment;
        self.acceptedUser = acceptedUser;
        self.declinedUsers = declinedUsers;
        
        if([self.acceptedUser isEqualToString:@""]){
            self.matched = NO;
        }else{
            self.matched = YES;
        }
        
        if([self.declinedUsers containsObject:selfid]){
            self.responded = YES;
            self.accepted = NO;
        }else{
            self.responded = NO;
        }
        
        if([ownerid isEqualToString:selfid]){
            self.isSelf = YES;
        }else{
            self.isSelf = NO;
        }
    }
    return self;
}

//MealRequestsTableViewController
- (instancetype) initForSelfWithRequestId:(NSString *)requestid
                                  ownerid:(NSString *)ownerid
                                ownername:(NSString *)ownerUsername
                                     type:(NSString *)type
                                     time:(NSString *)time
                               restaurant:(NSString *)restaurant
                                  comment:(NSString *)comment
                             acceptedUser:(NSString *)acceptedUser
                            declinedUsers:(NSMutableArray *)declinedUsers {
    self = [super init];
    if(self){
        self.requestid = requestid;
        self.ownerid = ownerid;
        self.ownerUsername= ownerUsername;
        self.type = type;
        self.time = time;
        self.restaurant = restaurant;
        self.comment = comment;
        self.acceptedUser = acceptedUser;
        self.declinedUsers = declinedUsers;
        
        if([self.acceptedUser isEqualToString:@""]){
            self.matched = NO;
        }else{
            self.matched = YES;
        }
        
        self.isSelf = YES;
    }
    return self;
}

- (instancetype) initForOthersWithRequestId:(NSString *)requestid
                                    ownerid:(NSString *)ownerid
                                  ownername:(NSString *)ownerUsername
                                       type:(NSString *)type
                                       time:(NSString *)time
                                 restaurant:(NSString *)restaurant
                                    comment:(NSString *)comment
                               acceptedUser:(NSString *)acceptedUser
                              declinedUsers:(NSMutableArray *)declinedUsers
                                     selfId:(NSString *)selfid {
    self = [super init];
    if(self){
        self.requestid = requestid;
        self.ownerid = ownerid;
        self.ownerUsername= ownerUsername;
        self.type = type;
        self.time = time;
        self.restaurant = restaurant;
        self.comment = comment;
        self.acceptedUser = acceptedUser;
        self.declinedUsers = declinedUsers;
        
        if([self.acceptedUser isEqualToString:@""]){
            self.matched = NO;
        }else{
            self.matched = YES;
        }
        
        if([self.declinedUsers containsObject:selfid]){
            self.responded = YES;
            self.accepted = NO;
        }else{
            self.responded = NO;
        }
        
        self.isSelf = YES;
    }
    return self;
}

- (void) toString{
    NSLog(@"Meal Request Object:  \n\trequestid: %@  \n\towner: %@ \n\ttype: %@  \n\t time: %@  \n\t  restaurant: %@ \n\t acceptedUser: %@",
          self.requestid, self.ownerid, self.type, self.time, self.restaurant, self.acceptedUser);
}

- (NSString *) getBOOLString:(BOOL)condition{
    if(condition){
        return @"YES";
    }else{
        return @"NO";
    }
}

@end
