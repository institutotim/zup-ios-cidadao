//
//  ForgotViewController.m
//  Zup
//

#import "ForgotViewController.h"

@interface ForgotViewController ()

@end

@implementation ForgotViewController

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
    
    
    CustomButton *btCancel = [[CustomButton alloc] initWithFrame:CGRectMake(5, 5, 74, 35)];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_sair_normal"] forState:UIControlStateNormal];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_sair_active"] forState:UIControlStateHighlighted];
    [btCancel setFontSize:14];
    [btCancel setTitle:@"Cancelar" forState:UIControlStateNormal];
    [btCancel addTarget:self action:@selector(didCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:btCancel];
    
    //CustomButton *btCreate = [[CustomButton alloc] initWithFrame:CGRectMake(self.navigationController.view.superview.bounds.size.width - 65, 5, 60, 35)];
    CustomButton *btCreate = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, 60, 35)];
    [btCreate setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_normal-1"] forState:UIControlStateNormal];
    [btCreate setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_active-1"] forState:UIControlStateHighlighted];
    [btCreate setFontSize:14];
    
    [btCreate setTitle:@"Enviar" forState:UIControlStateNormal];
    [btCreate addTarget:self action:@selector(didSendButton) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.navigationBar addSubview:btCreate];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:btCreate];
    [item setImageInsets:UIEdgeInsetsMake(0, 0, 100, 0)];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                             target:nil
                             action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, item];

    NSString *titleStr = @"Esqueceu a senha?";
   
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    [lblTitle setFont:[Utilities fontOpensSansLightWithSize:18]];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setText:titleStr];
    [self.navigationController.navigationBar.topItem setTitleView:lblTitle];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.tfemail.frame.size.height)];
    leftView.backgroundColor = [UIColor clearColor];
    self.tfemail.leftView = leftView;
    self.tfemail.leftViewMode = UITextFieldViewModeAlways;
    
    [self.tfemail becomeFirstResponder];
    
    self.label.font = [Utilities fontOpensSansLightWithSize:15];

}

- (void)didSendButton {
    
    if (![Utilities isValidEmail:self.tfemail.text]) {
        //[Utilities alertWithError:@"Insira um e-mail válido!"];
        return;
    }
    
    ServerOperations *serverOP = [[ServerOperations alloc]init];
    [serverOP setTarget:self];
    [serverOP setAction:@selector(didReceiveSendResponse:)];
    [serverOP setActionErro:@selector(didReceiveError:)];
    [serverOP recoveryPass:self.tfemail.text];
}

- (void)didReceiveSendResponse:(NSData*)data {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
    if ([dict valueForKey:@"message"]) {
        [Utilities alertWithMessage:[dict valueForKey:@"message"]];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [Utilities alertWithServerError];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.screenName = @"Esqueci minha senha";
}

- (void)didReceiveError:(NSError*)error {
    [Utilities alertWithServerError];
}

- (void)didCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
