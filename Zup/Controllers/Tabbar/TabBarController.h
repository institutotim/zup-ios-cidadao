//
//  TabBarController.h
//  Zup
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController <UITabBarDelegate, UITabBarControllerDelegate>
{
    BOOL removedUnusedTabs;
}

@end
