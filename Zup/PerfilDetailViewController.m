//
//  PerfilDetailViewController.m
//  Zup
//

int EMABERTO = 0;
int EMANDAMENTO = 1;
int NAORESOLVIDO = 2;
int RESOLVIDO = 3;

#import "PerfilDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomMap.h"
#import "MainViewController.h"
#import "LoginViewController.h"

#import "ComentarioViewController.h"

#import <ISO8601DateFormatter/ISO8601DateFormatter.h>

@interface PerfilDetailViewController ()

@end

@implementation PerfilDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)getDetails {
    
    if ([Utilities isInternetActive]) {
        ServerOperations *serverOp = [[ServerOperations alloc]init];
        [serverOp setTarget:self];
        [serverOp setAction:@selector(didReceiveData:)];
        [serverOp setActionErro:@selector(didReceiveError:data:)];
        [serverOp getReportDetailsWithId:[[self.dictMain valueForKey:@"id"] intValue]];
    }
}

- (void)didReceiveData:(NSData*)data {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    [self buildStatusWithColor:[dict valueForKeyPath:@"report.status.color"] title:[dict valueForKeyPath:@"report.status.title"]];
    
    NSString *timeSentence = [Utilities calculateNumberOfDaysPassed:[dict valueForKeyPath:@"report.updated_at"]];
    [self.lblSubtitle setText:timeSentence];
}

