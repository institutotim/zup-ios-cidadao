//
//  Utilities.m
//  Zup
//

#import "Utilities.h"
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>
#import "UIApplication+name.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>
#import "ImageCache.h"
#import "ApiNetworkingManager.h"
#import "InstanceConfiguration.h"

@implementation Utilities

+(BOOL)hasInternet{
    Reachability* reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus network = [reach currentReachabilityStatus];
    return network != NotReachable;
}

static BOOL internetActive;
static BOOL hostActive;
static BOOL hasInternetChecked;
static BOOL didShowMain = false;

+ (BOOL)didShowTabBarView {
    return didShowMain;
}

+ (void) setDidShowTabBarView {
    didShowMain = YES;
}

+ (BOOL)isNetworkOnline {
    if (!hasInternetChecked) {
        return [Utilities hasInternet];
    }
    return internetActive && hostActive;
}

+ (BOOL)isInternetActive {
    if (!hasInternetChecked) {
        return [Utilities hasInternet];
    }

    return internetActive;
}

+(BOOL)isHostActive{
    if (!hasInternetChecked) {
        return [Utilities hasInternet];
    }
    return hostActive;
}

+ (void)showTabBar {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showTabBar" object:nil];
}

+ (void)hideTabBar {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:nil];
}

+ (UIFont*)fontOpensSansWithSize:(float)size {
    return [UIFont fontWithName:@"OpenSans" size:size];
}

+ (UIFont*)fontOpensSansBoldWithSize:(float)size {
    return [UIFont fontWithName:@"OpenSans-Bold" size:size];
}

+ (UIFont*)fontOpensSansLightWithSize:(float)size {
    return [UIFont fontWithName:@"OpenSans-Light" size:size];
}

+ (UIFont*)fontOpensSansExtraBoldWithSize:(float)size {
    return [UIFont fontWithName:@"OpenSans-Extrabold" size:size];
}


