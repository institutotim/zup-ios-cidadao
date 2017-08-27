//
//  PerfilViewController.h
//  Zup
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface PerfilViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIScrollViewDelegate> {
    CustomButton *btEdit;
    CustomButton *btCancel;
    NSString *tokenStr;
    UINavigationController *navLogin;
    
    int page;
    BOOL isLoading;
    int pageCountMax;
    int totalCountSolicits;
}

@property (strong, nonatomic) UIViewController* exploreVC;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spin;
@property (strong, nonatomic) NSMutableArray *arrMain;
@property (strong, nonatomic) NSDictionary *dictUser;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblSoliciations;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UITableView *table;

- (void)getData;
- (void)getUserDetails;

@end