- (void)didReceiveError:(NSError*)error data:(NSData*)data {
    [Utilities alertWithServerError];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.spin setHidesWhenStopped:YES];
    [self.pageControl setHidden:YES];
    [self.pageControl setHidesForSinglePage:YES];

    [self.lblTitle setFont:[Utilities fontOpensSansBoldWithSize:11]];
    
    [self.lblCategoria setFont:[Utilities fontOpensSansWithSize:11]];
    
    [self.lblName setFont:[Utilities fontOpensSansLightWithSize:16]];
    [self.lblName setMinimumScaleFactor:0.5];
    
    [self.lblSubtitle setFont:[Utilities fontOpensSansBoldWithSize:10]];
    
    
    UIImage* image = [UIImage imageNamed:@"report_flag"];
    if([image respondsToSelector:@selector(imageWithRenderingMode:)])
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(flagReport)];
    
    self.navigationItem.rightBarButtonItem = item;
    
    NSMutableString* address = [[NSMutableString alloc] init];
    [address appendString:[self.dictMain valueForKey:@"address"]];
    
    NSString* number = [self.dictMain valueForKey:@"number"];
    NSString* subLocality = [self.dictMain valueForKey:@"district"];
    NSString* postalCode = [self.dictMain valueForKey:@"postal_code"];
    NSString* city = [self.dictMain valueForKey:@"city"];
    NSString* state = [self.dictMain valueForKey:@"state"];
    
    if(number && ![number isKindOfClass:[NSNull class]])
    {
        [address appendString:@", "];
        [address appendString:number];
    }
    
    if(postalCode && ![postalCode isKindOfClass:[NSNull class]])
    {
        [address appendString:@", "];
        [address appendString:postalCode];
    }
    
    if(subLocality && ![subLocality isKindOfClass:[NSNull class]])
    {
        [address appendString:@", "];
        [address appendString:subLocality];
    }
     
    /*if(city && ![city isKindOfClass:[NSNull class]])
    {
        [address appendString:@", "];
        [address appendString:city];
     
        if(state && ![state isKindOfClass:[NSNull class]])
        {
            [address appendString:@" - "];
            [address appendString:state];
        }
    }*/
    
    [self.lblAddress setText:address];
    [self.lblAddress setFont:[Utilities fontOpensSansLightWithSize:11]];
    
    [self.lblDesc setText:[Utilities checkIfNull:[self.dictMain valueForKey:@"reference"]]];
    [self.lblDesc setFont:[Utilities fontOpensSansLightWithSize:11]];
    
    [self.lblAddress setMinimumScaleFactor:0.5];
    
    if (self.lblAddress.text.length == 0 && ![Utilities isIpad]) {
        
        CGRect frame = self.lblName.frame;
        //frame.size.height += 15;
        //[self.lblName setFrame:frame];
    
    }
    
    if([Utilities isIpad])
    {
        CGRect frm = self.lblName.frame;
        frm.origin.y -= 15;
        
        //self.lblName.frame = frm;
    }
    
    [self getDetails];
        
    NSDictionary *catDict;
    if ([self.dictMain valueForKeyPath:@"category.id"]) {
        catDict = [UserDefaults getCategory:[[self.dictMain valueForKeyPath:@"category.id"]integerValue]];
    } else if ([self.dictMain valueForKeyPath:@"category_id"]) {
        catDict = [UserDefaults getCategory:[[self.dictMain valueForKeyPath:@"category_id"]integerValue]];
    } else if ([self.dictMain valueForKeyPath:@"inventory_category_id"]) {
        catDict = [UserDefaults getInventoryCategory:[[self.dictMain valueForKeyPath:@"inventory_category_id"]integerValue]];
    }
    
    if([catDict valueForKey:@"parent_id"] != nil) // Categoria possui pai
    {
        NSNumber* parentcatid = [catDict valueForKey:@"parent_id"];
        NSDictionary* parentcatdict = [UserDefaults getCategory:[parentcatid intValue]];
        
        if([Utilities isIpad]) // No iPad, as posições são trocadas
        {
            if ([parentcatdict valueForKey:@"title"]) {
                [self.lblCategoria setText:[Utilities checkIfNull:[parentcatdict valueForKey:@"title"]]];
            }
            if ([catDict valueForKey:@"title"]) {
                [self.lblName setText:[Utilities checkIfNull:[catDict valueForKey:@"title"]]];
            }
        }
        else
        {
            if ([parentcatdict valueForKey:@"title"]) {
                [self.lblName setText:[Utilities checkIfNull:[parentcatdict valueForKey:@"title"]]];
            }
            if ([catDict valueForKey:@"title"]) {
                [self.lblCategoria setText:[Utilities checkIfNull:[catDict valueForKey:@"title"]]];
            }
        }
        
        self.lblCategoria.hidden = NO;
    }
    else
    {
        if ([catDict valueForKey:@"title"]) {
            [self.lblName setText:[catDict valueForKey:@"title"]];
        }
        
        if(![Utilities isIpad])
        {
            CGRect tframe = self.lblName.frame;
            tframe.origin.y += 4;
            tframe.size.height += 15;
            self.lblName.frame = tframe;
        }
        
        self.lblCategoria.hidden = YES;
    }
    
    UIImage* icon = [UIImage imageWithData:[catDict valueForKey:@"iconDataDisabled"]];
    self.imgIcon.image = icon;
    
    if ([self.dictMain valueForKey:@"updated_at"]) {
        NSString *timeSentence = [Utilities calculateNumberOfDaysPassed:[self.dictMain valueForKey:@"updated_at"]];
        [self.lblSubtitle setText:timeSentence];
    }

    
    [self.lblTitle setText:[NSString stringWithFormat:@"PROTOCOLO %@", [self.dictMain valueForKey:@"protocol"]]];
    [self.tvDesc setFont:[Utilities fontOpensSansWithSize:12]];
    [self.tvDesc setText:[Utilities checkIfNull:[self.dictMain valueForKey:@"description"]]];
    [self.tvDesc sizeToFit];
    
    [self buildStatusWithColor:[self.dictMain valueForKeyPath:@"status.color"] title:[self.dictMain valueForKeyPath:@"status.title"]];
    
    
    [self.navigationItem setHidesBackButton:YES];
    
    [self buildScroll];
    
    // Só exibe o protocolo se for o criador do relato
    if([self.dictMain valueForKeyPath:@"user.id"] == nil || [[self.dictMain valueForKeyPath:@"user.id"] isKindOfClass:[NSNull class]] || [[self.dictMain valueForKeyPath:@"user.id"] intValue] != [[UserDefaults getUserId] intValue])
    {
        [self.lblTitle setHidden:YES];
    }
    
    [self.indicatorComentarios startAnimating];
    [self loadComments];
    [self createNavButtons];
}

