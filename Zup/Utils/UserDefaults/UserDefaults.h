//
//  UserDefaults.h
//  Zup
//

#import <Foundation/Foundation.h>

typedef enum {
    kSocialNetworFacebook,
    kSocialNetworTwitter,
    kSocialNetworGooglePlus,
    kSocialNetworkAnyone,
} SocialNetworkType;

@interface UserDefaults : NSObject

+(void)setIsUserLoggedOnSocialNetwork:(SocialNetworkType)type;
+(SocialNetworkType)getSocialNetworkType;

+(void)setIsUserLogged:(BOOL)isLogged;
+(BOOL)isUserLogged;

+(void)setUserId:(NSString*)userId;
+(NSString*)getUserId;

+(NSString*)getPass;
+(void)setPass:(NSString*)pass;

+(void)setFacebookImage:(UIImage*)image;
+(UIImage*)getFacebookImage;

+(void)setToken:(NSString*)token;
+(NSString*)getToken;

+(void)setDeviceToken:(NSString*)token;
+(NSString*)getDeviceToken;

+(void)setIsFromPush:(BOOL)isFromPush;
+(BOOL)isFromPush;

+(void)setFbToken:(NSString*)token;
+(NSString*)getFbToken;

+(void)setFbPublishToken:(NSString*)token;
+(NSString*)getFbPublishToken;

+(void)setFeatureFlags:(NSArray*)arr;
+(BOOL)isFeatureEnabled:(NSString*)feature;

+(void)setReportCategories:(NSArray*)arr;
+(NSArray*)getReportCategories;
+(NSDictionary*)getCategory:(int)idCat;
+(NSArray*)getReportSubCategories:(int)idCat;
+(NSArray*)getReportRootCategories;

+(void)setInventoryCategories:(NSArray*)arr;
+(NSArray*)getInventoryCategories;
+(NSDictionary*)getInventoryCategory:(int)idCat;
+ (NSArray*)getSectionsFroInventoryId:(int)idCat;
+ (NSString*)getTitleForFieldId:(int)idField idCat:(int)idCat;

@end
