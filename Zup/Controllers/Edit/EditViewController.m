//
//  EditViewController.m
//  Zup
//

#import "EditViewController.h"
#import "NSString+MD5.h"
#import "UIApplication+name.h"

#import <Accounts/Accounts.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

UITextField *activeField;

@interface EditViewController ()

@end

@implementation EditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.spin setHidesWhenStopped:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.scroll setContentSize:self.viewContent.frame.size];
    [self.scroll addSubview:self.viewContent];
    
    for (UITextField *textField in self.arrTf) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, textField.frame.size.height)];
        leftView.backgroundColor = [UIColor clearColor];
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        
        [textField setDelegate:self];
        [textField setFont:[Utilities fontOpensSansLightWithSize:14]];
    }
    
    for (UILabel *lbl in self.arrLbl) {
        [lbl setFont:[Utilities fontOpensSansBoldWithSize:12]];
    }
    
    [self.lblSocialSentence setFont:[Utilities fontOpensSansLightWithSize:14]];
    
    UIImage *imgFacebook = [Utilities getBlackAndWhiteVersionOfImage:[UIImage imageNamed:@"btn_logar_facebook_normal"]];
    [self.btFacebook setImage:imgFacebook forState:UIControlStateNormal];
    [self.btFacebook setImage:[UIImage imageNamed:@"btn_logar_facebook_normal"] forState:UIControlStateSelected];
    
    UIImage *imgTwitter = [Utilities getBlackAndWhiteVersionOfImage:[UIImage imageNamed:@"btn_logar_twitter_normal-1"]];
    [self.btTwitter setImage:imgTwitter forState:UIControlStateNormal];
    [self.btTwitter setImage:[UIImage imageNamed:@"btn_logar_twitter_normal-1"] forState:UIControlStateSelected];
    
    NSString *titleStr = @"Editar perfil";
    if ([Utilities isIOS7]) {
        [self setTitle:titleStr];
    } else {
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        [lblTitle setFont:[Utilities fontOpensSansLightWithSize:18]];
        [lblTitle setTextColor:[UIColor blackColor]];
        [lblTitle setText:titleStr];
        [self.navigationController.navigationBar.topItem setTitleView:lblTitle];
    }
    
    if (![Utilities isIpad]) {
        [self registerForKeyboardNotifications];
    } else {
        /*CGRect framePass = self.tfPass.frame;
        framePass.origin.x = 49;
        [self.tfPass setFrame:framePass];
        
        CGRect framePhone = self.tfPhone.frame;
        framePhone.origin.x = 49;
        [self.tfPhone setFrame:framePhone];
        
        CGRect frameComp = self.tfComplement.frame;
        frameComp.origin.x = 49;
        [self.tfComplement setFrame:frameComp];
        
        CGRect frameConfirm = self.tfConfirmPass.frame;
        frameConfirm.origin.x = 131;
        [self.tfConfirmPass setFrame:frameConfirm];
        
        CGRect frameCpf = self.tfCpf.frame;
        frameCpf.origin.x = 131;
        [self.tfCpf setFrame:frameCpf];
        
        CGRect frameCep = self.tfCep.frame;
        frameCep.origin.x = 131;
        [self.tfCep setFrame:frameCep];*/
    }
    
    [self getUserDetails];
    
    socialType = [UserDefaults getSocialNetworkType];
    [self reloadButtons];
    
    BOOL facebookEnabled = [UserDefaults isFeatureEnabled:@"social_networks_facebook"];
    BOOL twitterEnabled = [UserDefaults isFeatureEnabled:@"social_networks_twitter"];
    
    CGRect frameFacebook = self.btFacebook.frame;
    CGRect frameTwitter = self.btTwitter.frame;

    if (!facebookEnabled) {
        [self.btFacebook setHidden:YES];
        frameTwitter.origin.x -= (frameFacebook.size.width / 2) + 10;
    }
    if (!twitterEnabled) {
        [self.btTwitter setHidden:YES];
        frameFacebook.origin.x += (frameTwitter.size.width / 2) + 5;
    }
    
    self.btFacebook.frame = frameFacebook;
    self.btTwitter.frame = frameTwitter;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btFacebook attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:frameFacebook.origin.x]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btTwitter attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:frameTwitter.origin.x]];
    
    if (!facebookEnabled && !twitterEnabled) {
        int height = self.viewShare.frame.size.height;
        CGSize sz = self.viewContent.frame.size;
        sz.height -= height;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.viewShare attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:0]];
        [self.view setNeedsLayout];
        //[self.view setNeedsUpdateConstraints];
        [self.view layoutIfNeeded];
        [self.scroll setContentSize:sz];

        self.viewShareNotAvailable.hidden = NO;
    } else {
        self.viewShareNotAvailable.hidden = YES;
    }
    
    [self createNavButtons];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isFromReportView) {
        [btSalvar setHidden:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Editar Conta";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[btCancel removeFromSuperview];
    //[btSalvar removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Auxiliar Methods

- (void)createNavButtons {
    btSalvar = [[CustomButton alloc] initWithFrame:CGRectMake(self.navigationController.view.superview.bounds.size.width - 83, 5, 78, 35)];
    
    [btSalvar setBackgroundImage:[UIImage imageNamed:@"menubar_btn_cancelar_normal-1"] forState:UIControlStateNormal];
    [btSalvar setBackgroundImage:[UIImage imageNamed:@"menubar_btn_cancelar_active-1"] forState:UIControlStateHighlighted];
    [btSalvar setFontSize:14];
    [btSalvar setTitle:@"Salvar" forState:UIControlStateNormal];
    [btSalvar addTarget:self action:@selector(didEditButton) forControlEvents:UIControlEventTouchUpInside];
    [btSalvar setHidden:YES];
    
    UIBarButtonItem* buttonSave = [[UIBarButtonItem alloc] initWithCustomView:btSalvar];
    
    
    btCancel = [[CustomButton alloc] initWithFrame:CGRectMake(0, 5, 60, 35)];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_cancelar_normal-1"] forState:UIControlStateNormal];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_cancelar_active-1"] forState:UIControlStateHighlighted];
    [btCancel setFontSize:14];
    [btCancel setTitle:@"Voltar" forState:UIControlStateNormal];
    [btCancel addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* buttonCancel = [[UIBarButtonItem alloc] initWithCustomView:btCancel];
    
    self.navigationItem.leftBarButtonItems = @[[Utilities createEdgeSpacer], buttonCancel];
    self.navigationItem.rightBarButtonItems = @[[Utilities createSpacer], buttonSave];
}

- (void)setValues {
    
    NSString *strDoc = [Utilities checkIfNull:[self.dictUser valueForKey:@"document"]];
    if (strDoc.length == 11) {
        strDoc = [NSString stringWithFormat:@"%@.%@.%@-%@",
                  [strDoc substringWithRange:NSMakeRange(0, 3)],
                  [strDoc substringWithRange:NSMakeRange(3, 3)],
                  [strDoc substringWithRange:NSMakeRange(6, 3)],
                  [strDoc substringWithRange:NSMakeRange(8, 2)]
                  ];
    }
    
    [self.tfName setText:[Utilities checkIfNull:[self.dictUser valueForKey:@"name"]]];
    [self.tfEmail setText:[Utilities checkIfNull:[self.dictUser valueForKey:@"email"]]];
    //    [self.tfPass setText:[self.dictUser valueForKey:@"encrypted_password"]];
    //    [self.tfConfirmPass setText:[self.dictUser valueForKey:@"encrypted_password"]];
    [self.tfPhone setText:[Utilities checkIfNull:[self.dictUser valueForKey:@"phone"]]];
    [self.tfCpf setText:strDoc];
    [self.tfBairro setText:[Utilities checkIfNull:[self.dictUser valueForKey:@"district"]]];
    [self.tfAddress setText:[Utilities checkIfNull:[self.dictUser valueForKey:@"address"]]];
    [self.tfComplement setText:[Utilities checkIfNull:[self.dictUser valueForKey:@"address_additional"]]];
    [self.tfCep setText:[Utilities checkIfNull:[self.dictUser valueForKey:@"postal_code"]]];
    [self.tfCidade setText:[Utilities checkIfNull:[self.dictUser valueForKey:@"city"]]];
}

- (void)logout {
    if ([Utilities isIpad] || self.isFromReportView) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didEditButton {
    [self updateUser];
}

- (void)showOverlay {
    btSalvar.hidden = YES;
    
    UIColor* fromColor = [UIColor clearColor];
    UIColor* toColor = [UIColor colorWithWhite:1 alpha:.5];
    
    self.viewOverlay.backgroundColor = fromColor;
    self.viewOverlay.hidden = NO;
    
    [UIView animateWithDuration:.250 animations:^{
        self.viewOverlay.backgroundColor = toColor;
    }];
}

- (void)hideOverlay {
    btSalvar.hidden = NO;
    
    UIColor* fromColor = [UIColor colorWithWhite:1 alpha:.5];
    UIColor* toColor = [UIColor clearColor];
    
    self.viewOverlay.backgroundColor = fromColor;
    
    [UIView animateWithDuration:.250 animations:^{
        self.viewOverlay.backgroundColor = toColor;
    } completion:^(BOOL finished) {
        self.viewOverlay.hidden = YES;
    }];
}

- (void)reloadButtons {
    if (socialType == kSocialNetworkAnyone) {
        for (UIButton *bt in self.arrBt) {
            [bt setSelected:YES];
            [bt setAlpha:1];
        }
        
        [self.lblSocialSentence setText:@"Conecte a uma das redes sociais para compartilhar suas solicitações."];
    } else {
        
        NSString *currentSocialName = nil;
        
        if (socialType == kSocialNetworFacebook) {
            currentSocialName = @"Facebook";
        } else if (socialType == kSocialNetworTwitter) {
            currentSocialName = @"Twitter";
        }
        
        for (UIButton *bt in self.arrBt) {
            if ([bt tag] == socialType) {
                [bt setSelected:YES];
                [bt setAlpha:1];
            } else {
                [bt setSelected:NO];
                [bt setAlpha:0.65];
            }
        }
        
        self.lblSocialSentence.text = [NSString stringWithFormat:@"O compartilhamento de suas solicitações está atualmente vinculado ao %@", currentSocialName];
        
        if (self.isFromReportView) {
            [self.solicitView handleSocialView];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)openActionSheet {
    __weak __typeof(self)weakSelf = self;
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:[UIApplication displayName]
                                                                   message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"Desvincular" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [UserDefaults setIsUserLoggedOnSocialNetwork:kSocialNetworkAnyone];
        socialType = kSocialNetworkAnyone;
        [weakSelf reloadButtons];
    }]];
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)showAlertView {
    __weak __typeof(self)weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[UIApplication displayName]
                                                                   message:@"Ao vincular uma nova rede social, a conexão anterior será desativada."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (socialType == kSocialNetworFacebook) {
            [weakSelf callFacebook];
        } else if (socialType == kSocialNetworTwitter) {
            [weakSelf callTwitter];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showErrorWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - Keyboard Handle

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height - 48, 0.0);
    self.scroll.contentInset = contentInsets;
    self.scroll.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [self.scroll setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.2 animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 50, 0);
        self.scroll.contentInset = contentInsets;
        self.scroll.scrollIndicatorInsets = contentInsets;
    }];
}

