

#import <Foundation/Foundation.h>
#import "MealRequest.h"

@interface APIHelper : NSObject

extern NSString* const base_url;

extern NSString* const action_create_user;
extern NSString* const action_login;
extern NSString* const action_logout;
extern NSString* const action_create_request;
extern NSString* const action_view_requests;
extern NSString* const action_handle_meal_request;
extern NSString* const action_delete_meal_request;
extern NSString* const action_search_users_by_name;
extern NSString* const action_search_users_by_id;
extern NSString* const action_add_friend;
extern NSString* const action_delete_friend;
extern NSString* const action_get_friend_list;
extern NSString* const action_get_profile_by_id;
extern NSString* const action_update_device_token;
extern NSString* const aciton_update_current_locaiton;
extern NSString* const action_get_nearby_users;

@property (nonatomic, strong) NSString* SUCCESS;
@property (nonatomic, strong) NSString* INVALID_USERNAME;
@property (nonatomic, strong) NSString* INVALID_PASSWORD;
@property (nonatomic, strong) NSString* USERNAME_ALREADY_EXISTS;
@property (nonatomic, strong) NSString* WRONG_USERNAME_OR_PASSWORD;
@property (nonatomic, strong) NSString* INVALID_USER_ID;
@property (nonatomic, strong) NSString* ALREADY_FOLLOWED;
@property (nonatomic, strong) NSString* INVALID_FRIEND_ID;
@property (nonatomic, strong) NSString* INVALID_PARAMS;
@property (nonatomic, strong) NSString* INVALID_ACTION;
@property (nonatomic, strong) NSString* MEAL_REQUEST_EXPIRED;
@property (nonatomic, strong) NSString* NO_PERMISSION;
@property (nonatomic, strong) NSString* NOT_FOLLOWING;
@property (nonatomic, strong) NSString* INVALID_REQUEST_ID;
@property (nonatomic, strong) NSString* ERROR;

@property (nonatomic, strong) NSDictionary* statusCodeDictionary;

- (NSDictionary *) createUserWithUsername:(NSString *)username
                          andPassword:(NSString *)password;
- (NSDictionary *) loginWithUsername:(NSString *)username
                     andPassword:(NSString *)password;
- (NSDictionary *) loginWithFacebook:(NSString *)facebook_id
                         AndUsername:(NSString *)username
                            AndEmail:(NSString *)email;

- (NSDictionary *) logout:(NSString *)userid;

- (NSDictionary *) createMealRequest:(MealRequest *)mealRequest;
- (NSDictionary *) getAllMealRequests:(NSString *)userid;
- (NSDictionary *) handleMealRequestsForRequest:(NSString *)req_id
                                     WithAction:(NSString *)action
                                        ForUser:(NSString *)userid;
- (NSDictionary *) deleteMealRequestWithID: (NSString *)req_id;

- (NSDictionary *) searchUserByUsername:(NSString *)username;
- (NSDictionary *) searchUserById:(NSString *)userid;
- (NSDictionary *) addFriend:(NSString *)friendid
                   toYou:(NSString *)userid;
- (NSDictionary *) deleteFriend:(NSString *)friendid
                    fromYou:(NSString *)userid;

- (NSDictionary *) getFriendList:(NSString *)userid;
- (NSDictionary *) getFriendRequests:(NSString *)userid;

- (NSDictionary *) getProfile:(NSString *)userid
                     targetid:(NSString *)targetid;

- (NSDictionary *) editProfile: (NSString *)userid
                   withPrivacy: (NSNumber *) privacy
                         about: (NSString *)about
                        gender: (NSString *)gender
                           age: (NSNumber *) age
               foodPreferences: (NSString *)foodPreferences
                   phoneNumber: (NSString *)phoneNumber;


- (NSDictionary *) updateDeviceToken:(NSString *)deviceToken
                             forUser:(NSString *)userid;

- (NSDictionary *) updateUserLocation:(NSString *)userid
                            longitude:(NSNumber *)longitude
                             latitude:(NSNumber *)latitude;

- (NSDictionary *) getNearbyUsers:(NSString *)userid
                        longitude:(NSNumber *)longitude
                         latitude:(NSNumber *)latitude
                            range:(NSNumber *)range
                      friendsOnly:(BOOL)friendsOnly
                           gender:(NSString *)gender
                         startAge:(NSNumber *)startAge
                           endAge:(NSNumber *)endAge;

- (NSString *) getParametersForActionGetNearbyUsers:(NSString *)userid
                                        longitude:(NSNumber *)longitude
                                         latitude:(NSNumber *)latitude
                                            range:(NSNumber *)range
                                      friendsOnly:(BOOL)friendsOnly
                                           gender:(NSString *)gender
                                         startAge:(NSNumber *)startAge
                                           endAge:(NSNumber *)endAge;


@end
