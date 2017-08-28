//
//  SocialViewController.h
//  Zup
//

#import <UIKit/UIKit.h>

#import "TWAPIManager.h"
#import "PerfilViewController.h"
#import "RelateViewController.h"
#import "GAITrackedViewController.h"

#import <Accounts/Accounts.h>

@interface SocialViewController : GAITrackedViewController

@property (nonatomic, assign) BOOL isLoggedSocial;
@property (nonatomic, assign) BOOL isFromPerfil;
@property (nonatomic, assign) BOOL isFromSolicit;

@property (strong, nonatomic) CustomButton *btCancel;
@property (strong, nonatomic)  PerfilViewController *perfilVC;
@property (weak, nonatomic)  RelateViewController *relateVC;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *viewSocialButtons;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spin;
@property (weak, nonatomic) IBOutlet UIButton *btFacebool;
@property (weak, nonatomic) IBOutlet UIButton *btTwitter;
@property (weak, nonatomic) IBOutlet CustomButton *btPular;

@property (nonatomic, strong) TWAPIManager *apiManager;

- (IBAction)btFacebook:(id)sender;
- (IBAction)btTwitter:(id)sender;
- (IBAction)btPular:(id)sender;

@end
