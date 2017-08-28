//
//  SocialViewController.m
//  Zup
//

#import "SocialViewController.h"
#import "TabBarController.h"
#import "UIApplication+name.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SocialViewController ()

@end

@implementation SocialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
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
    
    [self setTitle:@"Compartilhamento"];

    [self.btPular.titleLabel setFont:[Utilities fontOpensSansBoldWithSize:12]];
    [self.lblTitle setFont:[Utilities fontOpensSansLightWithSize:16]];
    
    self.btCancel = [[CustomButton alloc] initWithFrame:CGRectMake(0, 5, 60, 35)];
    [self.btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_voltar_normal-1"] forState:UIControlStateNormal];
    [self.btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_voltar_active-1"] forState:UIControlStateHighlighted];
    [self.btCancel setFontSize:14];
    [self.btCancel setTitle:@"Voltar" forState:UIControlStateNormal];
    [self.btCancel addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:btCancel];
    
    [self.navigationItem setHidesBackButton:YES];
    
    BOOL facebookEnabled = [UserDefaults isFeatureEnabled:@"social_networks_facebook"];
    BOOL twitterEnabled = [UserDefaults isFeatureEnabled:@"social_networks_twitter"];
    
    CGRect frameFacebook = self.btFacebool.frame;
    CGRect frameTwitter = self.btTwitter.frame;
    
    if (!facebookEnabled) {
        [self.btFacebool setHidden:YES];
        frameTwitter.origin.x -= (frameFacebook.size.width / 2) + 10;
    }
    if (!twitterEnabled) {
        [self.btTwitter setHidden:YES];
        frameFacebook.origin.x += (frameTwitter.size.width / 2) + 5;
    }
    
    self.btFacebool.frame = frameFacebook;
    self.btTwitter.frame = frameTwitter;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Conectar redes sociais";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.btCancel removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
        [UserDefaults setIsUserLoggedOnSocialNetwork:kSocialNetworkAnyone];
    } else {
        if ([Utilities isInternetActive]) {
            [self.viewSocialButtons setUserInteractionEnabled:NO];
            NSArray* arrayPermissions = @[
                                          @"publish_actions",
                                          @"publish_stream"
                                          
                                          ];
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            login.loginBehavior = FBSDKLoginBehaviorNative;
            __weak __typeof(self)weakSelf = self;
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
                                if (!error) {
                                    [UserDefaults setFbToken:[FBSDKAccessToken currentAccessToken].tokenString];
                                    [UserDefaults setIsUserLoggedOnSocialNetwork:kSocialNetworFacebook];
                                    [self gotoNextPage];
                                } else {
                                    [weakSelf showErrorWithMessage:@"Não foi possível logar com o Facebook. Verifique sua conexão com a internet."];
                                }
                                [weakSelf.viewSocialButtons setUserInteractionEnabled:YES];
                                [weakSelf.spin stopAnimating];
                            }];
                        }
                    }
                }
            }];
        }
    }
}

#pragma mark - Twitter

- (IBAction)btTwitter:(id)sender {
    [self.spin startAnimating];
    [self.viewSocialButtons setUserInteractionEnabled:NO];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    if ([accountType accessGranted]) {
        [self _showListOfTwitterAccountsFromStore:accountStore];
    } else {
        __weak __typeof(self)weakSelf = self;
        // need access first
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            if (granted) {
                [weakSelf _showListOfTwitterAccountsFromStore:accountStore];
            } else {
                [Utilities alertWithMessage:[NSString stringWithFormat:@"O %@ não tem permissão para acessar sua conta do Twitter", [UIApplication displayName]]];
                
                [weakSelf.spin stopAnimating];
                [weakSelf.viewSocialButtons setUserInteractionEnabled:YES];
            }
        }];
    }
}

- (void)_showListOfTwitterAccountsFromStore:(ACAccountStore *)accountStore {
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
        __weak __typeof(self)weakSelf = self;
        self.apiManager = [[TWAPIManager alloc] init];
        [self.apiManager performReverseAuthForAccount:account withHandler:^(NSData *responseData, NSError *error) {
            if (responseData) {
                NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                
                NSLog(@"Reverse Auth process returned: %@", responseStr);
                
                NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
                NSString *lined = [parts componentsJoinedByString:@"\n"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:lined delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    //[alert show];
                    [UserDefaults setIsUserLoggedOnSocialNetwork:kSocialNetworTwitter];
                    [weakSelf gotoNextPage];
                });
            } else {
                NSLog(@"Reverse Auth process failed. Error returned was: %@\n", [error localizedDescription]);
            }
        }];
    } else {
        [Utilities alertWithMessage:@"Você não tem nenhuma conta do Twitter configurada. Por favor, vá até Ajustes e adicione."];
    }
}

#pragma mark - Auxiliar Methods

- (void)showErrorWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
