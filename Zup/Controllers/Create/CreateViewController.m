//
//  CreateViewController.m
//  Zup
//

#import "CreateViewController.h"
#import "SocialViewController.h"
#import "TermosViewController.h"
#import "TabBarController.h"

UITextField *activeField;


@interface CreateViewController ()

@end

@implementation CreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    NSString *titleStr = @"Nova conta";
    
    if ([Utilities isIOS7]) {
        [self setTitle:titleStr];
    } else {
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        [lblTitle setFont:[Utilities fontOpensSansLightWithSize:18]];
        [lblTitle setTextColor:[UIColor blackColor]];
        [lblTitle setText:titleStr];
        [self.navigationController.navigationBar.topItem setTitleView:lblTitle];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    
    [self.lblTitle1 setFont:[Utilities fontOpensSansLightWithSize:16]];
    [self.lblTitle2 setFont:[Utilities fontOpensSansLightWithSize:16]];
    
    [self.scroll setContentSize:self.scroll.frame.size];
    
    
    if ([Utilities isIpad]) {
        
        [self.view setFrame:CGRectMake(0, 0, 620, 568)];
        
        [self.scroll setFrame:CGRectMake(0, 0, 620,620)];
        
        CGRect framePass = self.tfPass.frame;
        framePass.origin.x = 15;
        [self.tfPass setFrame:framePass];
        
        CGRect framePhone = self.tfPhone.frame;
        framePhone.origin.x = 15;
        [self.tfPhone setFrame:framePhone];
        
        CGRect frameComp = self.tfComplement.frame;
        frameComp.origin.x = 15;
        [self.tfComplement setFrame:frameComp];
        
        CGRect frameConfirm = self.tfConfirmPass.frame;
        frameConfirm.origin.x = 165;
        [self.tfConfirmPass setFrame:frameConfirm];
        
        CGRect frameCpf = self.tfCpf.frame;
        frameCpf.origin.x = 165;
        [self.tfCpf setFrame:frameCpf];
        
        CGRect frameCep = self.tfCep.frame;
        frameCep.origin.x = 165;
        [self.tfCep setFrame:frameCep];
        
    } else {
        [self.scroll setFrame:self.view.bounds];
    }
    
    [self registerForKeyboardNotifications];
    [self.view addSubview:self.scroll];
    
    for (UITextField *textField in self.arrTf) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, textField.frame.size.height)];
        leftView.backgroundColor = [UIColor clearColor];
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        
        [textField setFont:[Utilities fontOpensSansLightWithSize:14]];
    }
    
    [self.navigationItem setHidesBackButton:YES];
    
    btCreate = [[CustomButton alloc] init];
    [btCreate setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_normal-1"] forState:UIControlStateNormal];
    [btCreate setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_active-1"] forState:UIControlStateHighlighted];
    [btCreate setFontSize:14];
    [btCreate setTitle:@"Criar" forState:UIControlStateNormal];
    [btCreate setHighlighted:NO];
    
    [btCreate addTarget:self action:@selector(didCreateButton) forControlEvents:UIControlEventTouchUpInside];
    /*if ([Utilities isIpad]) {
        [btCreate setFrame:CGRectMake(390, 5, 74, 35)];
    } else {
        //[btCreate setFrame:CGRectMake(240, 5, 74, 35)];
        [btCreate setFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width - 74 - 5, 5, 74, 35)];
    }*/
    [btCreate setFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width - 74 - 5, 5, 74, 35)];
    btCreate.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.navigationController.navigationBar addSubview:btCreate];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Cadastro";
    
    if (![Utilities isIpad]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }

    btCancel = [[CustomButton alloc] initWithFrame:CGRectMake(5, 5, 74, 35)];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_sair_normal"] forState:UIControlStateNormal];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_sair_active"] forState:UIControlStateHighlighted];
    [btCancel setFontSize:14];
    [btCancel setTitle:@"Cancelar" forState:UIControlStateNormal];
    [btCancel addTarget:self action:@selector(didCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:btCancel];
    
  
    if (isFirstTime) {
        CGRect frame = btCreate.frame;
        
        /*if ([Utilities isIpad]) {
            frame.origin.x = 420;
        } else {
            frame.origin.x = 240;
        }*/
        frame.origin.x = self.navigationController.navigationBar.frame.size.width - frame.size.width - 5;

        [btCreate setFrame:frame];
    }
    
    isFirstTime = YES;

    [btCreate setHidden:NO];

}