#pragma mark - Text Field Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [textField setBackground:[UIImage imageNamed:@"textbox_1linha-larga_normal"]];

    activeField = textField;
    
    if (![Utilities isIpad]) {
        if (textField != self.tfBairro && textField != self.tfComplement && textField != self.tfCep) {
            
            float position;
            
            position = textField.frame.origin.y -20;
            [self.scroll setContentOffset:CGPointMake(0, position) animated:YES];
            
        }
    }
    
    for (UITextField *tf in self.arrTf) {
        if (textField == tf) {
            if (textField.frame.size.width > 145)
                [textField setBackground:[UIImage imageNamed:@"textbox_1linha-larga_active"]];
            else
                [textField setBackground:[UIImage imageNamed:@"textbox_1linha-curta_active"]];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    
    for (UITextField *tf in self.arrTf) {
        if (textField == tf) {
            if (textField.frame.size.width > 145)
                [textField setBackground:[UIImage imageNamed:@"textbox_1linha-larga_normal"]];
            else
                [textField setBackground:[UIImage imageNamed:@"textbox_1linha-curta_normal"]];
            
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.tfName)
        [self.tfEmail becomeFirstResponder];
    else if (textField == self.tfEmail)
        [self.tfPass becomeFirstResponder];
    else if (textField == self.tfPass)
        [self.tfConfirmPass becomeFirstResponder];
    else if (textField == self.tfConfirmPass)
        [self.tfPhone becomeFirstResponder];
    else if (textField == self.tfPhone)
        [self.tfCpf becomeFirstResponder];
    else if (textField == self.tfCpf)
        [self.tfAddress becomeFirstResponder];
    else if (textField == self.tfAddress)
        [self.tfComplement becomeFirstResponder];
    else if (textField == self.tfComplement)
        [self.tfCep becomeFirstResponder];
    else if (textField == self.tfCep)
        [self.tfBairro becomeFirstResponder];
    else if (textField == self.tfBairro)
        [self.tfCidade becomeFirstResponder];
    else if(textField == self.tfCidade)
        [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *nonNumberSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSString *strNew = [string stringByTrimmingCharactersInSet:nonNumberSet];
    
    if (textField == self.tfCpf) {

        if (strNew.length > 0) {
            return NO;
        }
        
        if (range.length > 0) {
            //[textField setText:@""];
            return YES;
        }
        
        if (range.location == 14) {
            return NO;
        }
        
        if ((range.location == 3) || (range.location == 7)) {
            NSString *str    = [NSString stringWithFormat:@"%@.",textField.text];
            textField.text   = str;
        }
        
        if (range.location == 11) {
            NSString *str    = [NSString stringWithFormat:@"%@-",textField.text];
            textField.text   = str;
        }
        
        return YES;
        
    }
    
    if (textField == self.tfPhone) {
        
        if (strNew.length > 0) {
            return NO;
        }

        
        if (range.length > 0) {
            //[textField setText:@""];
            return YES;
        }
        
        if (range.location == 15 /* 13, 14 */) {
            return NO;
        }
        
        if (range.location == 9) {
            NSString *str    = [NSString stringWithFormat:@"%@-",textField.text];
            textField.text   = str;
        }

        
        if (range.location == 0) {
            NSString *str    = [NSString stringWithFormat:@"%@(",textField.text];
            textField.text   = str;
        }
        
        if (range.location == 3) {
            NSString *str    = [NSString stringWithFormat:@"%@) ",textField.text];
            textField.text   = str;
        }
        
        if (range.location == 14) {
            NSString* digits = [textField.text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, textField.text.length)];
            
            NSString* ddd = [digits substringWithRange:NSMakeRange(0, 2)];
            NSString* firstbit = [digits substringWithRange:NSMakeRange(2, 5)];
            NSString* secondbit = [digits substringWithRange:NSMakeRange(7, 3)];
            
            textField.text = [NSString stringWithFormat:@"(%@) %@-%@", ddd, firstbit, secondbit];
        }
        
        return YES;
    }
    
    if (textField == self.tfCep) {
        
        if (strNew.length > 0) {
            return NO;
        }

        
        if (range.length > 0) {
            //[textField setText:@""];
            return YES;
        }
        
        if (range.location == 9) {
            [textField resignFirstResponder];
            return NO;
        }
      
        if (range.location == 5)
        {
            
            NSString *str    = [NSString stringWithFormat:@"%@-",textField.text];
            textField.text   = str;
        }
    }
    
    return YES;
}

- (BOOL)checkFields {
    BOOL isEmpty = NO;
    
    for (UITextField *tf in self.arrTf) {
        if (tf.text.length == 0 && tf != self.tfComplement && tf != self.tfcurrentPass && tf != self.tfPass && tf != self.tfConfirmPass) {
            
            tf.background = [UIImage imageNamed:@"textbox_1linha-larga_normal"];
            tf.background = [Utilities changeColorForImage:tf.background toColor:[UIColor redColor]];
            
            isEmpty = YES;
        }
    }
    
    BOOL isNoPhone = NO;
    BOOL isNoCpf = NO;
    BOOL isNoCep = NO;
    BOOL isPasswordShort = NO;
    
    if (self.tfPhone.text.length != 14 && self.tfPhone.text.length != 15) {
        self.tfPhone.background = [UIImage imageNamed:@"textbox_1linha-larga_normal"];
        self.tfPhone.background = [Utilities changeColorForImage:self.tfPhone.background toColor:[UIColor redColor]];
        isEmpty = YES;
        isNoPhone = YES;
    }
    
    if (self.tfCpf.text.length != 14) {
        self.tfCpf.background = [UIImage imageNamed:@"textbox_1linha-larga_normal"];
        self.tfCpf.background = [Utilities changeColorForImage:self.tfCpf.background toColor:[UIColor redColor]];
        isEmpty = YES;
        isNoCpf = YES;
    }
    
    if (self.tfCep.text.length != 9) {
        self.tfCep.background = [UIImage imageNamed:@"textbox_1linha-larga_normal"];
        self.tfCep.background = [Utilities changeColorForImage:self.tfCep.background toColor:[UIColor redColor]];
        isNoCep = YES;
        isEmpty = YES;
    }
    
    if(self.tfPass.text.length > 0 && self.tfPass.text.length < 6) {
        self.tfPass.background = [UIImage imageNamed:@"textbox_1linha-larga_normal"];
        self.tfPass.background = [Utilities changeColorForImage:self.tfCep.background toColor:[UIColor redColor]];
        isPasswordShort = YES;
        isEmpty = YES;
    }
    
    if (isEmpty) {
        
        BOOL isSpecific = NO;
        NSString *msg = nil;
        
        if (isNoCep || isNoCpf || isNoPhone || isPasswordShort) {
            isSpecific = YES;
            if (isNoPhone) {
                msg = @"Erro no campo Telefone.";
            } else if (isNoCep) {
                msg = @"Erro no campo CEP.";
            } else if(isNoCpf) {
                msg = @"Erro no campo CPF.";
            } else {
                msg = @"A senha deve ter no mínimo 6 caracteres.";
            }
            
        }
        
        for (UITextField *tf in self.arrTf) {
            if (tf.text.length == 0 && tf != self.tfCep && tf != self.tfCpf && tf != self.tfPhone && tf != self.tfComplement) {
                isSpecific = NO;
            }
        }
        
        if (!isSpecific) {
            msg = @"Preencha todos os campos!";
        }
        
        [Utilities alertWithMessage:msg inViewController:self];
    }
    
    return isEmpty;
}

#pragma mark - Networking

- (void)didReceiveData:(NSData *)data response:(NSURLResponse *)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UITextField *tf in self.arrTf) {
            tf.enabled = YES;
        }
        [self hideOverlay];
        
        if (![data isKindOfClass:[NSNull class]]) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if ([Utilities isIpad]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            if ([dict valueForKeyPath:@"errors.email"]) {
                [Utilities alertWithError:[[dict valueForKeyPath:@"errors.email"]objectAtIndex:0] inViewController:self];
            } else if ([dict valueForKey:@"message"]) {
                [Utilities alertWithMessage:[dict valueForKey:@"message"] inViewController:self];
            }
            
            [self.perfilView getUserDetails];
        }
    });
}