- (void)createNavButtons
{
    btCancel = [[CustomButton alloc] initWithFrame:CGRectMake(0, 5, 56, 35)];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_cancelar_normal-1"] forState:UIControlStateNormal];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_cancelar_active-1"] forState:UIControlStateHighlighted];
    [btCancel setFontSize:14];
    [btCancel setTitle:@"Voltar" forState:UIControlStateNormal];
    [btCancel addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithCustomView:btCancel];
    self.navigationItem.leftBarButtonItems = @[[Utilities createSpacer], button];
}

- (void)callLoginView {
    UIStoryboard* storyboard = self.thatStoryboard;
    
    MainViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
    loginVC.isFromReport = YES;
    UINavigationController* navLogin = [[UINavigationController alloc]initWithRootViewController:loginVC];
    
    if ([Utilities isIpad]) {
        [navLogin setModalPresentationStyle:UIModalPresentationFormSheet];
        navLogin.view.superview.bounds = CGRectMake(-25, 0, 470, 620);
        [navLogin.view.superview setBackgroundColor:[UIColor clearColor]];
        
    }
    [self presentViewController:navLogin animated:YES completion:nil];
}

- (void)loadComments
{
    [self.indicatorComentarios startAnimating];
    
    ServerOperations *serverOp = [[ServerOperations alloc]init];
    [serverOp setTarget:self];
    [serverOp setAction:@selector(didReceiveComments:)];
    [serverOp setActionErro:@selector(didReceiveCommentsError:data:)];
    [serverOp getReportComments:[[self.dictMain valueForKeyPath:@"id"] intValue]];
}

- (void)didReceiveCommentsError:(NSError*)error data:(NSData*)data
{
    [self.indicatorComentarios stopAnimating];
}