- (BOOL)checkFields {
    BOOL isEmpty = NO;
    
    for (UITextField *tf in self.arrTf) {
        if (tf.text.length == 0 && tf != self.tfComplement) {
            
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
    
    if(self.tfPass.text.length < 6) {
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
        
        [Utilities alertWithMessage:msg];
        
    }
    
    return isEmpty;
}

- (void)didCreateButton {

    if ([self checkFields]) {
    
        return;
        
    }
    
    if (![Utilities isValidEmail:self.tfEmail.text]) {
        self.tfEmail.background = [UIImage imageNamed:@"textbox_1linha-larga_normal"];
        self.tfEmail.background = [Utilities changeColorForImage:self.tfEmail.background toColor:[UIColor redColor]];
        
        [self.scroll scrollsToTop];
        return;
    }
    
    if (![Utilities isValidCPF:self.tfCpf.text]) {
        [Utilities alertWithError:@"CPF inválido!"];
        
        self.tfCpf.background = [UIImage imageNamed:@"textbox_1linha-larga_normal"];
        self.tfCpf.background = [Utilities changeColorForImage:self.tfCpf.background toColor:[UIColor redColor]];
        
        [self.scroll scrollsToTop];
        return;
    }
    
    if (![self.tfConfirmPass.text isEqualToString:self.tfPass.text]) {
        [Utilities alertWithError:@"Confirmação de senha não coincide!"];
        
        self.tfPass.background = [UIImage imageNamed:@"textbox_1linha-larga_normal"];
        self.tfPass.background = [Utilities changeColorForImage:self.tfPass.background toColor:[UIColor redColor]];
        self.tfConfirmPass.background = [UIImage imageNamed:@"textbox_1linha-larga_normal"];
        self.tfConfirmPass.background = [Utilities changeColorForImage:self.tfConfirmPass.background toColor:[UIColor redColor]];

        return;
    }
    
    if ([Utilities isInternetActive]) {
        [self.view endEditing:YES];
        [self showLoadingOverlay];
        
        ServerOperations *serverOp = [[ServerOperations alloc]init];
        [serverOp setTarget:self];
        [serverOp setAction:@selector(didReceiveData:response:)];
        [serverOp setActionErro:@selector(didReceiveError:operation:data:)];
        [serverOp createUser:self.tfEmail.text pass:self.tfPass.text name:self.tfName.text phone:self.tfPhone.text document:self.tfCpf.text address:self.tfAddress.text addressAdditional:self.tfComplement.text postalCode:self.tfCep.text district:self.tfBairro.text city:self.tfCidade.text];
    }
}

- (void)showLoadingOverlay
{
    btCancel.enabled = NO;
    btCreate.enabled = NO;
    self.loadingOverlay.hidden = NO;
    [self.view bringSubviewToFront:self.loadingOverlay];
}

- (void)hideLoadingOverlay
{
    btCancel.enabled = YES;
    btCreate.enabled = YES;
    self.loadingOverlay.hidden = YES;
}

- (void)didReceiveData:(NSData*)data response:(NSURLResponse*)response{
    [self hideLoadingOverlay];
    
    if (![data isKindOfClass:[NSNull class]]) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if (dict.allKeys.count == 0) {
            return;
        }
        
        if ([dict valueForKeyPath:@"errors.email"]) {
            [Utilities alertWithError:[[dict valueForKeyPath:@"errors.email"]objectAtIndex:0]];
        } else if ([dict valueForKey:@"message"]) {
            [self login];
        }
    
    }
    
}


- (void)login {
    [self showLoadingOverlay];
    
    if ([Utilities isInternetActive]) {
        ServerOperations *serverOp = [[ServerOperations alloc]init];
        [serverOp setTarget:self];
        [serverOp setAction:@selector(didReceiveLoginData:)];
        [serverOp setActionErro:@selector(didReceiveLoginError:data:)];
        [serverOp authenticate:self.tfEmail.text pass:self.tfPass.text];
    }
}

- (void)didReceiveLoginData:(NSData*)data {
    //[self hideLoadingOverlay];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    if (![Utilities checkIfError:dict]) {
        [UserDefaults setUserId:[dict valueForKeyPath:@"user.id"]];
        [UserDefaults setToken:[dict valueForKey:@"token"]];
        [UserDefaults setIsUserLogged:YES];
        
        [self.mainVC getReportCategories];
        
        //[self callNextView];
        
    }
}

- (void)didReceiveLoginError:(NSError*)error data:(NSData*)data {
    [self hideLoadingOverlay];
    [Utilities alertWithServerError];
}

