//
//  ServerOperations.m
//  Ezzi
//

#import "ServerOperations.h"
#import "TIRequestOperation.h"
#import "TIRequest.h"
#import "NSData+Base64.h"
#import "InstanceConfiguration.h"

NSString* q = @"a" @"bc";

NSString * const URL = @"";
NSString * const URLgetAddress = @"http://maps.googleapis.com/maps/api/geocode/json?latlng=";
NSString * const URLauthenticate = APIURL(@"authenticate");
NSString * const URLupdateUser = APIURL(@"users/");
NSString * const URLcreate = APIURL(@"users");
NSString * const URLrecoveryPass = APIURL(@"recover_password");
NSString * const URLuserDetails = APIURL(@"users/");
NSString * const URLpost = APIURL(@"reports/");
NSString * const URLreportCategoriesList = APIURL(@"reports/categories?display_type=full&token=");
NSString * const URLgetAddressStreey = @"http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=";
NSString * const URLgetItems = APIURL(@"search/inventory/items");
NSString * const URLgetReportItems = APIURL(@"search/reports/items");
NSString * const URLgetReportItemsForInventory = APIURL(@"reports/items?inventory_item_id=");
NSString * const URLgetReportsForCategory = APIURL(@"reports/");
NSString * const URLgetUserPosts = APIURL(@"reports/users/");
NSString * const URLgetInventoryWithId = APIURL(@"reports/inventory/");
NSString * const URLgetStats = APIURL(@"reports/stats");
NSString * const URLgetFeatureFlags = APIURL(@"feature_flags");
NSString * const URLvalidateBounds = APIURL(@"utils/city-boundary/validate");

@implementation ServerOperations

-(BOOL)method:(NSString*)param{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", URL]];
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSDictionary* jsonData = @{ @"param" : param,
                                };
    
    [postRequest setHTTPMethod:@"POST"];
    
    NSError *error;
    
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:&error];
    [postRequest setHTTPBody:postdata];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]] forHTTPHeaderField:@"Content-Length"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)getAddressWitLatitude:(float)latitude andLongitude:(float)longitude{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%f,%f&sensor=false", URLgetAddress, latitude, longitude]];
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    return [self StartRequest:postRequest];
}


-(BOOL)getAddressWithString:(NSString*)keyString{
    
    keyString = [keyString stringByReplacingOccurrencesOfString:@" " withString:@","];
    NSString *encodedSearchString = [keyString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLgetAddressStreey, encodedSearchString]];
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    return [self StartRequest:postRequest];
}


-(BOOL)getAddressWithString:(NSString*)keyString andGeo:(float)lat lng:(float)lng southLat:(float)latSouth southLng:(float)lngSouth{
    
    keyString = [keyString stringByReplacingOccurrencesOfString:@" " withString:@","];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=%@&bounds=%f,%f|%f,%f", keyString, latSouth, lngSouth, lat, lng];

    NSString *encodedSearchString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

    NSURL *url = [NSURL URLWithString:encodedSearchString];
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    return [self StartRequest:postRequest];
}

-(BOOL)authenticate:(NSString*)email pass:(NSString*)pass{
    self.isLogin = YES;
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", URLauthenticate]];
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString* token = [UserDefaults getDeviceToken];
    if (token == nil)
        token = @"";
    
    NSDictionary* jsonData = @{ @"email" : email,
                                @"password" : pass,
                                @"device_token" : token,
                                @"device_type" : @"ios"
                                };
    
    [postRequest setHTTPMethod:@"POST"];
    
    NSError *error;
    
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:&error];
    [postRequest setHTTPBody:postdata];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)createUser:(NSString*)email
             pass:(NSString*)pass
             name:(NSString*)name
            phone:(NSString*)phone
         document:(NSString*)document
          address:(NSString*)address