- (void)didReceiveComments:(NSData*)data
{
    [self.indicatorComentarios stopAnimating];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    int toth;
    if(![Utilities isIpad])
        toth = self.tvDesc.frame.origin.y + self.tvDesc.frame.size.height;
    else
        toth = 0;
    
    int y = 0;

    NSArray* comments = [[dict valueForKey:@"comments"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        
        NSDateFormatter *form = [[NSDateFormatter alloc]init];
        [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString* strDate = [obj1 valueForKey:@"created_at"];
        strDate = [strDate substringToIndex:19];
        strDate = [strDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        
        NSDate *date1 = [form dateFromString:strDate];
        
        strDate = [obj2 valueForKey:@"created_at"];
        strDate = [strDate substringToIndex:19];
        strDate = [strDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        
        NSDate *date2 = [form dateFromString:strDate];
        
        return [date2 compare:date1];

    }];
    
    for(NSDictionary* comment in comments)
    {
        int visibility = [[comment valueForKey:@"visibility"] intValue];
        BOOL mine = [[self.dictMain valueForKeyPath:@"user.id"] intValue] == [[UserDefaults getUserId] intValue]; // Esse relato é meu?
        
        if (visibility == 1 && (!mine || !self.isFromPerfil)) // Privado: só mostra se for meu e se for do perfil
        {
            continue;
        }
        else if(visibility == 2) // Interno
        {
            continue;
        }
        
        BOOL last = comment == [comments objectAtIndex:comments.count-1];
        UIView* view = [self createViewForComment:comment last:last];
        
        view.frame = CGRectMake(0, y, self.view.frame.size.width, view.frame.size.height);
        
        [self.containerComentarios addSubview:view];
        
        y += view.frame.size.height;
        toth += view.frame.size.height;
    }
    
    CGRect frame = self.containerComentarios.frame;
    frame.size.height = y;
    
    self.containerComentarios.frame = frame;
    [self.scroll setContentSize:CGSizeMake(self.view.frame.size.width, toth)];
}

- (UIView*) createViewForComment:(NSDictionary*)comment last:(BOOL)last
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    view.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    
    UILabel* lblMsg = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, self.view.frame.size.width - 60, 18)];
    
    lblMsg.text = [comment valueForKey:@"message"];
    lblMsg.numberOfLines = 0;
    lblMsg.font = [Utilities fontOpensSansWithSize:13];
    lblMsg.textColor = [UIColor colorWithWhite:.3 alpha:1];
    [lblMsg sizeToFit];
    
    [view addSubview:lblMsg];
    
    UILabel* lblDate = [[UILabel alloc] initWithFrame:CGRectMake(30, lblMsg.frame.origin.y + lblMsg.frame.size.height + 10, self.view.frame.size.width - 60, 18)];
    
    NSString* strDate = [comment valueForKey:@"created_at"];

    ISO8601DateFormatter *form = [[ISO8601DateFormatter alloc] init];
    //[form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //strDate = [strDate substringToIndex:19];
    //strDate = [strDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSDate *date = [form dateFromString:strDate];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    NSString* datestr = [formatter stringFromDate:date];
    
    //NSString* sentby = [NSString stringWithFormat:@"Enviado por %@\r%@", [Utilities getTenantName], datestr];
    NSString* sentby = [NSString stringWithFormat:@"Resposta do Município enviada: %@", datestr];
    
    lblDate.text = sentby;
    lblDate.numberOfLines = 0;
    lblDate.font = [Utilities fontOpensSansWithSize:11];
    lblDate.textColor = [UIColor colorWithWhite:.5 alpha:1];
    [lblDate sizeToFit];
    
    [view addSubview:lblDate];
    
    if(!last)
    {
        UIView* divider = [[UIView alloc] initWithFrame:CGRectMake(20, lblDate.frame.origin.y + lblDate.frame.size.height + 19, view.frame.size.width - 20, 1)];
        divider.backgroundColor = [UIColor colorWithWhite:.8 alpha:1];
    
        [view addSubview:divider];
    }
    
    int height = lblDate.frame.size.height + lblDate.frame.origin.y + 20;
    
    CGRect frame = view.frame;
    frame.size.height = height;
    
    view.frame = frame;
    
    return view;
}

- (void)buildStatusWithColor:(NSString*)colorStr title:(NSString*)title {
    if(!colorStr || [colorStr isKindOfClass:[NSNull class]])
        colorStr = @"#ffffff";
    
    if(!title || [title isKindOfClass:[NSNull class]])
        title = @"";
    
    colorStr = [colorStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    UIColor *color = [Utilities colorWithHexString:colorStr];
    [self.lblStatus setText:title];
    [self.lblStatus setBackgroundColor:color];
    [self.lblStatus.layer setCornerRadius:10];
    [self.lblStatus setClipsToBounds:YES];
    self.lblStatus.text = self.lblStatus.text.uppercaseString;
    [self.lblStatus setFont:[Utilities fontOpensSansExtraBoldWithSize:11]];

    float currentW = self.lblStatus.frame.size.width;
    float width = [Utilities expectedWidthWithLabel:self.lblStatus];
    CGRect frame = self.lblStatus.frame;
    frame.size.width = width + 20;
    //frame.origin.x += currentW - width - 20;
    
    [self.lblStatus setFrame:frame];

}

- (void)buildMap {
    
    NSString *latStr = [self.dictMain valueForKeyPath:@"position.latitude"];
    
    NSString *lngStr = [self.dictMain valueForKeyPath:@"position.longitude"];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latStr.floatValue, lngStr.floatValue);
    
    CGRect rect = self.scrollImages.frame;
    
    if(![Utilities isIpad])
    {
        rect.size.width = self.view.frame.size.width;
        rect.size.height = self.view.frame.size.width;
    }
    
    CustomMap *map = [[CustomMap alloc]init];
    [map setFrame:rect];
    map.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    
    if ([Utilities isIpad]) {
        [self.view addSubview:map];
    } else {
        [self.scroll addSubview:map];
    }
    
    NSString *catStr = nil;
    BOOL isReport = YES;

    if ([self.dictMain valueForKeyPath:@"category.id"]) {
        catStr = [self.dictMain valueForKeyPath:@"category.id"];
    } else if ([self.dictMain valueForKey:@"category_id"]) {
        catStr = [self.dictMain valueForKey:@"category_id"];
    }
    
   
    [map setPositionWithLocation:coord andCategory:[catStr integerValue] isReport:isReport];
    [map setUserInteractionEnabled:NO];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Detalhes de um Relato";
    
    if(btCancel != nil)
        return;
    
    UINavigationController* controller = self.navigationController;
    if(!controller)
        controller = self.navCtrl;
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.exploreVC viewWillAppear:YES];
    //[btCancel removeFromSuperview];
    //btCancel = nil;
    
