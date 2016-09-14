//
//  Utilities.h
//  Zup
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Utilities : NSObject


+(BOOL)isNetworkOnline;
+(BOOL)isInternetActive;
+(BOOL)isHostActive;
+(BOOL)hasInternet;

+ (void)showTabBar;
+ (void)hideTabBar;

+ (UIFont*)fontOpensSansWithSize:(float)size;
+ (UIFont*)fontOpensSansBoldWithSize:(float)size;
+ (UIFont*)fontOpensSansLightWithSize:(float)size;
+ (UIFont*)fontOpensSansExtraBoldWithSize:(float)size;

+ (UIColor*)colorRed;
+ (UIColor*)colorYellow;
+ (UIColor*)colorGray;
+ (UIColor*)colorGreen;
+ (UIColor*)colorGrayLight;
+ (UIColor*)colorBlueLight;

+ (BOOL)isIphone4inch;
+ (NSString*)setUrl:(NSString*)str Width:(int)width height:(int)height;

+ (void)alertWithMessage:(NSString*)message;
+ (void)alertWithError:(NSString*)message;
+ (void)alertWithServerError;
+ (BOOL)checkIfError:(NSDictionary*)dict;

+ (NSString*)checkIfNull:(NSString*)textToCheck;
+ (CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font;

+ (BOOL)isIpad;
+ (BOOL)isIOS7;

+ (BOOL)isValidEmail:(NSString *)checkString;
+ (BOOL)isValidCPF:(NSString*)cpf;

+ (UIColor*)colorWithHexString:(NSString*)hex;

+ (NSString *)calculateNumberOfDaysPassed:(NSString*)strDate;
+ (int)calculateDaysPassed:(NSString*)strDate;
+ (NSString*)getDateStringFromDaysPassed:(int)daysPassed;

+(float)expectedWidthWithLabel:(UILabel*)label;

+ (UIImage *)getBlackAndWhiteVersionOfImage:(UIImage *)anImage;
+ (UIImage *) getImageWithTintedColor:(UIImage *)image withTint:(UIColor *)color withIntensity:(float)alpha;
+ (UIImage *) changeColorForImage:(UIImage *)image toColor:(UIColor*)color;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (NSString*) defaultShareMessage;
+ (NSString*) socialShareTextForReportId:(int)reportId;
+ (NSString*) linkForReportId:(int)reportId;

+ (NSString*) getCurrentTenant;
+ (CLLocationCoordinate2D) getTenantInitialLocation;
+ (UIImage*) getTenantLaunchImage;
+ (NSString*) getTenantName;
+ (UIImage*) getTenantLoginImage;
+ (UIImage*) getTenantHeaderImage;

+ (UIImage*) iconForCluster:(NSDictionary*)cluster inventory:(BOOL)inv;

+ (NSDate*) todayMinusDays:(int) days;
+ (NSString*) dateToISOString:(NSDate*)date;

+ (UIBarButtonItem*) createSpacer;
+ (UIBarButtonItem*) createEdgeSpacer;

+ (BOOL) didShowTabBarView;
+ (void) setDidShowTabBarView;

@end
