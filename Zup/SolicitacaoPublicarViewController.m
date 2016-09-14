//
//  SolicitacaoPublicarViewController.m
//  Zup
//

#import "SolicitacaoPublicarViewController.h"
#import "TermosViewController.h"
#import "EditViewController.h"
#import "PostController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "UIApplication+name.h"

@interface SolicitacaoPublicarViewController ()

@end

NSDictionary *dictTemp;
NSString *messageTemp;
NSString* linkTemp;

@implementation SolicitacaoPublicarViewController


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
    [self registerForKeyboardNotifications];
    
    NSString *titleStr = @"Nova solicitação";
    if ([Utilities isIOS7]) {
        [self setTitle:titleStr];
    } else {
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        [lblTitle setFont:[Utilities fontOpensSansLightWithSize:18]];
        [lblTitle setTextColor:[UIColor blackColor]];
        [lblTitle setText:titleStr];
        [self.navigationController.navigationBar.topItem setTitleView:lblTitle];
    }
    
    [self.lblTitle setFont:[Utilities fontOpensSansBoldWithSize:11]];
    [self.navigationItem setHidesBackButton:YES];
    
    [self.btBack.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];
    [self.btPublish.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];
    
    [self.tvDetalhe setFont:[Utilities fontOpensSansWithSize:12]];
    self.tvDetalhe.textColor = [UIColor lightGrayColor];
    
    [self handleSocialView];
    
    if ([Utilities isIpad]) {
        //        int position = 61;
        //        CGRect lblFaceFrame = self.lblFacebook.frame;
        //        lblFaceFrame.origin.x = position;
        //        [self.lblFacebook setFrame:lblFaceFrame];
        //
        //        CGRect lblConcordoFrame = self.lblConcordo.frame;
        //        lblConcordoFrame.origin.x = position;
        //        [self.lblConcordo setFrame:lblConcordoFrame];
        //
        //        CGRect btConcordoFrame = self.btTerms.frame;
        //        btConcordoFrame.origin.x -=10;
        //        [self.btTerms setFrame:btConcordoFrame];
        //
        //        CGRect swFacebookFrame = self.swFacebook.frame;
        //        swFacebookFrame.origin.x -= 44;
        //        [self.swFacebook setFrame:swFacebookFrame];
        //
        //        CGRect swConcordoFrame = self.swTerms.frame;
        //        swConcordoFrame.origin.x -= 44;
        //        [self.swTerms setFrame:swConcordoFrame];
        
        
        [self.viewContainer setCenter:self.view.center];
    }
    
    self.viewConfidential.layer.cornerRadius = 3;
    self.labelConfidential.font = [Utilities fontOpensSansLightWithSize:12];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"Comentário do Relato";
    
    NSNumber* catid = [self.dictMain valueForKey:@"catId"];
    NSDictionary* cat = [UserDefaults getCategory:[catid intValue]];
    
    if([[cat valueForKey:@"confidential"] boolValue])
    {
        self.viewConfidential.hidden = NO;
        CGRect frame = self.viewContainer.frame;
        frame.origin.y = 60;
        self.viewContainer.frame = frame;
        
        self.scroll.contentSize = CGSizeMake(self.scroll.frame.size.width, 386);
    }
    else
    {
        self.viewConfidential.hidden = YES;
        self.scroll.contentSize = CGSizeMake(self.scroll.frame.size.width, 326);
    }
}

