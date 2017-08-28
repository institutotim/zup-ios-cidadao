//
//  LoginViewController.h
//  Zup
//

#import <UIKit/UIKit.h>

#import "MainViewController.h"
#import "PerfilViewController.h"
#import "RelateViewController.h"
#import "GAITrackedViewController.h"

@interface LoginViewController : GAITrackedViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet CustomButton *btLogin;
@property (weak, nonatomic) IBOutlet CustomButton *btForgot;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spin;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPass;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet MainViewController *mainVC;

@property (nonatomic, retain) UIBarButtonItem *buttonLogin;
@property (nonatomic, retain) UIBarButtonItem *buttonCancel;
@property (nonatomic, retain) UIBarButtonItem *buttonSpin;

@property (weak, nonatomic)  PerfilViewController *perfilVC;
@property (weak, nonatomic)  RelateViewController *relateVC;

@property (nonatomic) BOOL isFromInside;
@property (nonatomic) BOOL isFromPerfil;
@property (nonatomic) BOOL isFromReport;
@property (nonatomic) BOOL isFromSolicit;

- (IBAction)btForogt:(id)sender;

@end
