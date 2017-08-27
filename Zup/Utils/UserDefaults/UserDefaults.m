//
//  UserDefaults.m
//  Zup
//

#import "UserDefaults.h"

@implementation UserDefaults

+(void)setUserId:(NSString*)userId {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:userId forKey:@"userId"];
    [prefs synchronize];
}

+(NSString*)getPass{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:@"pass"];
}

+(void)setPass:(NSString*)pass {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:pass forKey:@"pass"];
    [prefs synchronize];
}

+(NSString*)getUserId{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:@"userId"];
}

+(void)setToken:(NSString*)token {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:token forKey:@"token"];
    [prefs synchronize];
}

+(NSString*)getToken{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:@"token"];
}

+(void)setFeatureFlags:(NSArray*)arr {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:arr forKey:@"featureFlags"];
    [prefs synchronize];
}

+(NSArray*)getFeatureFlags {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:@"featureFlags"];
}

+ (BOOL)isFeatureEnabled:(NSString*)feature
{
    for (NSDictionary* flag in [UserDefaults getFeatureFlags])
    {
        NSString* name = [flag valueForKey:@"name"];
        NSString* status = [flag valueForKey:@"status"];
        
        if([name isEqualToString:feature])
        {
            return ![status isEqualToString:@"disabled"];
        }
    }
    
    return YES;
}

+(void)setDeviceToken:(NSString*)token {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:token forKey:@"deviceToken"];
    [prefs synchronize];
}

+(NSString*)getDeviceToken{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:@"deviceToken"];
}

+(void)setIsUserLoggedOnSocialNetwork:(SocialNetworkType)type {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:type forKey:@"socialNetworkType"];
    [prefs synchronize];
}

+(SocialNetworkType)getSocialNetworkType{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs integerForKey:@"socialNetworkType"];
}

+(void)setIsUserLogged:(BOOL)isLogged {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSNumber numberWithBool:isLogged] forKey:@"isLogged"];
    [prefs synchronize];
}

+(BOOL)isUserLogged{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs boolForKey:@"isLogged"];
}


+(void)setFacebookImage:(UIImage*)image {
    NSData *dataImg = UIImagePNGRepresentation(image);
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:dataImg forKey:@"facebookImage"];
    [prefs synchronize];
}

+(UIImage*)getFacebookImage{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSData *dataImg = [prefs valueForKey:@"facebookImage"];
    UIImage *imgUser = [UIImage imageWithData:dataImg];
    
    return imgUser;
}



+ (void)addFavorite:(NSString*)idLook {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrFavorites = [NSMutableArray arrayWithArray:[defaults objectForKey:@"favorites"]];
    
    if (!arrFavorites) {
        arrFavorites = [[NSMutableArray alloc]init];
    }
    
    [arrFavorites addObject:idLook];
    
    [defaults setObject:arrFavorites forKey:@"favorites"];
    [defaults synchronize];
}

+ (void)removeFavorite:(NSString*)idLook {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrFavorites = [NSMutableArray arrayWithArray:[defaults objectForKey:@"favorites"]];
    
    if (!arrFavorites) {
        return;
    }
    
    [arrFavorites removeObject:idLook];
    
    [defaults setObject:arrFavorites forKey:@"favorites"];
    [defaults synchronize];
}


+ (NSArray*)getFavorites {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"favorites"];
}


+ (BOOL)checkIfFavorite:(NSString*)idLook {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrFavorites = [NSArray arrayWithArray:[defaults objectForKey:@"favorites"]];
    
    if (!arrFavorites) {
        arrFavorites = [[NSMutableArray alloc]init];
        return NO;
    }
    
    if ([arrFavorites containsObject:idLook])
        return YES;
    
    return NO;
    
}

+(void)setIsFromPush:(BOOL)isFromPush {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:isFromPush forKey:@"isFromPush"];
    [prefs synchronize];
}

+(BOOL)isFromPush{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs boolForKey:@"isFromPush"];
}

+(void)saveDictFromPush:(NSDictionary*)dict {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:dict forKey:@"dictFromPush"];
    [prefs synchronize];
}

+(NSDictionary*)getDictFromPush{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs objectForKey:@"dictFromPush"];
}

+(void)setFbToken:(NSString*)token {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:token forKey:@"fbToken"];
    [prefs synchronize];
}

