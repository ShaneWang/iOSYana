//
//  MealRequest.h
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MealRequest : NSObject

@property (nonatomic, strong) NSString *requestid; //meal request id from databae primary key
@property (nonatomic, strong) NSString *ownerid; //userid of meal reqeust owner
@property (nonatomic, strong) NSString *ownerUsername; //self or friend username for display purposes

@property (nonatomic, strong) NSString *type; //breakfast, lunch, dinner, other
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *restaurant; //optional
@property (nonatomic, strong) NSString *comment; //only assigned if type == other

@property (nonatomic, strong) NSMutableArray *invitedFriends; //list of friend ids (invitations)
@property (nonatomic, strong) NSString *acceptedUser; //userid of friend who accepted the request; "" if no one accepted the request
@property (nonatomic, strong) NSMutableArray *declinedUsers;

@property (nonatomic) BOOL isSelf; //used to determine if the request is made by self or others
@property (nonatomic) BOOL matched; //bool used for self requests
@property (nonatomic) BOOL responded; //used to display buttons or message
@property (nonatomic) BOOL accepted; //used to determine message

- (instancetype) initWithUserid:(NSString *)ownerid
                       username:(NSString *)username
                           type:(NSString *)type
                           time:(NSString *)time
                     restaurant:(NSString *)restaurant
                        comment:(NSString *)comment;

- (void) addInvitedFriends:(NSMutableArray *)friends;

- (instancetype) initWithRequestId:(NSString *)requestid
                           ownerid:(NSString *)ownerid
                         ownername:(NSString *)ownerUsername
                              type:(NSString *)type
                              time:(NSString *)time
                        restaurant:(NSString *)restaurant
                           comment:(NSString *)comment
                      acceptedUser:(NSString *)acceptedUser
                     declinedUsers:(NSMutableArray *)declinedUsers
                            selfId:(NSString *)selfid;

- (instancetype) initForSelfWithRequestId:(NSString *)requestid
                                  ownerid:(NSString *)ownerid
                                ownername:(NSString *)ownerUsername
                                     type:(NSString *)type
                                     time:(NSString *)time
                               restaurant:(NSString *)restaurant
                                  comment:(NSString *)comment
                             acceptedUser:(NSString *)acceptedUser
                            declinedUsers:(NSMutableArray *)declinedUsers;


- (instancetype) initForOthersWithRequestId:(NSString *)requestid
                                    ownerid:(NSString *)ownerid
                                  ownername:(NSString *)ownerUsername
                                       type:(NSString *)type
                                       time:(NSString *)time
                                 restaurant:(NSString *)restaurant
                                    comment:(NSString *)comment
                               acceptedUser:(NSString *)acceptedUser
                              declinedUsers:(NSMutableArray *)declinedUsers
                                     selfId:(NSString *)selfid;

- (void) toString;

@end
