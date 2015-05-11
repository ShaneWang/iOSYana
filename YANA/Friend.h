//
//  Friend.h
//  YANA
//
//  Created by Gavin Chu on 10/20/14.
//  Copyright (c) 2014 CS169. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (nonatomic, strong) NSString *friendid;
@property (nonatomic, strong) NSString *friendUsername;
@property BOOL selected;

- (instancetype) initWithid:(NSString *)friendid andUsername:(NSString *)username;

- (void) toString;

@end