- (void)updateUser {
    if (self.tfPass.text.length > 0 && self.tfCurrentPassword.text.length == 0) {
        [Utilities alertWithError:@"Para criar uma nova senha é necessário digitar a senha atual." inViewController:self];
        return;
    }
    
    if (![self.tfConfirmPass.text isEqualToString:self.tfPass.text]) {
        [Utilities alertWithError:@"Confirmação de senha não coincide!" inViewController:self];
        return;
    }
    
    if ([self checkFields]) {
        return;
    }
    
    if ([Utilities isInternetActive]) {
        for (UITextField *tf in self.arrTf) {
            tf.enabled = NO;
        }
        [self showOverlay];
        
        ServerOperations *serverOp = [[ServerOperations alloc]init];
        [serverOp setTarget:self];
        [serverOp setAction:@selector(didReceiveData:response:)];
        [serverOp setActionErro:@selector(didReceiveError:operation:data:)];
        [serverOp updateUser:self.tfEmail.text currentPassword:self.tfCurrentPassword.text pass:self.tfPass.text name:self.tfName.text phone:self.tfPhone.text document:self.tfCpf.text address:self.tfAddress.text addressAdditional:self.tfComplement.text postalCode:self.tfCep.text district:self.tfBairro.text city:self.tfCidade.text];
    } else {
        [Utilities alertWithError:@"Verifique sua conexão com a internet e tente novamente." inViewController:self];
    }
}

