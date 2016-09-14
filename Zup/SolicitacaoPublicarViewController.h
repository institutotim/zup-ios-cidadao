//
//  SolicitacaoPublicarViewController.h
//  Zup
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import "GAITrackedViewController.h"

@interface SolicitacaoPublicarViewController : GAITrackedViewController <GPPSignInDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
    SocialNetworkType socialType;
    UIView *viewLoading;
}

@property (weak, nonatomic) IBOutlet UIView *viewToShare;
@property (weak, nonatomic) IBOutlet UIImageView *imgBox;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextView *tvDetalhe;
@property (weak, nonatomic) IBOutlet UILabel *lblFacebook;
@property (weak, nonatomic) IBOutlet UILabel *lblConcordo;
@property (weak, nonatomic) IBOutlet CustomButton *btTerms;
@property (weak, nonatomic) IBOutlet UISwitch *swFacebook;
@property (weak, nonatomic) IBOutlet CustomButton *btBack;
@property (weak, nonatomic) IBOutlet CustomButton *btPublish;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIView* viewConfidential;
@property (weak, nonatomic) IBOutlet UILabel* labelConfidential;
@property (weak, nonatomic) IBOutlet UIScrollView* scroll;

@property (strong, nonatomic) NSString *catStr;
@property (strong, nonatomic)NSMutableDictionary *dictMain;

- (IBAction)btPublicar:(id)sender;
- (IBAction)btBack:(id)sender;
- (IBAction)btDone:(id)sender;
- (IBAction)btTerms:(id)sender;
- (IBAction)btOpenEditView:(id)sender;
- (void)handleSocialView;

@end
