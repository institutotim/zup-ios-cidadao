//
//  SocialViewController.m
//  Zup
//

#import "SocialViewController.h"
#import "TabBarController.h"
#import "UIApplication+name.h"

@interface SocialViewController ()

@end


@implementation SocialViewController

@synthesize signInButton;

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
    [self.spin setHidesWhenStopped:YES];
    
    [self setTitle:@"Compartilhamento"];

    [self.btPular.titleLabel setFont:[Utilities fontOpensSansBoldWithSize:12]];
    [self.lblTitle setFont:[Utilities fontOpensSansLightWithSize:16]];
    
    // Google Plus
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin, // defined in GTLPlusConstants.h
                     nil];
    signIn.delegate = self;
    [self.signInButton addTarget:self action:@selector(didBtGPlus) forControlEvents:UIControlEventTouchUpInside];

    [self.signInButton setFrame:CGRectMake(205, 16, 60, 60)];
    
    btCancel = [[CustomButton alloc] initWithFrame:CGRectMake(0, 5, 60, 35)];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_voltar_normal-1"] forState:UIControlStateNormal];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_voltar_active-1"] forState:UIControlStateHighlighted];
    [btCancel setFontSize:14];
    [btCancel setTitle:@"Voltar" forState:UIControlStateNormal];
    [btCancel addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:btCancel];
    
    [self.navigationItem setHidesBackButton:YES];
    
    BOOL facebookEnabled = [UserDefaults isFeatureEnabled:@"social_networks_facebook"];
    BOOL twitterEnabled = [UserDefaults isFeatureEnabled:@"social_networks_twitter"];
    BOOL plusEnabled = [UserDefaults isFeatureEnabled:@"social_networks_gplus"];
    
    CGRect frameFacebook = self.btFacebool.frame;
    CGRect frameTwitter = self.btTwitter.frame;
    CGRect framePlus = self.btPlus.frame;
    
    if(!facebookEnabled)
    {
        [self.btFacebool setHidden:YES];
        frameTwitter.origin.x -= (frameFacebook.size.width / 2) + 10;
        framePlus.origin.x -= (frameFacebook.size.width / 2) + 5;
    }
    if(!twitterEnabled)
    {
        [self.btTwitter setHidden:YES];
        frameFacebook.origin.x += (frameTwitter.size.width / 2) + 5;
        framePlus.origin.x -= (frameTwitter.size.width / 2) + 5;
    }
    if(!plusEnabled)
    {
        [self.btPlus setHidden:YES];
        frameFacebook.origin.x += (framePlus.size.width / 2) + 5;
        frameTwitter.origin.x += (framePlus.size.width / 2) + 10;
    }
    
    self.btFacebool.frame = frameFacebook;
    self.btTwitter.frame = frameTwitter;
    self.btPlus.frame = framePlus;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"Conectar redes sociais";
}

- (void)viewWillDisappear:(BOOL)animated {
    [btCancel removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btPular:(id)sender {
    [self gotoNextPage];
}


- (void)gotoNextPage {
    
    if (self.isFromPerfil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([Utilities isIpad]) {
            [self.perfilVC getData];
        }
        return;
    }
    
    if (self.isFromSolicit) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([Utilities isIpad]) {
            [self.relateVC setToken];
        }

        return;
    }

    
    
    if ([Utilities isIpad]) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"jump" object:nil];
        }];
        
    } else {
        
        NSString *strName = @"Main_iPhone";
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:strName bundle: nil];
        
        [self.navigationController setNavigationBarHidden:YES];
        TabBarController *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
        [self.navigationController pushViewController:tabBar animated:YES];
    }

}

#pragma mark - Facebook

- (IBAction)btFacebook:(id)sender {
    
    [self.spin startAnimating];
    [self.viewSocialButtons setUserInteractionEnabled:NO];
    
    if ([UserDefaults getSocialNetworkType] == kSocialNetworFacebook) {
        [FBSession.activeSession closeAndClearTokenInformation];
        [UserDefaults setIsUserLoggedOnSocialNetwork:kSocialNetworkAnyone];
        
    } else {
        if ([Utilities isInternetActive]) {
            
            [self.viewSocialButtons setUserInteractionEnabled:NO];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray* arrayPermissions = @[
                                               @"publish_actions",
                                               @"publish_stream"

                                               ];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.spin startAnimating];
                });
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(!FBSession.activeSession.isOpen){
                        
                        [FBSession openActiveSessionWithPublishPermissions:arrayPermissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                            [self sessionStateChanged:session state:status error:error];
                        }];
  
                    } else {
                        [[FBSession activeSession] close];
                        [self btFacebook:nil];
                    }
                });
            });
            
            /*
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             NSArray* arrayPermissions = @[ @"email",
             @"user_about_me",
             @"user_location",
             ];
             
             dispatch_async(dispatch_get_main_queue(), ^{
             [self.spin startAnimating];
             });
             dispatch_async(dispatch_get_main_queue(), ^{
             
             if(!FBSession.activeSession.isOpen){
             
             [FBSession openActiveSessionWithReadPermissions:arrayPermissions
             allowLoginUI:YES
             completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
             [self sessionStateChanged:session state:status error:error];
             }];
             } else {
             [[FBSession activeSession] close];
             [self btFacebook:nil];
             }
             });
             });

             */
        }
    }
    
}


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error {
    
    [self.spin stopAnimating];
    
    switch (state) {
        case FBSessionStateOpen:
            [self getValuesWithSession:session];
            
            break;
            
        case FBSessionStateClosed:
            [FBSession.activeSession closeAndClearTokenInformation];
            [self.viewSocialButtons setUserInteractionEnabled:YES];
            break;
            
        case FBSessionStateClosedLoginFailed:
            
            [FBSession.activeSession closeAndClearTokenInformation];
            [self.viewSocialButtons setUserInteractionEnabled:YES];
            break;
            
        default:
            break;
    }
    
    if (error) {
    }
    
}

