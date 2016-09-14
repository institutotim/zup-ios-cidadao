//
//  ForgotViewController.h
//  Zup
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface ForgotViewController : GAITrackedViewController

@property (nonatomic, retain) IBOutlet UILabel* label;
@property (weak, nonatomic) IBOutlet UITextField *tfemail;

@end
