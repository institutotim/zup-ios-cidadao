//
//  CreateViewController.h
//  Zup
//

#import <UIKit/UIKit.h>
#import "PerfilViewController.h"
#import "RelateViewController.h"
#import "MainViewController.h"
#import "GAITrackedViewController.h"

@interface CreateViewController : GAITrackedViewController <UITextFieldDelegate> {
    CustomButton *btCreate;
    CustomButton *btCancel;
    BOOL isFirstTime;
}

@property (nonatomic) BOOL isFromPerfil;
@property (nonatomic) BOOL isFromSolicit;
@property (strong, nonatomic)  MainViewController *mainVC;
@property (strong, nonatomic)  PerfilViewController *perfilVC;
@property (weak, nonatomic)  RelateViewController *relateVC;

@property (weak, nonatomic) IBOutlet UIView *viewForm;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (strong, nonatomic) IBOutletCollection (UITextField) NSArray *arrTf;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle1;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;

@property (weak, nonatomic) IBOutlet UIButton *btFacebool;
@property (weak, nonatomic) IBOutlet UIButton *btTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btPlus;

@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPass;
@property (weak, nonatomic) IBOutlet UITextField *tfConfirmPass;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfCpf;
@property (weak, nonatomic) IBOutlet UITextField *tfBairro;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfComplement;
@property (weak, nonatomic) IBOutlet UITextField *tfCep;
@property (weak, nonatomic) IBOutlet UITextField* tfCidade;

@property (weak, nonatomic) IBOutlet CustomButton *btRegister;
@property (weak, nonatomic) IBOutlet CustomButton *btLogin;

@property (weak, nonatomic) IBOutlet UIView *loadingOverlay;

- (IBAction)btTerms:(id)sender;


@end
