//
//  RelateViewController.h
//  Zup
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface RelateViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate> 

@property (nonatomic, strong) UIViewController *exploreVC;
@property (nonatomic, strong) NSArray *arrMain;

@property (nonatomic, weak) IBOutlet UIView *toolbarView;
@property (nonatomic, weak) IBOutletCollection(UILabel) NSArray *arrLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scroll;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;

- (IBAction)btExibirRelato:(id)sender;

- (IBAction)criarRelato:(id)sender;

- (void)setToken;

@end
