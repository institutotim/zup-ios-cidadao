//
//  GraphicCell.h
//  Zup
//

#import <UIKit/UIKit.h>
#import "SSPieProgressView.h"

@interface GraphicCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet SSPieProgressView *viewPie;
@property (weak, nonatomic) IBOutlet UILabel *lblPercent;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

- (void)setValues:(NSDictionary *)dict;

@end
