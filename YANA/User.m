//
//  User.m
//  YANA
//
//  Created by Gavin Chu on 10/15/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "User.h"

@interface User ()

@end

@implementation User

- (instancetype) initWithUserid:(NSString *)userid
             username:(NSString *)username {
    self = [super init];
    if(self){
        self.userid = userid;
        self.username = username;
    }
    return self;
}

- (void) toString{
    NSLog(@"User Object:\n\tusername:%@\n\tuserid:%@\n\tfriends:%@\n\tfriendRequests:%@\n\tmealRequests:%@",
          self.username, self.userid, self.friends, self.friendsWhoAddedYou, self.mealRequests);
}

@end
