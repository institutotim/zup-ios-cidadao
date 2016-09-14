//
//  SocialViewController.h
//  Zup
//

#import <UIKit/UIKit.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Accounts/Accounts.h>
#import <GooglePlus/GooglePlus.h>
#import "TWAPIManager.h"
#import "PerfilViewController.h"
#import "RelateViewController.h"
#import "GAITrackedViewController.h"

@class GPPSignInButton;

@interface SocialViewController : GAITrackedViewController <GPPSignInDelegate> {
    BOOL isLoggedSocial;
    CustomButton *btCancel;
}

@property (nonatomic) BOOL isFromPerfil;
@property (nonatomic) BOOL isFromSolicit;
@property (strong, nonatomic)  PerfilViewController *perfilVC;
@property (weak, nonatomic)  RelateViewController *relateVC;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *viewSocialButtons;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spin;

@property (weak, nonatomic) IBOutlet UIButton *btFacebool;
@property (weak, nonatomic) IBOutlet UIButton *btTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btPlus;

@property (weak, nonatomic) IBOutlet CustomButton *btPular;

@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property (nonatomic, strong) TWAPIManager *apiManager;

- (IBAction)btFacebook:(id)sender;
- (IBAction)btTwitter:(id)sender;
- (IBAction)btPlus:(id)sender;

- (IBAction)btPular:(id)sender;

@end