- (void)getValuesWithSession:(FBSession*)session {
    
    [self.spin startAnimating];
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if (!error) {
             
             [UserDefaults setFbToken:[session accessTokenData].accessToken];
             [UserDefaults setIsUserLoggedOnSocialNetwork:kSocialNetworFacebook];
             [self gotoNextPage];

         } else {
             
         }
         [self.viewSocialButtons setUserInteractionEnabled:YES];
         
         [self.spin stopAnimating];
         
     }];
    
}

#pragma mark - Twitter

- (IBAction)btTwitter:(id)sender {
    
    [self.spin startAnimating];
    [self.viewSocialButtons setUserInteractionEnabled:NO];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    if ([accountType accessGranted])
    {
        [self _showListOfTwitterAccountsFromStore:accountStore];
    }
    else
    {
        // need access first
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            if (granted)
            {
                [self _showListOfTwitterAccountsFromStore:accountStore];
            }
            else
            {
                [Utilities alertWithMessage:[NSString stringWithFormat:@"O %@ não tem permissão para acessar sua conta do Twitter", [UIApplication displayName]]];
                
                [self.spin stopAnimating];
                [self.viewSocialButtons setUserInteractionEnabled:YES];
                
            }
            
        }];
    }
}

- (void)_showListOfTwitterAccountsFromStore:(ACAccountStore *)accountStore
{
    
    [self.spin stopAnimating];
    [self.viewSocialButtons setUserInteractionEnabled:YES];
    
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
            if (responseData) {
                NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                
                NSLog(@"Reverse Auth process returned: %@", responseStr);
                
                NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
                NSString *lined = [parts componentsJoinedByString:@"\n"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:lined delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    //[alert show];
                    
                    [UserDefaults setIsUserLoggedOnSocialNetwork:kSocialNetworTwitter];
                    [self gotoNextPage];

                });
            }
            else {
                NSLog(@"Reverse Auth process failed. Error returned was: %@\n", [error localizedDescription]);
            }
        }];
        
    } else {
        [Utilities alertWithMessage:@"Você não tem nenhuma conta do Twitter configurada. Por favor, vá até Ajustes e adicione."];
    }
    
}

#pragma mark - Google Plus

- (IBAction)btPlus:(id)sender {
    [self.spin startAnimating];
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    
    
    if (error) {
        [Utilities alertWithMessage:[NSString stringWithFormat:@"Erro ao conectar: %@",error]];
    } else {
        [self refreshInterfaceBasedOnSignIn];
        
        NSLog(@"email %@ ",[NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        NSLog(@"Received error %@ and auth object %@",error, auth);
        
        // 1. Create a |GTLServicePlus| instance to send a request to Google+.
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        
        // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        // *4. Use the "v1" version of the Google+ API.*
        plusService.apiVersion = @"v1";
        
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        
                        
                        
                        //Handle Error
                        
                    } else
                    {
                        
                        
                        NSLog(@"Email= %@",[GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@",person.identifier);
                        NSLog(@"User Name=%@",[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName]);
                        NSLog(@"Gender=%@",person.description);
                        
                        NSString *post =[[NSString alloc] initWithFormat:@"client_secret=%@&grant_type=refresh_token&refresh_token=%@&client_id=%@",kClientSecret,auth.refreshToken,kClientId];
                        
                        NSDictionary *resultDic = [self getAccessTokenGoogle:post];
                        NSLog(@"%@",[resultDic objectForKey:@"access_token"]);
                        
                        [self gotoNextPage];
                        [UserDefaults setIsUserLoggedOnSocialNetwork:kSocialNetworGooglePlus];
                    }
                }];
    }
    
    [self.spin stopAnimating];
    
}


//Call to get a valid access token G+
-(NSDictionary*)getAccessTokenGoogle:(NSString*)inputString{
    
    NSURL *url=[NSURL URLWithString:@"https://accounts.google.com/o/oauth2/token"];
    
    NSData *postData = [inputString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",data);
    
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:nil];
    
    return responseDic;
    
}

- (void)didBtGPlus {
    [self.spin startAnimating];
}

-(void)refreshInterfaceBasedOnSignIn
{
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        //self.signInButton.hidden = YES;
        // Perform other actions here, such as showing a sign-out button
    } else {
        //self.signInButton.hidden = NO;
        // Perform other actions here
    }
}

@end