- (void)didReceiveError:(NSError *)error operation:(ServerOperations *)operation data:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UITextField *tf in self.arrTf) {
            tf.enabled = YES;
        }
        [self hideOverlay];
        
        NSString *message;
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            message = @"";
            
            NSDictionary* fields = @{
                                     @"name": self.tfName,
                                     @"email": self.tfEmail,
                                     @"password": self.tfPass,
                                     @"password_confirmation": self.tfConfirmPass,
                                     @"phone": self.tfPhone,
                                     @"document": self.tfCpf,
                                     @"address": self.tfAddress,
                                     @"address_additional": self.tfComplement,
                                     @"postal_code": self.tfCep,
                                     @"district": self.tfBairro,
                                     @"city": self.tfCidade,
                                     @"current_password": self.tfCurrentPassword
                                     };
            
            for(NSString *key in [fields keyEnumerator]) {
                UITextField *field = [fields valueForKey:key];
                field.background = [UIImage imageNamed:@"textbox_1linha-larga_normal"];
            }
            
            NSDictionary *errorDict = [dict valueForKey:@"error"];
            for (NSString *key in [errorDict keyEnumerator]) {
                NSArray *messageArray = [errorDict valueForKey:key];
                NSString *keymessages = @"";
                
                for (NSString *msg in messageArray) {
                    keymessages = [keymessages stringByAppendingFormat:@"%@\r", msg];
                }
                
                message = [message stringByAppendingFormat:@"%@: %@\r", key, keymessages];
                
                UITextField* field = [fields valueForKey:key];
                field.background = [UIImage imageNamed:@"textbox_1linha-larga_normal"];
                field.background = [Utilities changeColorForImage:self.tfEmail.background toColor:[UIColor redColor]];
                
                [self.scroll scrollsToTop];
            }
        } else {
            message = [NSString stringWithFormat:@"Erro ao editar perfil.\r%@", error.localizedDescription];
            [Utilities alertWithMessage:message inViewController:self];
        }
        // [Utilities alertWithMessage:error.localizedDescription];
        //    [Utilities alertWithMessage:@"Preencha os campos obrigatórios."];
    });
}

