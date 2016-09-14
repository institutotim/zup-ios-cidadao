
//
//  AppDelegate.m
//  Zup
//

#import "AppDelegate.h"
#import "RavenClient.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <GooglePlus/GooglePlus.h>
#import "GAI.h"
#import "Constants.h"

@implementation AppDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField* textField = [alertView textFieldAtIndex:0];
    if([textField.text isEqualToString:@"zup_piloto2014"])
    {
        return;
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Senha" message:@"Senha incorreta. Tente novamente." delegate:self cancelButtonTitle:@"Validar" otherButtonTitles: nil];
        alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [alert show];
    }
}

/*- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  )
    {
        //opened from a push notification when the app was on background
        
        NSLog(@"notification open: %@", userInfo);
    }
}*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //NSLog(@"Token: %@", [UserDefaults getToken]);
    // Override point for customization after application launch.
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Senha" message:@"Este aplicativo está em projeto piloto e tem acesso restrito. Para continuar digite a senha que você recebeu para participar desta fase." delegate:self cancelButtonTitle:@"Validar" otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    //[alert show];
    
    NSLog(@"%@", kAPIkey);
    [GMSServices provideAPIKey:kAPIkey];
    
#if defined(PRODUCTION) && defined(GAID)
    NSLog(@"Initializing GA");
    // Initialize tracker.
    [[GAI sharedInstance] trackerWithTrackingId:GAID];
#endif
    
    [Fabric with:@[CrashlyticsKit]];
    
    if ([Utilities isIOS7])
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
    else
        [[UIApplication sharedApplication]setStatusBarHidden:YES];

    [RavenClient clientWithDSN:@"https://866d9108ceed4379aeac03d76b5eb393:15a3c8dae32f474e8cb6ce7199284909@app.getsentry.com/17326"];
    [[RavenClient sharedClient] setupExceptionHandler];
    
    UIApplication* app = [UIApplication sharedApplication];
    if([app respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        NSLog(@"Registering for iOS 8 notifications");
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge)categories:nil];
        [app registerUserNotificationSettings:settings];
        [app registerForRemoteNotifications];
    }
    else
    {
        NSLog(@"Registering for iOS 7- notifications");
        [app registerForRemoteNotificationTypes:(UIRemoteNotificationType)(UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge)];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    return YES;
}

#pragma mark - Token


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [UserDefaults setDeviceToken:deviceTokenString];
    
    NSLog(@"Token OK: %@", deviceTokenString);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", [error description]);
}

#pragma mark - Push

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self processRemoteInfo:userInfo state:application.applicationState];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void) scheduleReportOpening:(int)reportId
{
    ServerOperations* op = [[ServerOperations alloc] init];
    op.target = self;
    op.action = @selector(didReceiveReport:);
    [op getReportDetailsWithId:reportId];
}

- (void) didReceiveReport:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSDictionary* report = [dict valueForKey:@"report"];
    
    self.pendingReport = report;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backToMap" object:nil userInfo:dict];
}

- (void)processRemoteInfo:(NSDictionary*)userInfo state:(UIApplicationState)state {
    
    //if (state == UIApplicationStateActive)
    //{
    //    NSLog(@"Active %@", userInfo);
    //} else if (state == UIApplicationStateBackground || state == UIApplicationStateInactive) {
    {
        
        // kind = report;
        // "object_id" = 1154;
        // "user_id" = 51;
        
        if([[userInfo valueForKey:@"kind"] isEqualToString:@"report"])
        {
            NSLog(@"Opening report #%i!", [[userInfo valueForKey:@"object_id"] intValue]);
        
            [self scheduleReportOpening:[[userInfo valueForKey:@"object_id"] intValue]];
        }
        
        NSLog(@"Background %@", userInfo);
    }
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}

@end
