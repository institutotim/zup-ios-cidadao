//
//  HeaderProfileCell.h
//  Zup
//

#import <UIKit/UIKit.h>

@interface HeaderProfileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbltitleCell;
@property (weak, nonatomic) IBOutlet UILabel *lblNameCell;
@property (weak, nonatomic) IBOutlet UILabel *lblSoliciationsCell;

- (void)setValues:(NSDictionary *)dict count:(int)count;

@end