- (void)getUserDetails {
    if ([Utilities isInternetActive]) {
        ServerOperations *serverOp = [[ServerOperations alloc]init];
        [serverOp setTarget:self];
        [serverOp setAction:@selector(didReceiveDetailsData:)];
        [serverOp setActionErro:@selector(didReceiveDetailsError:data:)];
        [serverOp getDetails];
    } else {
        [Utilities alertWithError:@"Verifique sua conexão com a internet e tente novamente." inViewController:self];
    }
}

- (void)didReceiveDetailsData:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (![Utilities checkIfError:dict]) {
            self.dictUser = [[NSDictionary alloc]initWithDictionary:[dict valueForKey:@"user"]];
            [self setValues];
        } else {
            [Utilities alertWithError:[dict valueForKey:@"error"] inViewController:self];
        }
    });
}

- (void)didReceiveDetailsError:(NSError *)error data:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
       [Utilities alertWithServerErrorInViewController:self];
    });
}

#pragma mark - Actions

- (IBAction)btFacebook:(id)sender {
    socialType = kSocialNetworFacebook;
    
    if ([UserDefaults getSocialNetworkType] != kSocialNetworFacebook && [UserDefaults getSocialNetworkType] != kSocialNetworkAnyone) {
        
        [self showAlertView];
        
    } else if ([UserDefaults getSocialNetworkType] == kSocialNetworFacebook){
        
        [self openActionSheet];
        
    } else {
        [self callFacebook];
    }
}

