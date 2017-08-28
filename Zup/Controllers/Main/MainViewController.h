//
//  MainViewController.h
//  Zup
//

#import <UIKit/UIKit.h>

#import "PerfilViewController.h"
#import "ExploreViewController.h"
#import "RelateViewController.h"
#import "GAITrackedViewController.h"

@interface MainViewController : GAITrackedViewController <UIScrollViewDelegate>

@property (assign, nonatomic) BOOL isFromPerfil;
@property (assign, nonatomic) BOOL isFromSolicit;
@property (assign, nonatomic) BOOL isFromReport;

@property (strong, nonatomic) PerfilViewController *perfilVC;
@property (strong, nonatomic) RelateViewController *relateVC;
@property (strong, nonatomic) UIViewController *exploreVC;

@property (nonatomic, weak) IBOutlet UIScrollView *scroll;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle1;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle2;
@property (nonatomic, weak) IBOutlet CustomButton *btLogin;
@property (nonatomic, weak) IBOutlet CustomButton *btRegister;
@property (nonatomic, weak) IBOutlet CustomButton *btJump;
@property (nonatomic, weak) IBOutlet UIView *tabExplore;
@property (nonatomic, weak) IBOutlet UITabBarItem *tabSolicite;
@property (nonatomic, weak) IBOutlet UITabBarItem *tabPerfil;
@property (nonatomic, weak) IBOutlet UITabBarItem *tabEstatisticas;
@property (nonatomic, weak) IBOutlet UIImageView  *logoView;

- (IBAction)btRegister:(id)sender;
- (IBAction)btLogin:(id)sender;
- (IBAction)btJump:(id)sender;

- (void)didCancelButton:(id)sender;
- (void)getReportCategories;

@end
