//
//  PerfilDetailViewController.h
//  Zup
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface PerfilDetailViewController : GAITrackedViewController<UIActionSheetDelegate> {
    CustomButton *btCancel;
}

@property (nonatomic, retain) UIStoryboard* thatStoryboard;

@property (weak, nonatomic) UINavigationController* navCtrl;
@property (weak, nonatomic) UIViewController* exploreVC;

@property (weak, nonatomic) IBOutlet UIImageView* imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spin;
@property (nonatomic) BOOL isFromFeed;
@property (nonatomic) BOOL isFromPerfil;
@property (nonatomic) BOOL isFromExplore;
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (strong, nonatomic) NSDictionary *dictMain;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblCategoria;
@property (strong, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (strong, nonatomic) IBOutletCollection(CustomButton) NSArray *arrButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollImages;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextView *tvDesc;

@property (weak, nonatomic) IBOutlet UIView *containerComentarios;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorComentarios;

@property (weak, nonatomic) IBOutlet CustomButton *btAberto;
@property (weak, nonatomic) IBOutlet CustomButton *btAndamento;
@property (weak, nonatomic) IBOutlet CustomButton *btResolvido;
@property (weak, nonatomic) IBOutlet CustomButton *btNaoResolvido;

@property (strong, nonatomic) UIButton* btReportar;
@property (strong, nonatomic) UIAlertView* reportLoading;

@end