//    [self.navigationController popViewControllerAnimated:YES];

}

- (void) flagReport {
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Deseja reportar esse relato como conteúdo ofensivo ou inapropriado?" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:@"Reportar" otherButtonTitles:nil];
    [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.destructiveButtonIndex)
    {
        [self confirmFlagReport];
    }
}

- (void)confirmFlagReport {
    if(![UserDefaults isUserLogged])
    {
        [self callLoginView];
        return;
    }
    
    UIAlertView* myAlertView = [[UIAlertView alloc] initWithTitle:@"" message:nil
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 100)];
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loading.color = [UIColor grayColor];
    loading.frame=CGRectMake((myAlertView.frame.size.width - 64) / 2, 0, 64, 64);
    loading.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [view addSubview:loading];
    [myAlertView setValue:view forKey:@"accessoryView"];
    [myAlertView show];
    
    [loading startAnimating];
    
    self.reportLoading = myAlertView;
    
    ServerOperations* operations = [[ServerOperations alloc] init];
    operations.target = self;
    operations.action = @selector(didReceiveOffensive:);
    operations.actionErro = @selector(didReceiveOffensiveError:operation:data:);
    [operations flagReportAsOffensive:[self.dictMain[@"id"] intValue]];
}

- (void) didReceiveOffensive:(NSData*)data
{
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSString* message = dict[@"message"];
    [self.reportLoading dismissWithClickedButtonIndex:-1 animated:YES];
    
    [self popView];
    
    UIAlertView* alerView = [[UIAlertView alloc] initWithTitle:@"Reportar Relato" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alerView show];
}

- (void) didReceiveOffensiveError:(NSError*)error operation:(TIRequestOperation*)operation data:(NSData*)data
{
    if(data == nil)
        [Utilities alertWithServerError];
    else
    {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSString* message = dict[@"error"];
        [self.reportLoading dismissWithClickedButtonIndex:-1 animated:YES];
        
        [Utilities alertWithError:message];
    }
}