+(NSString*)getFbToken{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:@"fbToken"];
}

+(void)setFbPublishToken:(NSString*)token {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:token forKey:@"fbPublishToken"];
    [prefs synchronize];
}

+(NSString*)getFbPublishToken{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:@"fbPublishToken"];
}


+(void)setReportCategories:(NSArray*)arr {
    NSMutableArray* newarr = [[NSMutableArray alloc] init];
    
    for(NSDictionary* dict in arr)
    {
        if(![[dict valueForKey:@"private"] boolValue])
           [newarr addObject:dict];
    }
    
    /*for(NSDictionary* dict in arr)
    {
        NSMutableDictionary* newdict = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        int catid = [[dict valueForKey:@"id"] intValue];
        [newdict setValue:[NSNumber numberWithInt:catid] forKey:@"parent_id"];
        [newdict setValue:[NSNumber numberWithInt:catid + 100] forKey:@"id"];
        
        [newarr addObject:newdict];

        NSMutableDictionary* newdict2 = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        [newdict2 setValue:[NSNumber numberWithInt:catid] forKey:@"parent_id"];
        [newdict2 setValue:[NSNumber numberWithInt:catid + 501] forKey:@"id"];
        
        [newarr addObject:newdict2];

        
        NSMutableDictionary* newdict3 = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        [newdict3 setValue:[NSNumber numberWithInt:catid] forKey:@"parent_id"];
        [newdict3 setValue:[NSNumber numberWithInt:catid + 902] forKey:@"id"];
        
        [newarr addObject:newdict3];

    }*/
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:newarr forKey:@"categoriesArray"];
    [prefs synchronize];
}

+(NSArray*) getReportSubCategories:(int)idCat
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [prefs valueForKey:@"categoriesArray"];
    
    for (NSDictionary *dict in arr)
    {
        if ([dict objectForKey:@"parent_id"] != nil && [[dict objectForKey:@"parent_id"] intValue] == idCat)
        {
            [result addObject:dict];
        }
    }
    
    return result;
}

+(NSArray*) getReportRootCategories
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [prefs valueForKey:@"categoriesArray"];
    
    for (NSDictionary *dict in arr)
    {
        if ([dict objectForKey:@"parent_id"] == nil)
        {
            [result addObject:dict];
        }
    }
    
    return result;
}

+(NSArray*)getReportCategories{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:@"categoriesArray"];
}

+(NSDictionary*)getCategory:(int)idCat{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    
    NSArray *arr = [prefs valueForKey:@"categoriesArray"];
    
    for (NSDictionary *dict in arr) {
        if ([[dict valueForKey:@"id"]intValue] == idCat) {
            return dict;
        }
    }
    
    return nil;
}



+(void)setInventoryCategories:(NSArray*)arr {
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:arr forKey:@"inventoryCategoriesArray"];
    [prefs synchronize];
}

+(NSArray*)getInventoryCategories{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:@"inventoryCategoriesArray"];
}

+(NSDictionary*)getInventoryCategory:(int)idCat{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    
    NSArray *arr = [prefs valueForKey:@"inventoryCategoriesArray"];
    
    for (NSDictionary *dict in arr) {
        if ([[dict valueForKey:@"id"]intValue] == idCat) {
            return dict;
        }
    }
    
    return nil;
}

+ (NSArray*)getSectionsFroInventoryId:(int)idCat {

    NSDictionary *dicCat = [UserDefaults getInventoryCategory:idCat];
    
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:[dicCat valueForKey:@"sectionsData"]];
    
    return arr;
}

+ (NSString*)getTitleForFieldId:(int)idField idCat:(int)idCat {
    
    NSArray *arrSections = [UserDefaults getSectionsFroInventoryId:idCat];
    
    for (NSDictionary *dictSection in arrSections) {
        for (NSDictionary *dictTemp in [dictSection valueForKey:@"fields"]) {
            if ([[dictTemp valueForKey:@"id"]intValue] == idField) {
                NSString *label = [dictTemp valueForKey:@"label"];

                if ([label isEqual:[NSNull null]]) {
                    label = [dictTemp valueForKey:@"title"];
                }
                
                return label;
            }
        }
    }
    return nil;
}

@end
