//
//  TermosViewController.m
//  Zup
//

#import "TermosViewController.h"

@interface TermosViewController ()

@end

@implementation TermosViewController

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
    
    self.title = @"Termos de uso";
    
    CustomButton *btDone = [[CustomButton alloc] initWithFrame:CGRectMake(self.navigationController.view.bounds.size.width - 65, 5, 60, 35)];
    [btDone setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_normal-1"] forState:UIControlStateNormal];
    [btDone setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_active-1"] forState:UIControlStateHighlighted];
    [btDone setFontSize:14];
    [btDone setTitle:@"OK" forState:UIControlStateNormal];
    [btDone addTarget:self action:@selector(btDone) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:btDone];
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"termo-de-uso" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"Termos de uso";
}

- (void)btDone {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
