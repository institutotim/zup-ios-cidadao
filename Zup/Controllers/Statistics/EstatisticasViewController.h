//
//  EstatisticasViewController.h
//  Zup
//

#import <UIKit/UIKit.h>
#import "SSPieProgressView.h"
#import "GAITrackedViewController.h"

@interface EstatisticasViewController : GAITrackedViewController <UICollectionViewDelegate, UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *arrLabel;
@property (nonatomic, retain) NSArray *arrMain;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spin;

@property int daysFilter;
@property NSArray* selectedCategories;

- (void)refreshWithFilter:(int)days categoryId:(int)categoryId;
- (void)refreshWithFilter:(int)days categoryIds:(NSArray*)categoryIds;

@end
