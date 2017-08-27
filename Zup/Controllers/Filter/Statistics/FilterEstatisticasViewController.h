//
//  FilterEstatisticasViewController.h
//  Zup
//

#import <UIKit/UIKit.h>
#import "EstatisticasViewController.h"
#import "GAITrackedViewController.h"

@interface FilterEstatisticasViewController : GAITrackedViewController<UITableViewDataSource, UITableViewDelegate> {
    BOOL isCategoriesOpen;
    int currentIdCat;
    
    NSArray* categories;
    NSMutableArray* selectedCategories;
}

@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *arrBtStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgLineBottomCategoriesBox;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIView *viewCategories;
@property (weak, nonatomic) IBOutlet UIView *viewSlider;
@property (weak, nonatomic) IBOutlet UIView *ViewAllCat;

@property (retain, nonatomic)  NSMutableArray *arrButtonStatuses;
@property (retain, nonatomic)  EstatisticasViewController *estatisticasVC;

@property (retain, nonatomic) IBOutlet UIImageView *imgSeta;

@property (retain, nonatomic) IBOutlet UIButton *btTodasCategorias;
@property (retain, nonatomic) IBOutlet UIButton *btResolvidos;
@property (retain, nonatomic) IBOutlet UIButton *btAndamento;
@property (retain, nonatomic) IBOutlet UIButton *btAberto;

@property (nonatomic, retain) IBOutlet UITableView* tableView;

- (IBAction)btCategories:(id)sender;
- (IBAction)slider:(id)sender;
- (IBAction)btStatus:(id)sender;

@end
