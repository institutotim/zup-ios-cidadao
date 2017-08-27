//
//  PerfilViewController.m
//  Zup
//

#import "PerfilViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CellMinhaConta.h"
#import "EditViewController.h"
#import "PerfilDetailViewController.h"
//#import "LoginViewController.h"
#import "MainViewController.h"
#import "HeaderProfileCell.h"
#import "UIApplication+name.h"

@interface PerfilViewController ()

@end

@implementation PerfilViewController

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
    [self.view sendSubviewToBack:self.spin];
    
    NSString *titleStr = @"Minha conta";
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    [lblTitle setFont:[Utilities fontOpensSansLightWithSize:18]];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setText:titleStr];
    [self.navigationController.navigationBar.topItem setTitleView:lblTitle];
    
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.table registerNib:[UINib nibWithNibName:@"CellMinhaConta" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    [self.table registerNib:[UINib nibWithNibName:@"HeaderProfileCell" bundle:nil] forCellReuseIdentifier:@"CellHeader"];
    
    
    [self.table setBackgroundColor:[UIColor clearColor]];
    [self.table setDataSource:self];
    [self.table setDelegate:self];
    
    [self.lblSoliciations setFont:[Utilities fontOpensSansBoldWithSize:12]];
    [self.lblName setFont:[Utilities fontOpensSansLightWithSize:16]];
    
    [self.imgUser.layer setCornerRadius:32.0f];
    [self.imgUser setClipsToBounds:YES];
    
    [self.lbltitle setFont:[Utilities fontOpensSansBoldWithSize:11]];
    
    [self.navigationItem setHidesBackButton:YES];
    [self createNavButtons];
}

