//
//  AppDelegate.h
//  Zup
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSDictionary* pendingReport;
@property (strong, nonatomic) UIWindow *window;

@end