+ (UIColor*)colorRed {
    return [UIColor colorWithRed:255.0f/255.0f green:94.0f/255.0f blue:79.0f/255.0f alpha:1.0f];
}
+ (UIColor*)colorYellow {
    return [UIColor colorWithRed:255.0f/255.0f green:170.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
}
+ (UIColor*)colorGray {
    return [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0f];
}

+ (UIColor*)colorGrayLight {
    return [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0f];

}
+ (UIColor*)colorGreen {
    return [UIColor colorWithRed:114.0f/255.0f green:200.0f/255.0f blue:101.0f/255.0f alpha:1.0f];
}
+ (UIColor*)colorBlueLight {
    return [UIColor colorWithRed:42.0f/255.0f green:180.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
}

+ (BOOL)isIphone4inch{
    return [[UIScreen mainScreen]bounds].size.height > 480;
}

+ (NSString*)setUrl:(NSString*)str Width:(int)width height:(int)height {

    str = [str stringByReplacingOccurrencesOfString:@"width" withString:[NSString stringWithFormat:@"%i", width]];
    str = [str stringByReplacingOccurrencesOfString:@"height" withString:[NSString stringWithFormat:@"%i", height]];

    return str;
}

+ (void)alertWithMessage:(NSString *)message inViewController:(UIViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[UIApplication displayName]
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void)alertWithError:(NSString *)message inViewController:(UIViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void)alertWithServerErrorInViewController:(UIViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Não foi possível acessar o serviço no momento. Por favor, tente novamente mais tarde."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (BOOL)checkIfError:(NSDictionary *)dict {
    if ([dict valueForKey:@"error"]) {
        if ([[dict valueForKey:@"error"] length] > 0) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)checkIfNull:(NSString *)textToCheck {
    if ([textToCheck isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return textToCheck;
}

+ (CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font {
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:textToMesure
     attributes:@
     {
     NSFontAttributeName: font
     }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;

    return size;
}

+ (BOOL)isIpad {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
}

+ (BOOL)isIOS7 {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        return YES;
    }
    return NO;
}

+ (BOOL)isValidEmail:(NSString *)checkString {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    if (![emailTest evaluateWithObject:checkString]) {
        return NO;
    }

    return [emailTest evaluateWithObject:checkString];
}

+ (BOOL)isValidCPF:(NSString*)cpf
{
    cpf = [cpf stringByReplacingOccurrencesOfString:@"." withString:@""];
    cpf = [cpf stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if([cpf length] != 11 ||
       [cpf isEqualToString:@"00000000000"] || [cpf isEqualToString:@"11111111111"] ||
       [cpf isEqualToString:@"22222222222"] || [cpf isEqualToString:@"33333333333"] ||
       [cpf isEqualToString:@"44444444444"] || [cpf isEqualToString:@"55555555555"] ||
       [cpf isEqualToString:@"66666666666"] || [cpf isEqualToString:@"77777777777"] ||
       [cpf isEqualToString:@"88888888888"] || [cpf isEqualToString:@"99999999999"])
        return NO;

    // Validar primeiro digito
    int add = 0;
    for(int i = 0; i < 9; i++)
    {
        int intVal = [cpf characterAtIndex:i] - '0';
        add += intVal * (10 - i);
    }

    int rev = 11 - (add % 11);
    if(rev == 10 || rev == 11)
        rev = 0;

    if([cpf characterAtIndex:9] - '0' != rev)
        return NO;

    // Validar segundo dígito
    add = 0;
    for(int i = 0; i < 10; i++)
    {
        int intVal = [cpf characterAtIndex:i] - '0';
        add += intVal * (11 - i);
    }
    rev = 11 - (add % 11);
    if(rev == 10 || rev == 11)
        rev = 0;

    if([cpf characterAtIndex:10] - '0' != rev)
        return NO;

    return YES;
}

+ (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    cString = [cString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];

    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];

    if ([cString length] != 6) return  [UIColor grayColor];

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (NSString *)calculateNumberOfDaysPassed:(NSString*)strDate {

    ISO8601DateFormatter* form = [[ISO8601DateFormatter alloc] init];

    //NSDateFormatter *form = [[NSDateFormatter alloc]init];
    //[form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    //strDate = [strDate substringToIndex:19];
    //strDate = [strDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];

    NSDate *earlier = [form dateFromString:strDate];

    NSDate *today = [NSDate date];

    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];

    NSUInteger units = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;

    NSDateComponents *components = [gregorian components:units fromDate:earlier toDate:today options:0];

    NSInteger days = [components day];
    NSInteger hours = [components hour];
    NSInteger minutes = [components minute];


    NSString *sentence = nil;

    if (days > 0) {
        if (days == 1)
            sentence = [NSString stringWithFormat:@"%i dia atrás", days];
        else
            sentence = [NSString stringWithFormat:@"%i dias atrás", days];
    } else if (hours > 0){
        if (hours == 1)
            sentence = [NSString stringWithFormat:@"%i hora atrás", hours];
        else
            sentence = [NSString stringWithFormat:@"%i horas atrás", hours];
    } else {
        if (minutes == 1)
            sentence = [NSString stringWithFormat:@"%i minuto atrás", minutes];
        else if (minutes == 0)
            sentence = @"Agora";
        else
            sentence = [NSString stringWithFormat:@"%i minutos atrás", minutes];
    }

    return sentence;
}

+ (int)calculateDaysPassed:(NSString*)strDate {

    ISO8601DateFormatter* formatter = [[ISO8601DateFormatter alloc] init];

    /*NSDateFormatter *form = [[NSDateFormatter alloc]init];
    [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    strDate = [strDate substringToIndex:19];
    strDate = [strDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];*/

    NSDate *earlier = [formatter dateFromString:strDate];

    NSDate *today = [NSDate date];

    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];

    NSUInteger units = NSDayCalendarUnit;

    NSDateComponents *components = [gregorian components:units fromDate:earlier toDate:today options:0];

    NSInteger days = [components day];

    return days;
}

+(float)expectedWidthWithLabel:(UILabel*)label{
    [label setNumberOfLines:1];

    CGSize maximumLabelSize = CGSizeMake(9999,label.frame.size.height);

    CGSize expectedLabelSize = [[label text] sizeWithFont:[label font]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:[label lineBreakMode]];
    return expectedLabelSize.width;
}

typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

+ (UIImage *)getBlackAndWhiteVersionOfImage:(UIImage *)anImage {

    CGSize size = [anImage size];
    int width = size.width;
    int height = size.height;

    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));

    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);

    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [anImage CGImage]);

    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];

            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];

            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }

    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);

    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);

    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];

    // we're done with image now too
    CGImageRelease(image);

    return resultUIImage;

}