- (void)createNavButtons {
    btEdit = [[CustomButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 65, 5, 60, 35)];
    [btEdit setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_normal-1"] forState:UIControlStateNormal];
    [btEdit setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_active-1"] forState:UIControlStateHighlighted];
    [btEdit setFontSize:14];
    [btEdit setTitle:@"Editar" forState:UIControlStateNormal];
    [btEdit addTarget:self action:@selector(didEditButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* buttonEdit = [[UIBarButtonItem alloc] initWithCustomView:btEdit];
    
    btCancel = [[CustomButton alloc] initWithFrame:CGRectMake(0, 5, 60, 35)];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_sair_normal"] forState:UIControlStateNormal];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_sair_active"] forState:UIControlStateHighlighted];
    [btCancel setFontSize:14];
    [btCancel setTitle:@"Sair" forState:UIControlStateNormal];
    [btCancel addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* buttonLogout = [[UIBarButtonItem alloc] initWithCustomView:btCancel];
    
    UIBarButtonItem* leftSpacer = [[UIBarButtonItem alloc] init];
    leftSpacer.width = -5;
    
    UIBarButtonItem* rightSpacer = [[UIBarButtonItem alloc] init];
    rightSpacer.width = -5;
    
    self.navigationItem.leftBarButtonItems = @[leftSpacer, buttonLogout];
    self.navigationItem.rightBarButtonItems = @[rightSpacer, buttonEdit];
}

- (void)callLoginView {
    
    MainViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
    loginVC.isFromPerfil = YES;
    loginVC.perfilVC = self;
    loginVC.exploreVC = self.exploreVC;
    navLogin = [[UINavigationController alloc]initWithRootViewController:loginVC];
    
    if ([Utilities isIpad]) {
        [navLogin setModalPresentationStyle:UIModalPresentationFormSheet];
        navLogin.view.superview.bounds = CGRectMake(-25, 0, 470, 620);
        [navLogin.view.superview setBackgroundColor:[UIColor clearColor]];
        
    }
    [self presentViewController:navLogin animated:NO completion:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    //[btCancel removeFromSuperview];
    //[btEdit removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Minha Conta";
    
    tokenStr = [UserDefaults getToken];
    
    if (tokenStr.length == 0) {
        [self callLoginView];
    }
    
    [self.spin setCenter:self.table.center];
    [self.table scrollRectToVisible:CGRectMake(1, 1, 1, 1) animated:NO];
    
    [self getData];
}

- (void)getData {
    
    [self.table setHidden:YES];
    [self.spin startAnimating];
    
    tokenStr = [UserDefaults getToken];
    
    if (tokenStr.length > 0) {
        page = 0;
        [self getUserDetails];
        [self getPosts];
    }
}


#pragma mark - Get Details

- (void)getUserDetails {
    
    if ([Utilities isInternetActive]) {
        
        ServerOperations *serverOp = [[ServerOperations alloc]init];
        [serverOp setTarget:self];
        [serverOp setAction:@selector(didReceiveData:)];
        [serverOp setActionErro:@selector(didReceiveError:)];
        [serverOp getDetails];
    }
}

- (void)didReceiveData:(NSData*)data {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    [self setValuesWithDict:[dict valueForKey:@"user"]];
    
    self.dictUser = [[NSDictionary alloc]initWithDictionary:[dict valueForKey:@"user"]];
    [self.table reloadData];
    
}


- (void)didReceiveError:(NSError*)error {
    [Utilities alertWithServerError];
}

#pragma mark - Get Posts

- (void)getPosts {
    
    if (isLoading) {
        return;
    }
    
    if ([Utilities isInternetActive]) {
        page ++;
        isLoading = YES;
        
        [self.spin startAnimating];
        ServerOperations *serverOp = [[ServerOperations alloc]init];
        [serverOp setTarget:self];
        [serverOp setAction:@selector(didReceivePostsData:)];
        [serverOp setActionErro:@selector(didReceivePostsError:)];
        [serverOp getUserPostsWithPage:page];
    }
}

- (void)didReceivePostsData:(NSData*)data {
    isLoading = NO;
    [self.table setHidden:NO];
    [self.spin stopAnimating];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    if ([Utilities isIpad]) {
        [self.table setContentInset:UIEdgeInsetsMake(50, 0, 0, 0)];
    } else {
        [self.table setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    [UIView commitAnimations];
    
    if (page == 1) {
#warning Faltando numero de paginas
        pageCountMax = [[dict valueForKey:@"pageCount"]intValue];
        
        self.arrMain = [[NSMutableArray alloc]initWithArray:[dict valueForKey:@"reports"]];
        
        CGRect spinFrame = self.spin.frame;
        
        spinFrame.origin.y = self.table.frame.size.height + self.table.frame.origin.y - 34;
        
        //        if ([Utilities isIphone4inch]) {
        //            spinFrame.origin.y = 474;
        //        } else {
        //            spinFrame.origin.y = 346;
        //        }
        
        [self.spin setFrame:spinFrame];
        
    } else {
        for (NSDictionary *newDict in [dict valueForKey:@"reports"]) {
            NSNumber* rid = [newDict valueForKey:@"id"];
            
            BOOL contains = NO;
            for(NSDictionary* rdict in self.arrMain)
            {
                NSNumber* rrid = [rdict valueForKey:@"id"];
                
                if([rid intValue] == [rrid intValue])
                {
                    contains = YES;
                    break;
                }
            }
            
            if(!contains)
                [self.arrMain addObject:newDict];
        }
    }
    
    totalCountSolicits = [[dict valueForKey:@"total_reports_by_user"]intValue];
    
    if (totalCountSolicits == 1) {
        [self.lblSoliciations setText:@"1 SOLICITAÇÃO"];
    } else {
        [self.lblSoliciations setText:[NSString stringWithFormat:@"%i SOLICITAÇÕES", totalCountSolicits]];
    }
    
    [self.table reloadData];
    [self.table setHidden:NO];
    
}

- (void)didReceivePostsError:(NSError*)error {
    [Utilities alertWithServerError];
    [self.spin stopAnimating];
    isLoading = NO;
    page --;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float position = scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height;
    
    
#warning sem pageCountMax
    if (position < - 60 && !isLoading) {
        //    if (position < - 60 && !isLoading && page < pageCountMax) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        if ([Utilities isIpad]) {
            [self.table setContentInset:UIEdgeInsetsMake(50, 0, 48, 0)];
        } else {
            [self.table setContentInset:UIEdgeInsetsMake(0, 0, 48, 0)];
        }
        [UIView commitAnimations];
        
        [self getPosts];
    }
    
}

- (void)logout {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[UIApplication displayName] message:@"Tem certeza de que deseja sair de sua conta?" delegate:self cancelButtonTitle:@"Não" otherButtonTitles:@"Sim", nil];
    [alert show];
    
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushToMainView" object:nil];
        [UserDefaults setToken:@""];
        [UserDefaults setUserId:@""];
        [UserDefaults setIsUserLogged:NO];
        [UserDefaults setIsUserLoggedOnSocialNetwork:kSocialNetworkAnyone];
    }
}

- (void)didEditButton {
    
    
    EditViewController *editVC = [[EditViewController alloc]initWithNibName:@"EditViewController" bundle:nil];
    editVC.dictUser = self.dictUser;
    editVC.perfilView = self;
    if ([Utilities isIpad]) {
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:editVC];
        [nav setModalPresentationStyle:UIModalPresentationFormSheet];
        [self presentViewController:nav animated:YES completion:nil];
        
        if ([Utilities isIpad]) {
            nav.view.superview.bounds = CGRectMake(-25, 0, 470, 620);
            [nav.view.superview setBackgroundColor:[UIColor clearColor]];
        }
        
    } else {
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

- (void)setValuesWithDict:(NSDictionary*)dict {
    
    [self.lblName setText:[Utilities checkIfNull:[dict valueForKey:@"name"]]];
    [self.imgUser setImageWithURL:[NSURL URLWithString:@"http://ideas.scup.com/pt/files/2012/10/user.jpg"]];
}

#pragma mark - Table View Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && ![Utilities isIpad]) {
        return 109;
    }
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dictUser && ![Utilities isIpad]) {
        return self.arrMain.count + 1;
    }
    
    return self.arrMain.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0 && ![Utilities isIpad]) {
        
        static NSString *cellIdentifier = @"CellHeader";
        
        HeaderProfileCell *cell = (HeaderProfileCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        
        [cell setValues:self.dictUser count:totalCountSolicits];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    
    static NSString *cellIdentifier = @"Cell";
    
    CellMinhaConta *cell = (CellMinhaConta *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[CellMinhaConta alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if ([Utilities isIpad]) {
        [cell setvalues:[self.arrMain objectAtIndex:indexPath.row]];
    } else {
        [cell setvalues:[self.arrMain objectAtIndex:indexPath.row-1]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 && ![Utilities isIpad]) {
        return;
    }
    
    NSString *nibName = nil;
    if ([Utilities isIpad]) {
        nibName = @"PerfilDetailViewController_iPad";
    } else {
        nibName = @"PerfilDetailViewController";
    }
    PerfilDetailViewController *perfilDetailVC = [[PerfilDetailViewController alloc]initWithNibName:nibName bundle:nil];
    perfilDetailVC.isFromPerfil = YES;
    perfilDetailVC.thatStoryboard = self.storyboard;
    
    if ([Utilities isIpad]) {
        perfilDetailVC.dictMain = [self.arrMain objectAtIndex:indexPath.row];
    } else {
        perfilDetailVC.dictMain = [self.arrMain objectAtIndex:indexPath.row-1];
    }
    [self.navigationController pushViewController:perfilDetailVC animated:YES];
    
}

- (void)setIsFromOtherTab:(BOOL)isFromOtherTab
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
