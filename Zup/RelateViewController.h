//
//  RelateViewController.h
//  Zup
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface RelateViewController : GAITrackedViewController<UITableViewDataSource, UITableViewDelegate> {
    NSArray* categories;
    NSMutableArray* expandedCategories;
    int selectedCategoryId;
    NSString *tokenStr;
}

@property (strong, retain) UIViewController* exploreVC;

@property (nonatomic, retain) IBOutlet UIView* toolbarView;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *arrLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) IBOutlet NSArray *arrMain;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

- (IBAction)btExibirRelato:(id)sender;

- (IBAction)criarRelato:(id)sender;

- (void)setToken;

@end