+ (UIImage *) getImageWithTintedColor:(UIImage *)image withTint:(UIColor *)color withIntensity:(float)alpha {
    CGSize size = image.size;

    UIGraphicsBeginImageContextWithOptions(size, FALSE, 2);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [image drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:1.0];

    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    CGContextSetAlpha(context, alpha);

    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(CGPointZero.x, CGPointZero.y, image.size.width, image.size.height));

    UIImage * tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return tintedImage;
}

+ (UIImage *) changeColorForImage:(UIImage *)image toColor:(UIColor*)color {
    UIGraphicsBeginImageContext(image.size);

    CGRect contextRect;
    contextRect.origin.x = 0.0f;
    contextRect.origin.y = 0.0f;
    contextRect.size = [image size];
    // Retrieve source image and begin image context
    CGSize itemImageSize = [image size];
    CGPoint itemImagePosition;
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) );

    UIGraphicsBeginImageContext(contextRect.size);

    CGContextRef c = UIGraphicsGetCurrentContext();
    // Setup shadow
    // Setup transparency layer and clip to mask
    CGContextBeginTransparencyLayer(c, NULL);
    CGContextScaleCTM(c, 1.0, -1.0);
    CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [image CGImage]);
    // Fill and end the transparency layer


    const float* colors = CGColorGetComponents( color.CGColor );
    CGContextSetRGBFillColor(c, colors[0], colors[1], colors[2], .75);

    contextRect.size.height = -contextRect.size.height;
    contextRect.size.height -= 15;
    CGContextFillRect(c, contextRect);
    CGContextEndTransparencyLayer(c);

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (NSString*)getDateStringFromDaysPassed:(int)daysPassed {

    NSDate *toDate = [NSDate date];
    toDate = [toDate dateByAddingTimeInterval:-(60*60*24*daysPassed)];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    NSString *stringFromDate = [formatter stringFromDate:toDate];

    return stringFromDate;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString*) socialShareTextForReportId:(int)reportId
{
    NSString* phrase = @"Estou colaborando com a minha cidade, reportando problemas e solicitações.";
    NSString* baseUrl = [ApiNetworkingManager baseWebUrl];

    return [NSString stringWithFormat:@"%@ %@/report/%i", phrase, baseUrl, reportId];
}

+ (NSString*) linkForReportId:(int)reportId
{
    NSString* baseUrl = [ApiNetworkingManager baseWebUrl];

    return [NSString stringWithFormat:@"%@/report/%i", baseUrl, reportId];
}

+ (NSString*) defaultShareMessage
{
    return @"Estou colaborando com a minha cidade, reportando problemas e solicitações.";
}

+ (NSString*) getCurrentTenant
{
    return TENANT;
}

+ (CLLocationCoordinate2D) getTenantInitialLocation
{
    if ([[Utilities getCurrentTenant] isEqualToString:@"zup"])
    {
        return CLLocationCoordinate2DMake(-23.689919, -46.564872);
    }
    else if ([[Utilities getCurrentTenant] isEqualToString:@"boa-vista"])
    {
        return CLLocationCoordinate2DMake(2.807199,-60.6965615);
    }
    else if ([[Utilities getCurrentTenant] isEqualToString:@"floripa"])
    {
        return CLLocationCoordinate2DMake(-27.5966512,-48.5463788);
    }
    else if ([[Utilities getCurrentTenant] isEqualToString:@"maceio"])
    {
        return CLLocationCoordinate2DMake(-9.6473902,-35.7092091);
    }

    return CLLocationCoordinate2DMake(0, 0);
}

