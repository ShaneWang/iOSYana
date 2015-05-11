//
//  Friend.m
//  YANA
//
//  Created by Gavin Chu on 10/20/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import "Friend.h"

@implementation Friend

- (instancetype) initWithid:(NSString *)friendid andUsername:(NSString *)username{
    self = [super init];
    if(self){
        self.friendid = friendid;
        self.friendUsername = username;
    }
    return self;
}

- (void) toString{
    NSLog(@"Friend Object:\n\tusername:%@\n\tuserid:%@",
          self.friendUsername, self.friendid);
}

@end