- (void)handleSocialView {
    socialType = [UserDefaults getSocialNetworkType];
    
    [self.viewToShare setHidden:YES];
    
    BOOL facebookEnabled = [UserDefaults isFeatureEnabled:@"social_networks_facebook"];
    BOOL twitterEnabled = [UserDefaults isFeatureEnabled:@"social_networks_twitter"];
    BOOL plusEnabled = [UserDefaults isFeatureEnabled:@"social_networks_gplus"];
    
    if (facebookEnabled && socialType == kSocialNetworFacebook) {
        self.lblFacebook.hidden = NO;
        self.swFacebook.hidden = NO;
        [self.lblFacebook setText:@"Compartilhar no Facebook"];
    } else if (plusEnabled && socialType == kSocialNetworGooglePlus) {
        self.lblFacebook.hidden = NO;
        self.swFacebook.hidden = NO;
        [self.lblFacebook setText:@"Compartilhar no Google Plus"];
    } else if (twitterEnabled && socialType == kSocialNetworTwitter) {
        self.lblFacebook.hidden = NO;
        self.swFacebook.hidden = NO;
        [self.lblFacebook setText:@"Compartilhar no Twitter"];
    } else if(!facebookEnabled && !twitterEnabled && !plusEnabled) {
        self.lblFacebook.hidden = YES;
        self.swFacebook.hidden = YES;
        [self.viewToShare setHidden:YES];
    }
    else {
        self.lblFacebook.hidden = YES;
        self.swFacebook.hidden = YES;
        [self.viewToShare setHidden:NO];
    }
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildLoadingView {
    viewLoading = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 64)];
    [viewLoading setBackgroundColor:[UIColor blackColor]];
    [viewLoading setAlpha:0];
    [self.navigationController.view addSubview:viewLoading];
    
    UIActivityIndicatorView *spin = [[UIActivityIndicatorView alloc]init];
    
    if ([Utilities isIpad]) {
        [spin setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    
    [spin setCenter:self.view.center];
    [spin setHidesWhenStopped:YES];
    [viewLoading addSubview:spin];
    [spin startAnimating];
    
    [viewLoading setAlpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [viewLoading setAlpha:0.5];
    }];
    
}

- (IBAction)btPublicar:(id)sender {
    
    if (self.tvDetalhe.text.length > 800) {
        [Utilities alertWithMessage:@"Você ultrapassou o limite máximo de 800 caracteres."];
        return;
    }
    
    if ([Utilities isInternetActive]) {
        
        [self buildLoadingView];
        
        ServerOperations *serverOp = [[ServerOperations alloc]init];
        [serverOp setTarget:self];
        [serverOp setAction:@selector(didReceiveData:)];
        [serverOp setActionErro:@selector(didReceiveError:data:)];
        
        NSString *textStr = self.tvDetalhe.text;
        if ([textStr isEqualToString:@"Se desejar, detalhe a situação"]) {
            textStr = @"";
        }
        
        NSString *textStrRef = [self.dictMain valueForKey:@"reference"];
        if ([textStrRef isEqualToString:@"Ponto de referência (ex: próximo ao ponto de ônibus)"]) {
            textStrRef = @"";
        }
        
        [serverOp post:[self.dictMain valueForKey:@"latitude"]
             longitude:[self.dictMain valueForKey:@"longitude"]
     inventory_item_id:[self.dictMain valueForKey:@"inventory_category_id"]
           description:textStr
               address:[self.dictMain valueForKey:@"address"]
                images:[self.dictMain valueForKey:@"photos"]
            categoryId:[self.dictMain valueForKey:@"catId"]
             reference:textStrRef
              district:[self.dictMain valueForKey:@"district"]
                  city:[self.dictMain valueForKey:@"city"]
                 state:[self.dictMain valueForKey:@"state"]
               country:[self.dictMain valueForKey:@"country"]];        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[UIApplication displayName] message:@"Sem conexão com a internet. Tentar novamente?" delegate:self cancelButtonTitle:@"Não" otherButtonTitles:@"Sim", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self btPublicar:nil];
    }
}

