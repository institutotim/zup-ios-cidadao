//
//  ServerOperations.h
//  Ezzi
//

#import <Foundation/Foundation.h>
#import "TIRequestOperation.h"

@interface ServerOperations : TIRequestOperation

-(BOOL)method:(NSString*)param;

-(BOOL)getAddressWitLatitude:(float)latitude andLongitude:(float)longitude;
-(BOOL)authenticate:(NSString*)email pass:(NSString*)pass;

-(BOOL)createUser:(NSString*)email
             pass:(NSString*)pass
             name:(NSString*)name
            phone:(NSString*)phone
         document:(NSString*)document
          address:(NSString*)address
addressAdditional:(NSString*)addressAdditional
       postalCode:(NSString*)postalCode
         district:(NSString*)district
             city:(NSString*)city;


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
             city:(NSString*)city;

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
    country:(NSString*)country;


-(BOOL)recoveryPass:(NSString*)pass;
-(BOOL)getDetails;
-(BOOL)getReportCategories;
-(BOOL)getItems;
//-(BOOL)getInventoryCategories;
-(BOOL)getFeatureFlags;

-(BOOL)getAddressWithString:(NSString*)keyString;
-(BOOL)getReportsForIdCategory:(int)idCategory;
-(BOOL)getUserPostsWithPage:(int)page;
-(BOOL)getReportDetailsWithId:(int)idCategory;

-(BOOL)getInventoryForIdCategory:(int)idCategory;

-(BOOL)getItemsForPosition:(float)latitude longitude:(float)longitude radius:(double)radius zoom:(float) zoom;

-(BOOL)getItemsForPosition:(float)latitude longitude:(float)longitude radius:(double)radius zoom:(float) zoom categoryId:(int)catId;


-(BOOL) getItemsForPosition:(float)latitude longitude:(float)longitude radius:(double)radius zoom:(float)zoom categoryIds:(NSArray*)categoryIds;

-(BOOL) getReportItemsForPosition:(float)latitude longitude:(float)longitude radius:(double)radius zoom:(float)zoom categoryIds:(NSArray*)categoryIds sinceDate:(NSDate*)date statuses:(NSArray*)statuses;
//-(BOOL)getReportItemsForPosition:(float)latitude longitude:(float)longitude radius:(double)radius zoom:(float) zoom;

- (BOOL) flagReportAsOffensive:(int)reportId;
- (BOOL) unflagReportAsOffensive:(int)reportId;

-(BOOL)getInventoryDetailsWithId:(NSString*)idCategory idItem:(NSString*)idItem;

-(BOOL)getStats;
-(BOOL)getStatsWithFilter:(int)days categoryId:(int)categoryId;
-(BOOL)getStatsWithFilter:(int)days categoryIds:(NSArray*)categoryIds;

-(BOOL)getAddressWithString:(NSString*)keyString andGeo:(float)lat lng:(float)lng southLat:(float)latSouth southLng:(float)lngSouth;

-(BOOL)getReportItemsForInventory:(NSString*)inventId;

//+ (NSString*) baseWebUrl;
+ (NSString*) baseAPIUrl;

- (BOOL)getReportComments:(int)reportId;
- (BOOL) validateBoundariesWithLatitude:(float)latitude longitude:(float)longitude;


@end
