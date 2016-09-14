//
//  FiltrarInventarioViewController.h
//  zup
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface FiltrarInventarioViewController : GAITrackedViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* categories;
    NSMutableArray* selectedCategories;
    
    id delegateObj;
    SEL delegate;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;

- (NSArray*) categoriesIds;
- (void)deselectAll;
- (void)setDelegate:(id)obj selector:(SEL)delegate;

@end