- (void)didReceiveData:(NSData*)data {
    
    [viewLoading removeFromSuperview];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    dictTemp = dict;
    
    if (![Utilities checkIfError:dict]) {
        
        NSDictionary *dictCat = [UserDefaults getCategory:self.catStr.intValue];
        NSNumber* resolution_time_enabled = [dictCat valueForKey:@"resolution_time_enabled"];
        NSNumber* private_resolution_time = [dictCat valueForKey:@"private_resolution_time"];
        
        NSString* sentence;
        
        // Exibir tempo de resolução?
        if([UserDefaults isFeatureEnabled:@"show_resolution_time_to_clients"] && [resolution_time_enabled boolValue] && ![private_resolution_time boolValue])
        {
            int resolutionInt = [[dictCat valueForKey:@"resolution_time"]intValue];
        
            //int hours = resolutionInt/60/60/24;
            int time = resolutionInt / 60; // Minutes
            NSString* unit = @"minutos";
            
            if(time == 1)
                unit = @"minuto";
            
            if(time > 60)
            {
                time = time / 60;
                unit = @"horas";
                
                if(time == 1)
                    unit = @"hora";
            }
            if(time > 24)
            {
                time = time / 24;
                unit = @"dias";
                
                if(time == 1)
                    unit = @"dia";
            }
            
            NSString *timeStr = [NSString stringWithFormat:@"%i %@", time, unit];
        
            sentence = [NSString stringWithFormat:@"Você será avisado quando sua solicitação for atualizada\nAnote seu protocolo: %@\nPrazo estimado para a solução: %@", [dict valueForKeyPath:@"report.protocol"], timeStr];
        
            if (resolutionInt / 60 / 60 < 1) {
                sentence = [NSString stringWithFormat:@"Você será avisado quando sua solicitação for atualizada\nAnote seu protocolo: %@\nPrazo estimado para a solução: menos de uma hora", [dict valueForKeyPath:@"report.protocol"]];
            }
        }
        else
        {
            sentence = [NSString stringWithFormat:@"Você será avisado quando sua solicitação for atualizada\nAnote seu protocolo: %@", [dict valueForKeyPath:@"report.protocol"]];
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Solicitação enviada" message:sentence delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        SocialNetworkType social = [UserDefaults getSocialNetworkType];
        
        BOOL facebookEnabled = [UserDefaults isFeatureEnabled:@"social_networks_facebook"];
        BOOL twitterEnabled = [UserDefaults isFeatureEnabled:@"social_networks_twitter"];
        BOOL plusEnabled = [UserDefaults isFeatureEnabled:@"social_networks_gplus"];
        
        if (self.swFacebook.on && social != kSocialNetworkAnyone) {
            NSString* message = [Utilities defaultShareMessage];
            NSString* link = [Utilities linkForReportId:[[dict valueForKeyPath:@"report.id"] intValue]];
            NSString* cat = [dictCat valueForKeyPath:@"title"];
            NSString* desc = [dict valueForKeyPath:@"report.description"];
            NSString* image = @"";
            
            if(desc == nil)
                desc = @"";
            
            NSArray *arrImages = [dict valueForKeyPath:@"report.images"];
            if(arrImages != nil && [arrImages count] > 0)
            {
                NSDictionary* firstImage = [arrImages objectAtIndex:0];
                image = [firstImage valueForKey:@"high"];
            }
            
            if (social == kSocialNetworFacebook && facebookEnabled) {
                [PostController postMessageWithFacebook:message link:link linkTitle:cat linkDesc:desc image:image];
                [self dismissViewControllerAnimated:YES completion:nil];
                [self callReportDetail];
            } else if (social == kSocialNetworGooglePlus && plusEnabled) {
                [self postMessageWithGoogle:[Utilities socialShareTextForReportId:[[dict valueForKeyPath:@"report.id"] intValue]]];
                [self dismissViewControllerAnimated:YES completion:nil];
                [self callReportDetail];
            } else if (social == kSocialNetworTwitter && twitterEnabled) {
                messageTemp = message;
                linkTemp = link;
                [self postMessageWithTwitter];
                //[self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
                [self callReportDetail];
            }

            
        } else {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            [self callReportDetail];
            
//            if (social == kSocialNetworFacebook || social == kSocialNetworGooglePlus) {
//                [self dismissViewControllerAnimated:YES completion:nil];
//                [self callReportDetail];
//            } else if (social == kSocialNetworTwitter) {
//                [self postMessageWithTwitter];
//            }

        }
        
    } else {
        [Utilities alertWithError:@"Erro ao publicar."];
    }
}

- (void)didReceiveError:(NSError*)error data:(NSData*)data {
    [Utilities alertWithServerError];
    [viewLoading removeFromSuperview];
}

- (IBAction)btBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btDone:(id)sender {
    [self.tvDetalhe resignFirstResponder];
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

- (IBAction)btOpenEditView:(id)sender {
    EditViewController *editVC = [[EditViewController alloc]initWithNibName:@"EditViewController" bundle:nil];
    editVC.isFromReportView = YES;
    editVC.solicitView = self;
    
    if ([Utilities isIpad]) {
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:editVC];
        [nav setModalPresentationStyle:UIModalPresentationFormSheet];
        [self presentViewController:nav animated:YES completion:nil];
        
        if ([Utilities isIpad]) {
            nav.view.superview.bounds = CGRectMake(-25, 0, 470, 620);
            [nav.view.superview setBackgroundColor:[UIColor clearColor]];
        }
        
    } else {
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:editVC];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
}

#pragma mark - Text View Delegates

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.tvDetalhe.text isEqualToString: @"Se desejar, detalhe a situação"]) {
        [self.tvDetalhe setText:@""];
    }
    self.tvDetalhe.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(self.tvDetalhe.text.length == 0){
        self.tvDetalhe.textColor = [UIColor lightGrayColor];
        self.tvDetalhe.text = @"Se desejar, detalhe a situação";
        [self.tvDetalhe resignFirstResponder];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        
        if(self.tvDetalhe.text.length == 0){
            self.tvDetalhe.textColor = [UIColor lightGrayColor];
            self.tvDetalhe.text = @"Se desejar, detalhe a situação";
            [self.tvDetalhe resignFirstResponder];
        }
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - Keyboard Handle

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    if ([Utilities isIpad]) {
        return;
    }
    
    CGRect frame = self.tvDetalhe.frame;
    frame.size.height -=40;
    [UIView animateWithDuration:0.2 animations:^{
        [self.tvDetalhe setFrame:frame];
    }];
    
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    if ([Utilities isIpad]) {
        return;
    }
    
    CGRect frame = self.tvDetalhe.frame;
    frame.size.height += 40;
    [UIView animateWithDuration:0.2 animations:^{
        [self.tvDetalhe setFrame:frame];
    }];
    
}

