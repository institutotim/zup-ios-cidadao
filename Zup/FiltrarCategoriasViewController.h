//
//  FiltrarCategoriasViewController.h
//  zup
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface FiltrarCategoriasViewController : GAITrackedViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* categories;
    NSArray* allcategories;
    
    NSMutableArray* selectedCategories;
    NSMutableArray* expandedCategories;
    
    id delegateObj;
    SEL delegate;
}

@property (weak, nonatomic) IBOutlet UITableView* tableView;

- (NSArray*) categoriesIds;
- (void)setDelegate:(id)obj selector:(SEL)delegate;
- (void)deselectAll;

@end