+ (UIImage *) getTenantLaunchImage {
    NSString *imgName;

    NSString *fmt;

    if ([Utilities isIpad]) {
        fmt = @"launch_%@_ipad";
    } else {
        if ([Utilities isIphone4inch]) {
            fmt = @"launch_%@_iphone5hd";
        }
        else {
            fmt = @"launch_%@_iphone4";
        }
    }

    imgName = [NSString stringWithFormat:fmt, [Utilities getCurrentTenant]];
    return [UIImage imageNamed:imgName];
}

+ (UIImage*) getTenantLoginImage
{
    NSString *imgName = [NSString stringWithFormat:@"logo_login_%@", [Utilities getCurrentTenant]];
    return [UIImage imageNamed:imgName];
}

+ (UIImage*) getTenantHeaderImage
{
    NSString *imgName = [NSString stringWithFormat:@"header_%@", [Utilities getCurrentTenant]];
    return [UIImage imageNamed:imgName];
}

+ (UIImage*) iconForCluster:(NSDictionary*)cluster inventory:(BOOL)inv
{
    NSNumber* categoryId = [cluster objectForKey:@"category_id"];
    NSDictionary* category = nil;
    UIColor* color = [Utilities colorBlueLight];

    if(categoryId && ![categoryId isKindOfClass:[NSNull class]])
    {
        if(inv)
            category = [UserDefaults getInventoryCategory:[categoryId intValue]];
        else
            category = [UserDefaults getCategory:[categoryId intValue]];
    }

    if(category)
    {
        color = [Utilities colorWithHexString:[category objectForKey:@"color"]];
    }

    CGColorRef col = [color CGColor];
    const CGFloat* components = CGColorGetComponents(col);

    NSString* iconId = [NSString stringWithFormat:@"cluster_%i_%i_%i_%i", (int)(components[0] * 255), (int)(components[1] * 255), (int)(components[2] * 255), [[cluster valueForKey:@"count"] intValue]];
    UIImage* cachedImage = [[ImageCache defaultCache] imageWithName:iconId];
    if(cachedImage)
        return cachedImage;

    UILabel* label = [[UILabel alloc] init];
    label.text = [[cluster valueForKey:@"count"] stringValue];
    label.font = [Utilities fontOpensSansBoldWithSize:26];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];

    int border = 5;
    int padding = 10;
    int size = MAX(label.frame.size.width, label.frame.size.height) + padding*2 + border*2;

    UIGraphicsBeginImageContext(CGSizeMake(size, size));

    [[UIColor whiteColor] setFill];
    CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size, size));

    [color setFill];

    CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), CGRectMake(border, border, size - border*2, size - border*2));

    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), (size - label.frame.size.width) / 2, (size - label.frame.size.height) / 2);
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    [[ImageCache defaultCache] addImage:image withName:iconId];

    return image;
}

+ (NSDate*) todayMinusDays:(int) days
{
    NSDate* date = [[NSDate alloc] initWithTimeIntervalSinceNow:-(days * 24 * 60 * 60)];
    return date;
}

+ (NSString*) dateToISOString:(NSDate*)date
{
    ISO8601DateFormatter* formatter = [[ISO8601DateFormatter alloc] init];
    return [formatter stringFromDate:date timeZone:[NSTimeZone systemTimeZone]];
}

+ (UIBarButtonItem*) createSpacer
{
    UIBarButtonItem* item = [[UIBarButtonItem alloc] init];
    item.width = -5;

    return item;
}

+ (UIBarButtonItem*) createEdgeSpacer
{
    UIBarButtonItem* item = [[UIBarButtonItem alloc] init];
    item.width = -10;

    return item;
}

@end
