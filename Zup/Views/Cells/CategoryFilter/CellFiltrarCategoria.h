//
//  CellFiltrarCategoria.h
//  zup
//

#import <UIKit/UIKit.h>

@interface CellFiltrarCategoria : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView* qbackgroundView;
@property (nonatomic, strong) IBOutlet UIImageView* iconView;
@property (nonatomic, strong) IBOutlet UILabel* lblTitle;
@property (nonatomic, strong) IBOutlet UILabel* lblLink;
@property (nonatomic, strong) IBOutlet UIView* separator;
@property (nonatomic, strong) IBOutlet UIImageView* selectIndicator;

@property int height;

- (void) setvalues:(NSDictionary*) dict selected:(BOOL)selected iconColored:(BOOL)iconColored;
- (void) setShowMoreExpanded:(BOOL)expanded;
- (void) setActivateDeactivate:(BOOL) activated;
- (void) setPlaceholder;
- (void) setViewBackgroundColor:(UIColor *)backgroundColor;

@end