addressAdditional:(NSString*)addressAdditional
       postalCode:(NSString*)postalCode
         district:(NSString*)district
             city:(NSString*)city {
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", URLcreate]];
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    document = [document stringByReplacingOccurrencesOfString:@"." withString:@""];
    document = [document stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString* token = [UserDefaults getDeviceToken];
    if (token == nil)
        token = @"";
    
    NSDictionary* jsonData = @{ @"email" : email,
                                @"password" : pass,
                                @"password_confirmation" : pass,
                                @"name" : name,
                                @"phone" : phone,
                                @"document" : document,
                                @"address" : address,
                                @"address_additional" : addressAdditional,
                                @"postal_code" : postalCode,
                                @"district" : district,
                                @"city": city,
                                @"device_token" : token,
                                @"device_type" : @"ios"
                                };
    
    [postRequest setHTTPMethod:@"POST"];
    
    NSError *error;
    
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:&error];
    [postRequest setHTTPBody:postdata];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)updateUser:(NSString*)email
  currentPassword:(NSString*)currentPaassword
             pass:(NSString*)pass
             name:(NSString*)name
            phone:(NSString*)phone
         document:(NSString*)document
          address:(NSString*)address
addressAdditional:(NSString*)addressAdditional
       postalCode:(NSString*)postalCode
         district:(NSString*)district
             city:(NSString*)city {
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLupdateUser, [UserDefaults getUserId]]];
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    document = [document stringByReplacingOccurrencesOfString:@"." withString:@""];
    document = [document stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSDictionary* jsonData = @{
                               @"id" : [UserDefaults getUserId],
                               @"token" : [UserDefaults getToken],
                                @"email" : email,
                                @"current_password": currentPaassword,
                                @"password" : pass,
                                @"password_confirmation" : pass,
                                @"name" : name,
                                @"phone" : phone,
                                @"document" : document,
                                @"address" : address,
                                @"address_additional" : addressAdditional,
                                @"postal_code" : postalCode,
                                @"district" : district,
                                @"city": city
                                };
    
    [postRequest setHTTPMethod:@"PUT"];
    
    NSError *error;
    
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:&error];
    [postRequest setHTTPBody:postdata];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)recoveryPass:(NSString*)pass{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", URLrecoveryPass]];
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSDictionary* jsonData = @{ @"email" : pass
                                };
    
    [postRequest setHTTPMethod:@"PUT"];
    
    NSError *error;
    
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:&error];
    [postRequest setHTTPBody:postdata];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)getDetails{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLuserDetails, [UserDefaults getUserId]]];
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)getItems{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?display_type=basic", URLgetItems]];
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)getItemsForPosition:(float)latitude longitude:(float)longitude radius:(double)radius zoom:(float) zoom{
    
    int maxCount = 0;
    if ([Utilities isIpad] || [Utilities isIphone4inch]) maxCount = maxMarkersCountiPhone5iPad;
    else maxCount = maxMarkersCountiPhone4;
    
#warning Raio esta estranho
    radius = radius;

    // display_type=basic
    NSString *strUrl = [NSString stringWithFormat:@"%@?position[latitude]=%f&position[longitude]=%f&position[distance]=%f&limit=%i&zoom=%i&clusterize=true&return_fields=position,inventory_category_id,category_id,id,count", URLgetItems, latitude, longitude, radius, maxCount, (int)zoom];
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

-(BOOL) getItemsForPosition:(float)latitude longitude:(float)longitude radius:(double)radius zoom:(float)zoom categoryIds:(NSArray*)categoryIds
{
    int maxCount = 0;
    if ([Utilities isIpad] || [Utilities isIphone4inch]) maxCount = maxMarkersCountiPhone5iPad;
    else maxCount = maxMarkersCountiPhone4;
    
    NSString* strUrl;
    
    // display_type=basic
    if ([categoryIds count] == 0) {
        strUrl = [NSString stringWithFormat:APIURL(@"search/inventory/items?limit=%i&position[distance]=%f&position[latitude]=%f&position[longitude]=%f&zoom=%i&clusterize=true&return_fields=position,inventory_category_id,category_id,id,count"), maxCount,radius, latitude, longitude, (int)zoom];
    } else {
        NSMutableString* catIds = [[NSMutableString alloc] init];
        int i = 0;
        for(NSNumber* catid in categoryIds)
        {
            NSString* param = [NSString stringWithFormat:@"inventory_category_id[]=%i&", [catid intValue]];
            
            [catIds appendString:param];
            i++;
        }
        strUrl = [NSString stringWithFormat:APIURL(@"search/inventory/items?%@limit=%i&position[distance]=%f&position[latitude]=%f&position[longitude]=%f&zoom=%i&clusterize=true&return_fields=position,inventory_category_id,category_id,id,count"), catIds, maxCount,radius, latitude, longitude, (int)zoom];
    }
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)getItemsForPosition:(float)latitude longitude:(float)longitude radius:(double)radius zoom:(float) zoom categoryId:(int)catId{
    
    int maxCount = 0;
    if ([Utilities isIpad] || [Utilities isIphone4inch]) maxCount = maxMarkersCountiPhone5iPad;
    else maxCount = maxMarkersCountiPhone4;
    
//    NSString *strUrl = @"http://staging.zup.sapience.io/inventory/items?limit=30&position%5Bdistance%5D=518.0249592829191&position%5Blatitude%5D=-23.5481173&position%5Blongitude%5D=-46.63609300000002&zoom=17";
    
    // display_type=basic
    NSString *strUrl = [NSString stringWithFormat:APIURL(@"search/inventory/items?limit=%i&position[distance]=%f&position[latitude]=%f&position[longitude]=%f&zoom=%i&clusterize=true&inventory_category_id=%i&return_fields=position,inventory_category_id,category_id,id&count"), maxCount,radius, latitude, longitude, (int)zoom, catId];
    
//    NSString *strUrl = [NSString stringWithFormat:@"%@?position[latitude]=%f&position[longitude]=%f&position[distance]=%f&limit=%i&zoom=%f&inventory_category_id=%@", URLgetItems, latitude, longitude, radius, maxCount, zoom, catId];
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

-(BOOL) getReportItemsForPosition:(float)latitude longitude:(float)longitude radius:(double)radius zoom:(float)zoom categoryIds:(NSArray*)categoryIds sinceDate:(NSDate*)date statuses:(NSArray*)statuses
{
    int maxCount = 0;
    if ([Utilities isIpad] || [Utilities isIphone4inch]) maxCount = maxMarkersCountiPhone5iPad;
    else maxCount = maxMarkersCountiPhone4;
    
    NSString* strUrl;
    
    // begin_date reports_categories_ids statuses_ids
    NSString* strBeginDate = @"";
    NSString* strCategories = @"";
    NSString* strStatuses = @"";
    
    if(date)
    {
        strBeginDate = [NSString stringWithFormat:@"begin_date=%@&", [Utilities dateToISOString:date]];
    }
    
    if(categoryIds && categoryIds.count > 0)
    {
        strCategories = [strCategories stringByAppendingString:@"reports_categories_ids="];
        int i = 0;
        for(NSNumber* catid in categoryIds)
        {
            if(i > 0)
                strCategories = [strCategories stringByAppendingString:@","];
            
            strCategories = [strCategories stringByAppendingFormat:@"%i", [catid intValue]];
            i++;
        }
        
        strCategories = [strCategories stringByAppendingString:@"&"];
    }
    
    if(statuses && statuses.count > 0)
    {
        strStatuses = [strStatuses stringByAppendingString:@"statuses_ids="];
        int i = 0;
        for(NSNumber* statusid in statuses)
        {
            if(i > 0)
                strStatuses = [strStatuses stringByAppendingString:@","];
            
            strStatuses = [strStatuses stringByAppendingFormat:@"%i", [statusid intValue]];
            i++;
        }
        
        strStatuses = [strStatuses stringByAppendingString:@"&"];
    }
    
    strUrl = [NSString stringWithFormat:@"%@?%@%@%@position[latitude]=%f&position[longitude]=%f&position[distance]=%f&position[max_items]=%i&zoom=%f&clusterize=true&return_fields=id,category_id,created_at,status_id,position,protocol,address,reference,user.id,images,description,count", URLgetReportItems, strBeginDate, strCategories, strStatuses, latitude, longitude, radius, maxCount, zoom];

    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)getReportItemsForPosition:(float)latitude longitude:(float)longitude radius:(double)radius zoom:(float) zoom{
    
    int maxCount = 0;
    if ([Utilities isIpad] || [Utilities isIphone4inch]) maxCount = maxMarkersCountiPhone5iPad;
    else maxCount = maxMarkersCountiPhone4;
    
    // display_type=basic
    NSString *strUrl = [NSString stringWithFormat:@"%@?position[latitude]=%f&position[longitude]=%f&position[distance]=%f&position[max_items]=%i&zoom=%f&clusterize=true&return_fields=id,category_id,created_at,status_id,position,protocol,address,reference,user.id,images,description,count", URLgetReportItems, latitude, longitude, radius, maxCount, zoom];

    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)getReportItemsForInventory:(NSString*)inventId{
    
    int maxCount = 0;
    if ([Utilities isIpad] || [Utilities isIphone4inch]) maxCount = maxMarkersCountiPhone5iPad;
    else maxCount = maxMarkersCountiPhone4;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", URLgetReportItemsForInventory, inventId];
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

- (BOOL)getReportCategories {
    NSString *token = [UserDefaults getToken];
    if (token == nil) {
        token = @"";
    }
    NSURL *url = [NSURL URLWithString:[URLreportCategoriesList stringByAppendingString:token]];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:url];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)getReportsForIdCategory:(int)idCategory{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/items", URLgetReportsForCategory, [NSNumber numberWithInt:idCategory]]];
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)getInventoryForIdCategory:(int)idCategory{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/items", URLgetInventoryWithId, [NSNumber numberWithInt:idCategory]]];
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)post:(NSString*)latitude
  longitude:(NSString*)longitude
inventory_item_id:(NSString*)inventory_item_id
description:(NSString*)description
    address:(NSString*)address
     images:(NSArray*)images
 categoryId:(NSString*)catId
  reference:(NSString*)reference
   district:(NSString*)district
       city:(NSString*)city
      state:(NSString*)state
    country:(NSString*)country {
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/items", URLpost, catId]];
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (UIImage *img in images) {
        NSData *dataImage = UIImageJPEGRepresentation(img, 0.5);
        NSString *strBase64 = [dataImage base64EncodedStringWithOptions:0];
        [arr addObject:strBase64];
    }
    
    NSDictionary* jsonData;
    if (inventory_item_id.length > 0) {
        jsonData= @{
                                    @"category_id" : catId,
                                    @"inventory_item_id" : inventory_item_id,
                                    @"description" : description,
                                    @"reference" : reference,
                                    @"images" : [NSArray arrayWithArray:arr],
                                    @"token" : [UserDefaults getToken],
                                    @"id" : [UserDefaults getUserId],
                                    };

    } else {
        jsonData = @{ 
                                    @"longitude" : longitude,
                                    @"latitude" : latitude,
                                    @"category_id" : catId,
                                    @"description" : description,
                                    @"reference" : reference,
                                    @"address" : address,
                                    @"district": district,
                                    @"city": city,
                                    @"state": state,
                                    @"country": country,
                                    @"images" : [NSArray arrayWithArray:arr],
                                    @"token" : [UserDefaults getToken],
                                    @"id" : [UserDefaults getUserId],
                                    };

    }
    
    
    [postRequest setHTTPMethod:@"POST"];
    
    NSError *error;
    
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:&error];
    
    
    [postRequest setHTTPBody:postdata];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return [self StartRequest:postRequest];

}

-(BOOL)getUserPostsWithPage:(int)page{
    
    int pageNum = 0;
    if ([Utilities isIpad]) {
        pageNum = 20;
    } else {
        pageNum = 10;
    }
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/items?per_page=%i&page=%i", URLgetUserPosts, [UserDefaults getUserId], pageNum, page]];
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}


-(BOOL)getReportDetailsWithId:(int)idCategory {
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:APIURL(@"reports/items/%i"), idCategory]];
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)getInventoryDetailsWithId:(NSString*)idCategory idItem:(NSString*)idItem {
    
    NSString *token = [UserDefaults getToken];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:APIURL(@"inventory/categories/%@/items/%@?token=%@"), idCategory, idItem, token]];
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}