- (void)callNextView {
    
    BOOL facebookEnabled = [UserDefaults isFeatureEnabled:@"social_networks_facebook"];
    BOOL twitterEnabled = [UserDefaults isFeatureEnabled:@"social_networks_twitter"];
    BOOL plusEnabled = [UserDefaults isFeatureEnabled:@"social_networks_gplus"];
    
    [btCancel removeFromSuperview];
    [btCreate removeFromSuperview];
    
    if(facebookEnabled || twitterEnabled || plusEnabled)
    {
        SocialViewController *social = [[SocialViewController alloc]initWithNibName:@"SocialViewController" bundle:nil];
        social.isFromPerfil = self.isFromPerfil;
        social.isFromSolicit = self.isFromSolicit;
        social.perfilVC = self.perfilVC;
        social.relateVC = self.relateVC;
        [self.navigationController pushViewController:social animated:YES];
    }
    else if ([Utilities isIpad])
    {
        
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"jump" object:nil];
        }];
        
    }
    else
    {
        NSString *strName = @"Main_iPhone";
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:strName bundle: nil];
        
        [self.navigationController setNavigationBarHidden:YES];
        TabBarController *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
        [self.navigationController pushViewController:tabBar animated:YES];
    }
}

- (void)didReceiveError:(NSError*)error operation:(ServerOperations*)op data:(NSData*)data {
    [self hideLoadingOverlay];
    
    NSString* message;
    if(data != nil)
    {
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
                                 @"city": self.tfCidade
                                 };
        
        for(NSString* key in [fields keyEnumerator])
        {
            UITextField* field = [fields valueForKey:key];
            field.background = [UIImage imageNamed:@"textbox_1linha-larga_normal"];
        }
        
        NSDictionary* errorDict = [dict valueForKey:@"error"];
        for(NSString* key in [errorDict keyEnumerator])
        {
            NSArray* messageArray = [errorDict valueForKey:key];
            NSString* keymessages = @"";
            
            for(NSString* msg in messageArray)
            {
                keymessages = [keymessages stringByAppendingFormat:@"%@\r", msg];
            }
            
            message = [message stringByAppendingFormat:@"%@: %@\r", key, keymessages];
            
            UITextField* field = [fields valueForKey:key];
            field.background = [UIImage imageNamed:@"textbox_1linha-larga_normal"];
            field.background = [Utilities changeColorForImage:self.tfEmail.background toColor:[UIColor redColor]];
            
            [self.scroll scrollsToTop];
        }
    }
    else
    {
        message = [NSString stringWithFormat:@"Erro ao cadastrar.\r%@", error.localizedDescription];
        [Utilities alertWithMessage:message];
    }
}

- (void)didCancelButton {
    if ([Utilities isIpad]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (self.isFromPerfil || self.isFromSolicit) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"backToMapFromPerfil" object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [btCreate setHidden:YES];
    [btCancel removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard Handle

- (void)registerForKeyboardNotifications
{
    
    if (([Utilities isIpad] && self.isFromPerfil) ||([Utilities isIpad] && self.isFromSolicit)) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{

    if ([Utilities isIpad]) {
        return;
    }
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 20, 0.0);
    self.scroll.contentInset = contentInsets;
    self.scroll.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height - 10);
        
        if (activeField != self.tfName) {
            [self.scroll setContentOffset:scrollPoint animated:YES];
        }
    }
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    if ([Utilities isIpad]) {
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationController.view.superview.bounds = CGRectMake(-25, 0, 470, 620);
        }];

        return;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        UIEdgeInsets contentInsets;
        if ([Utilities isIpad])
            contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        else
            contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        self.scroll.contentInset = contentInsets;
        self.scroll.scrollIndicatorInsets = contentInsets;
        
    }];
}

#pragma mark - Text Field Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (([Utilities isIpad] && self.isFromPerfil) ||([Utilities isIpad] && self.isFromSolicit)) {
        return;
    }
    
    activeField = textField;
    
    
    [textField setBackground:[UIImage imageNamed:@"textbox_1linha-larga_normal"]];
    
    if (![Utilities isIpad]) {
        if (textField != self.tfAddress && textField != self.tfComplement && textField != self.tfCep) {
            
        }
    } else {
        
        if (textField == self.tfComplement || textField == self.tfCep) {
            //[UIView animateWithDuration:0.2 animations:^{
            //    self.navigationController.view.superview.bounds = CGRectMake(-25, 100, 470, 620);
            //}];
        } else {
            //[UIView animateWithDuration:0.2 animations:^{
            //    self.navigationController.view.superview.bounds = CGRectMake(-25, 0, 470, 620);
            //}];
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
    else if (textField == self.tfCidade)
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


- (IBAction)btTerms:(id)sender {
    TermosViewController *termsVC = [[TermosViewController alloc]initWithNibName:@"TermosViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:termsVC];
    [self presentViewController:nav animated:YES completion:nil];
    
    if ([Utilities isIpad]) {
        nav.view.superview.bounds = CGRectMake(-25, 0, 470, 620);
        [nav.view.superview setBackgroundColor:[UIColor clearColor]];
    }
}
@end