#pragma mark - G+

- (void)postMessageWithGoogle:(NSString*)message {
    
    
    messageTemp = message;
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.clientID = kClientId;

    [signIn trySilentAuthentication];

    if ([signIn authentication]) {
        signIn.scopes = [NSArray arrayWithObjects:
                         kGTLAuthScopePlusLogin,kGTLAuthScopePlusMe,
                         nil]; //// defined in GTLPlusConstants.h
        
        [signIn setDelegate:self];
        [signIn authenticate];
        
    } else {
        [self postGPlus];
    }
   
}


- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    
    if (error) {
        
        [Utilities alertWithMessage:[NSString stringWithFormat:@"Erro ao publicar no Google Plus.\n%@", error.localizedDescription]];
    }
    
    else{
        
        [self postGPlus];
        
    }
}

- (void)postGPlus {
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
    
    // This line will fill out the title, description, and thumbnail of the item
    // you're sharing based on the URL you included.
    [shareBuilder setURLToShare:[NSURL URLWithString:@"http://www.globo.com"]];//
    
    [shareBuilder setPrefillText:messageTemp];
    // if somebody opens the link on a supported mobile device
    //    [shareBuilder setContentDeepLinkID:@"rest=1234567"];
    
    [shareBuilder open];
    

}


- (void)postMessageWithTwitter {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
                [self callReportDetail];
            }];
        };
        
        
        controller.completionHandler =myBlock;
        
        [controller setInitialText:messageTemp];
        [controller addURL:[NSURL URLWithString:linkTemp]];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
    else{
        NSLog(@"UnAvailable");
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self callReportDetail];
    }
}

- (void)callReportDetail {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backToMap" object:nil userInfo:dictTemp];
}

@end