-(BOOL)getStats {
    
    NSURL* url = [NSURL URLWithString:URLgetStats];
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

- (BOOL) validateBoundariesWithLatitude:(float)latitude longitude:(float)longitude
{
    NSString* urlString = [NSString stringWithFormat:@"%@?latitude=%f&longitude=%f", URLvalidateBounds, latitude, longitude];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    return [self StartRequest:request];
}


-(BOOL)getStatsWithFilter:(int)days categoryId:(int)categoryId{
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strToday = [formatter stringFromDate:today];
    
    NSString *earlierStr = [Utilities getDateStringFromDaysPassed:days];
    
    NSURL* url = nil;
    
    if (categoryId == 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?begin_date=%@&end_date=%@", URLgetStats, earlierStr, strToday]];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?category_id=%i&begin_date=%@&end_date=%@", URLgetStats, categoryId ,earlierStr, strToday]];
    }
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)getStatsWithFilter:(int)days categoryIds:(NSArray*)categoryIds{
    NSString* strToday = [Utilities getDateStringFromDaysPassed:-1];
    
    NSString *earlierStr = [Utilities getDateStringFromDaysPassed:days];
    
    NSURL* url = nil;
    
    if ([categoryIds count] == 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?begin_date=%@&end_date=%@", URLgetStats, earlierStr, strToday]];
    } else {
        NSMutableString* catIds = [[NSMutableString alloc] init];
        int i = 0;
        for(NSNumber* catid in categoryIds)
        {
            NSString* param = [NSString stringWithFormat:@"category_id[]=%i&", [catid intValue]];
            
            [catIds appendString:param];
            i++;
        }
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@begin_date=%@&end_date=%@", URLgetStats, catIds ,earlierStr, strToday]];
    }
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

-(BOOL)getFeatureFlags
{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", URLgetFeatureFlags]];
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

- (BOOL)getReportComments:(int)reportId
{
    NSString* token = [UserDefaults getToken];
    if(token == nil)
        token = @"";
    
    NSString* strUrl = [NSString stringWithFormat:APIURL(@"reports/%i/comments?token=%@"), reportId, token];
    
    NSURL* url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:url];
    
    [postRequest setHTTPMethod:@"GET"];
    
    return [self StartRequest:postRequest];
}

- (BOOL) flagReportAsOffensive:(int)reportId
{
    NSString* strUrl = [NSString stringWithFormat:APIURL(@"reports/items/%i/offensive"), reportId];
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [postRequest setHTTPMethod:@"PUT"];
    
    return [self StartRequest:postRequest];
}

- (BOOL) unflagReportAsOffensive:(int)reportId
{
    NSString* strUrl = [NSString stringWithFormat:APIURL(@"reports/items/%i/offensive"), reportId];
    
    NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [postRequest setHTTPMethod:@"DELETE"];
    
    return [self StartRequest:postRequest];
}

+ (NSString*) baseAPIUrl
{
    return BASE_API_URL;
}

@end