#pragma mark - Facebook

- (void)callFacebook {
    [self.spin startAnimating];
    
    if ([UserDefaults getSocialNetworkType] == kSocialNetworFacebook) {
//        [FBSession.activeSession closeAndClearTokenInformation];
//        [FBSession.activeSession close];
        [UserDefaults setIsUserLoggedOnSocialNetwork:kSocialNetworkAnyone];
    } else {
        if ([Utilities isInternetActive]) {
            __weak __typeof(self)weakSelf = self;
            NSArray* arrayPermissions = @[
                                          @"publish_actions",
                                          @"publish_stream"
                                          ];
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            login.loginBehavior = FBSDKLoginBehaviorNative;
            
            [login logInWithReadPermissions:arrayPermissions fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                if (error) {
                    [weakSelf showErrorWithMessage:@"Falha de conexão"];
                } else if (result.isCancelled) {
                    [weakSelf showErrorWithMessage:@"Facebook não autorizou o seu login."];
                } else {
                    if ([result.grantedPermissions containsObject:@"email"]) {
                        if ([FBSDKAccessToken currentAccessToken]) {
                            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                            [parameters setValue:@"id, name, email, friends{id,name,picture}" forKey:@"fields"];
                            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (!error) {
                                        [UserDefaults setFbToken:[FBSDKAccessToken currentAccessToken].tokenString];
                                        [UserDefaults setIsUserLoggedOnSocialNetwork:kSocialNetworFacebook];
                                        [weakSelf reloadButtons];
                                    } else {
                                        [weakSelf showErrorWithMessage:@"Não foi possível logar com o Facebook. Verifique sua conexão com a internet."];
                                    }
                                    [weakSelf.spin stopAnimating];
                                });
                            }];
                        }
                    }
                }
            }];
        } else {
            [Utilities alertWithError:@"Verifique sua conexão com a internet e tente novamente." inViewController:self];
        }
    }
}

