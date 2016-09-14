//
//  TabBarController.m
//  Zup
//

#import "TabBarController.h"
#import "ExploreViewController.h"
#import "RelateViewController.h"
#import "PerfilViewController.h"

#import "AppDelegate.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->removedUnusedTabs = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UITabBar appearance]setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance]setBackgroundImage:[UIImage imageNamed:@"tabBar"]];
    
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];

    int offset = -2;
    UIEdgeInsets imageInset = UIEdgeInsetsMake(offset, 0, -offset, 0);
    
    tabBarItem1.title = @"Explore";
    tabBarItem2.title = @"Solicite";
    tabBarItem3.title = @"Minha conta";
    tabBarItem4.title = @"Estatísticas";
    
    UINavigationController* navController = [[self viewControllers] objectAtIndex:2];
    PerfilViewController* perfilVC = [navController.viewControllers objectAtIndex:0];
    
    navController = [[self viewControllers] objectAtIndex:1];
    RelateViewController* relateVC = [navController.viewControllers objectAtIndex:0];
    
    navController = [[self viewControllers] objectAtIndex:0];
    perfilVC.exploreVC = [navController.viewControllers objectAtIndex:0];
    relateVC.exploreVC = [navController.viewControllers objectAtIndex:0];
    
    if ([Utilities isIOS7]) {
        tabBarItem1.image = [[UIImage imageNamed:@"tab-bar_icon_explore_normal-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem1.selectedImage = [[UIImage imageNamed:@"tab-bar_icon_explore_active-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem1.imageInsets = imageInset;
        
        tabBarItem2.image = [[UIImage imageNamed:@"tab-bar_icon_solicite_normal-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem2.selectedImage = [[UIImage imageNamed:@"tab-bar_icon_solicite_active-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem2.imageInsets = imageInset;
        
        tabBarItem3.image = [[UIImage imageNamed:@"tab-bar_icon_conta_normal-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem3.selectedImage = [[UIImage imageNamed:@"tab-bar_icon_conta_active-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem3.imageInsets = imageInset;
        
        tabBarItem4.image = [[UIImage imageNamed:@"tab-bar_icon_estatisticas_normal-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem4.selectedImage = [[UIImage imageNamed:@"tab-bar_icon_estatisticas_active-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem4.imageInsets = imageInset;

    } else {
        [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"tab-bar_icon_explore_normal-1"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab-bar_icon_explore_active-1"]];
        
        [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"tab-bar_icon_solicite_normal-1"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab-bar_icon_solicite_active-1"]];
        
        [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"tab-bar_icon_conta_normal-1"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab-bar_icon_conta_active-1"]];
        
        [tabBarItem4 setFinishedSelectedImage:[UIImage imageNamed:@"tab-bar_icon_estatisticas_normal-1"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab-bar_icon_estatisticas_active-1"]];
    }
    
    
    //[[UITabBar appearance] setShadowImage:[[UIImage alloc]init]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showTabBar) name:@"showTabBar" object:Nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideTabBar) name:@"hideTabBar" object:Nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushToMainView) name:@"pushToMainView" object:Nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backToMap:) name:@"backToMap" object:Nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backToMap) name:@"backToMapFromPerfil" object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionExpired) name:@"APISessionExpired" object:nil];
    
    float fontSize;
    if ([Utilities isIpad]) {
        fontSize = 13;
    } else {
        fontSize = 10;
    }
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[Utilities fontOpensSansWithSize:fontSize], NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[Utilities fontOpensSansWithSize:fontSize], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    if ([Utilities isIOS7]) {
        [self.tabBar setTranslucent:NO];

    } else {
    }
}

- (void) sessionExpired
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sessão expirada" message:@"Sua sessão expirou. É necessário fazer login novamente." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pushToMainView" object:nil];
    [UserDefaults setToken:@""];
    [UserDefaults setUserId:@""];
    [UserDefaults setIsUserLogged:NO];
    [UserDefaults setIsUserLoggedOnSocialNetwork:kSocialNetworkAnyone];
}

- (void) hideTabBar {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    float fHeight = screenRect.size.height;
    if(  UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) )
    {
        fHeight = screenRect.size.width;
    }
    
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, fHeight, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, fHeight)];
            view.backgroundColor = [UIColor blackColor];
        }
    }
    [UIView commitAnimations];
}

- (void) showTabBar {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float fHeight = screenRect.size.height - 49.0;
    
    if(  UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) )
    {
        fHeight = screenRect.size.width - 49.0;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, fHeight, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, fHeight)];
        }
    }
    [UIView commitAnimations];
}

- (void)backToMap:(NSNotification *)notification {
    [self setSelectedIndex:0];
    
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:notification.userInfo];
    
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    if(dict == delegate.pendingReport)
        delegate.pendingReport = nil;
    
    NSString *lat = [Utilities checkIfNull:[dict valueForKeyPath:@"report.position.latitude"]];
    NSString *lng = [Utilities checkIfNull:[dict valueForKeyPath:@"report.position.longitude"]];
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([lat floatValue], [lng floatValue]);
    
    NSArray *arrayVC = [self viewControllers];

    UINavigationController *nav = (UINavigationController*)[arrayVC objectAtIndex:0];
    ExploreViewController *exploreVC = [nav.viewControllers objectAtIndex:0];
    [exploreVC buildDetail:[dict valueForKey:@"report"]];
    [exploreVC setLocationWithClLocation:location zoom:0];
    exploreVC.isGoToReportDetail = YES;
    exploreVC.idCreatedReport = [[dict valueForKey:@"idReport"]intValue];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (self.selectedIndex == 1) {
        NSArray *arrayVC = [self viewControllers];
        UINavigationController *nav = (UINavigationController*)[arrayVC objectAtIndex:0];
        ExploreViewController *exploreVC = [nav.viewControllers objectAtIndex:0];
        exploreVC.isFromOtherTab = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if(!self->removedUnusedTabs)
    {
        //UITabBar *tabBar = self.tabBar;
    
        NSMutableIndexSet* itemsToRemove = [NSMutableIndexSet indexSet];
    
        if(![UserDefaults isFeatureEnabled:@"explore"])
            [itemsToRemove addIndex:0];
    
        if(![UserDefaults isFeatureEnabled:@"create_report_clients"])
            [itemsToRemove addIndex:1];
    
        if(![UserDefaults isFeatureEnabled:@"stats"])
            [itemsToRemove addIndex:3];
    
        NSMutableArray *tbViewControllers = [NSMutableArray arrayWithArray:[self viewControllers]];
        [tbViewControllers removeObjectsAtIndexes:itemsToRemove];
        [self setViewControllers:tbViewControllers];
       
        self->removedUnusedTabs = YES;
    }

}

- (BOOL)isFeatureEnabled:(NSString*)feature flags:(NSArray*) flags
{
    for (NSDictionary* flag in flags)
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

- (void)didReceiveError:(NSError*)error {
    [Utilities alertWithServerError];
}


- (void)backToMap {
    [self setSelectedIndex:0];
}

- (void)pushToMainView {
        
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