- (void)buildScroll {
    
    NSArray *arrImages = [self.dictMain valueForKey:@"images"];
    
    if (arrImages.count == 0) {
        [self buildMap];
    } else {
        [self.spin startAnimating];
    }
    
    int i = 0;
    float sideSize = 320;
    
    for (NSDictionary *dict in arrImages) {
        UIImageView *imgV = [[UIImageView alloc]init];
        NSURL *urlImage = [NSURL URLWithString:[dict valueForKeyPath:@"high"] relativeToURL:[NSURL URLWithString:[ServerOperations baseAPIUrl]]];
        
        [imgV setImageWithURL:urlImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {

            if (i == arrImages.count-1
                ) {
                [self.spin stopAnimating];
                [self.pageControl setHidden:NO];
            }
            
        }];
        
        [imgV setFrame:CGRectMake(sideSize * i, 0, sideSize, sideSize)];
        [self.scrollImages addSubview:imgV];
        
        
        i ++;
    }
    
    
    
    [self.scrollImages setContentSize:CGSizeMake(sideSize * i, sideSize)];
    [self.pageControl setNumberOfPages:i];

    CGRect frame;
    
    if ([Utilities isIpad]) {
        frame = CGRectMake(54, 98, 240, 20);
       
    } else {
        frame = CGRectMake(10, self.scrollImages.frame.size.height + self.scrollImages.frame.origin.y + 10, 300, 20);
    }

    if (self.isFromFeed) {
        
        [self.tvDesc removeFromSuperview];
        
        UILabel *currentLabel;
        for (NSDictionary *dict in [self.dictMain valueForKey:@"values"]) {
            NSString *strTitle = [dict valueForKey:@"title"];
            strTitle = [strTitle uppercaseString];
            NSString *strDesc = [dict valueForKey:@"desc"];
            
            UILabel *lbl = [[UILabel alloc]init];
            [lbl setText:strTitle];
            [lbl setFrame:frame];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setFont:[Utilities fontOpensSansBoldWithSize:12]];
            [lbl setTextColor:[UIColor blackColor]];
            if ([Utilities isIpad]) {
                [self.view addSubview:lbl];
            } else {
                [self.scroll addSubview:lbl];
            }
            
            frame.origin.y += 18;
            
            
            UILabel *lbl2 = [[UILabel alloc]init];
            [lbl2 setText:strDesc];
            [lbl2 setFrame:frame];
            [lbl2 setFont:[Utilities fontOpensSansWithSize:12]];
            [lbl2 setBackgroundColor:[UIColor clearColor]];
            [lbl2 setTextColor:[Utilities colorGray]];
            
            if ([Utilities isIpad]) {
                [self.view addSubview:lbl2];
            } else {
                [self.scroll addSubview:lbl2];
            }
            
            frame.origin.y += 25;
            
            currentLabel = lbl2;
        }
        
        
        if (![Utilities isIpad]) {
            [self.scroll setContentSize:CGSizeMake(320, currentLabel.frame.origin.y + currentLabel.frame.size.height + 10)];

          

            [self.scroll setContentInset:UIEdgeInsetsMake(-64, 0, 0, 0)];
            
            [self.lblName removeFromSuperview];
            [self.lblSubtitle removeFromSuperview];
            

        }
        
      
    } else {
        [self.scroll setContentSize:CGSizeMake(320, self.tvDesc.frame.origin.y + self.tvDesc.frame.size.height + 10)];
        
        if ([self.dictMain valueForKey:@"texto"] && [[self.dictMain valueForKey:@"texto"]length] > 0) {
            CGSize size = [Utilities sizeOfText:self.tvDesc.text widthOfTextView:self.tvDesc.frame.size.width withFont:self.tvDesc.font];
            CGRect frameDesc = self.tvDesc.frame;
            
            if (arrImages.count == 0) {
                frameDesc.origin.y = 59;
                [self.scrollImages setHidden:YES];
                [self.pageControl setHidden:YES];
            }
            
            size.height += 30;
            frameDesc.size = size;
            
            if ([Utilities isIpad]) {
                frameDesc.origin.x -= 16;
            }
            [self.tvDesc setFrame:frameDesc];
            
            
        }
    }

 

    if (![Utilities isIpad]) {
        CGRect frame = self.containerComentarios.frame;
        frame.origin.y = self.tvDesc.frame.origin.y + self.tvDesc.frame.size.height;
        self.containerComentarios.frame = frame;
        
        [self.scroll setContentSize:CGSizeMake(self.view.frame.size.width, frame.origin.y + frame.size.height)];
    } else {
        CGRect frame = self.viewBg.frame;
        frame.size.height = self.tvDesc.frame.size.height + 63;
        [self.viewBg setFrame:frame];
        
        CGRect frameLbl = self.lblSubtitle.frame;
        frameLbl.origin.x -=16;
        [self.lblSubtitle setFrame:frameLbl];

    }
   
    
    [self.pageControl setHidesForSinglePage:YES];

}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.scrollImages.frame.size.width;
    int page = floor((self.scrollImages.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)popView {
    [self viewWillDisappear:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