#pragma mark - Twitter

- (IBAction)btTwitter:(id)sender {
    
    socialType = kSocialNetworTwitter;
    
    if ([UserDefaults getSocialNetworkType] != kSocialNetworTwitter && [UserDefaults getSocialNetworkType] != kSocialNetworkAnyone) {
        [self showAlertView];
    } else if ([UserDefaults getSocialNetworkType] == kSocialNetworTwitter) {
        [self openActionSheet];
    } else {
        [self callTwitter];
    }
}

- (void)callTwitter {
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    if ([accountType accessGranted]) {
        [self _showListOfTwitterAccountsFromStore:accountStore];
    } else {
        // need access first
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [self _showListOfTwitterAccountsFromStore:accountStore];
                } else {
                    [Utilities alertWithMessage:[NSString stringWithFormat:@"O %@ não tem permissão para acessar sua conta do Twitter", [UIApplication displayName]]
                               inViewController:self];
                    
                    [self.spin stopAnimating];
                }
            });
        }];
    }
}

- (void)_showListOfTwitterAccountsFromStore:(ACAccountStore *)accountStore {
    
    [self.spin startAnimating];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];
    
    if (twitterAccounts.count > 0) {
        
        ACAccount *account = [twitterAccounts objectAtIndex:0];
        
        NSString *strName = account.userFullName;
        
        if (strName.length == 0) {
            strName = account.username;
        }
        
        _apiManager = [[TWAPIManager alloc]init];
        
        [_apiManager performReverseAuthForAccount:account withHandler:^(NSData *responseData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (responseData) {
                    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"Reverse Auth process returned: %@", responseStr);
                    [self.spin stopAnimating];
                    
                    NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
                    NSString *lined = [parts componentsJoinedByString:@"\n"];
                    NSLog(@"%@", lined);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:lined delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        //                    [alert show];
                        
                        [UserDefaults setIsUserLoggedOnSocialNetwork:kSocialNetworTwitter];
                        [self reloadButtons];
                        
                    });
                }
                else {
                    NSLog(@"Reverse Auth process failed. Error returned was: %@\n", [error localizedDescription]);
                }
            });
        }];
        
    } else {
        [Utilities alertWithMessage:@"Você não tem nenhuma conta do Twitter configurada. Por favor, vá até Ajustes e adicione." inViewController:self];
        [self.spin stopAnimating];
    }
}

@end
