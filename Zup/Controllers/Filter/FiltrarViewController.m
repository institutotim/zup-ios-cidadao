//
//  FiltrarViewController.m
//  Zup
//

#import "FiltrarViewController.h"
#import "ExploreViewController.h"

int currentIdCategory;

@interface FiltrarViewController ()

@end

@implementation FiltrarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setTab:(NSString*)name
{
    BOOL isCategorias = NO;
    BOOL isPeriodoStatus = NO;
    BOOL isInventario = NO;
    
    //UIView* newView = nil;
    
    if ([name isEqualToString:@"categorias"])
    {
        isCategorias = YES;
        //newView = self.viewCategorias;
    }
    else if ([name isEqualToString:@"periodoStatus"])
    {
        isPeriodoStatus = YES;
        //newView = self.viewCategorias;
    }
    else if ([name isEqualToString:@"inventario"])
    {
        isInventario = YES;
        //newView = self.viewCategorias;
    }
    
    [self.btnCategorias setSelected:isCategorias];
    [self.btnPeriodoStatus setSelected:isPeriodoStatus];
    [self.btnInventario setSelected:isInventario];
    
    [self.viewCategorias setHidden:!isCategorias];
    [self.viewPeriodoStatus setHidden:!isPeriodoStatus];
    [self.viewInventario setHidden:!isInventario];
    
    //if(newView != nil)
    //   [newView setHidden:NO];
}

- (IBAction)categorias:(id)sender
{
    [self setTab:@"categorias"];
}

- (IBAction)periodoStatus:(id)sender
{
    [self setTab:@"periodoStatus"];
}

- (IBAction)inventario:(id)sender
{
    [self setTab:@"inventario"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Filtros";
    
    [self setTab:@"categorias"];
    
    self.exploreView.statusToFilterId = 0;
    self.exploreView.dayFilter = 7; //30 * 6;
    
    [self.viewContent addSubview:self.viewCategorias];
    [self.viewContent addSubview:self.viewPeriodoStatus];
    [self.viewContent addSubview:self.viewInventario];
    
    CGRect frame = CGRectMake(0, 0, self.viewContent.frame.size.width, self.viewContent.frame.size.height);
    self.viewCategorias.frame = frame;
    self.viewPeriodoStatus.frame = frame;
    self.viewInventario.frame = frame;

//    [self.btViewStatus setHidden:YES];
//    [self.imgSeta setHidden:YES];
    
    [self changeFont:self.view];
    [self.lblSolicitacoesTitle setFont:[Utilities fontOpensSansBoldWithSize:12]];
    [self.lblPontosTitle setFont:[Utilities fontOpensSansBoldWithSize:12]];
    [self.btViewStatus.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];
    
    [self.btnCategorias.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];
    [self.btnPeriodoStatus.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];
    [self.btnInventario.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];

    for (UIButton *bt in self.arrBtStatus) {
        [bt.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];
    }
    
    
    for (UILabel *lbl in self.arrLabel) {
        [lbl setFont:[Utilities fontOpensSansLightWithSize:10]];
    }

    if (![Utilities isIOS7]) {
        UIImage *clearImage = [[UIImage alloc] init];
        [self.slider setMinimumTrackImage:clearImage forState:UIControlStateNormal];
        [self.slider setMaximumTrackImage:clearImage forState:UIControlStateNormal];
        
        CGRect frame = self.slider.frame;
        frame.origin.y +=4;
        [self.slider setFrame:frame];

    }

    [self.scroll addSubview:self.viewContent];
    
    CGSize size = self.viewContent.frame.size;
    size.height -= self.viewPontos.frame.size.height - 40;
    [self.scroll setContentSize:size];
    
    [self.scroll setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0f]];
    [self.viewPontos setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0f]];

    if ([Utilities isIpad]) {
        [self.viewStatus setBackgroundColor:[Utilities colorGrayLight]];

    } else {
        [self.viewStatus setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0f]];
    }
    
    [self createReportButtons];
    [self createInventoryButtons];

    [self.categoriasViewController setDelegate:self selector:@selector(filterChanged:)];
    [self.inventarioViewController setDelegate:self selector:@selector(filterChanged:)];
    
    self.btFilter = [[CustomButton alloc] initWithFrame:CGRectMake(self.navigationController.view.bounds.size.width - 83, 5, 78, 35)];
    [self.btFilter setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_normal-1"] forState:UIControlStateNormal];
    [self.btFilter setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_active-1"] forState:UIControlStateHighlighted];
    [self.btFilter setFontSize:14];
    [self.btFilter setTitle:@"Concluído" forState:UIControlStateNormal];
    [self.btFilter addTarget:self action:@selector(btConcluido) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithCustomView:self.btFilter];
    UIBarButtonItem* spacer = [[UIBarButtonItem alloc] init];
    spacer.width = -5;
    
    self.navigationItem.rightBarButtonItems = @[spacer, button];
}

- (void)filterChanged:(id)sender
{
    if(sender == self.categoriasViewController && [[self.categoriasViewController categoriesIds] count] > 0)
    {
        [self.inventarioViewController deselectAll];
    }
    else if(sender == self.inventarioViewController && [[self.inventarioViewController categoriesIds] count] > 0)
    {
        [self.categoriasViewController deselectAll];
    }
    
    if([[self.categoriasViewController categoriesIds] count] == 0 && [[self.inventarioViewController categoriesIds] count] == 0)
    {
        self.btFilter.enabled = NO;
    }
    else
    {
        self.btFilter.enabled = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Filtrar (Explore)";
    
    //CustomButton *btFilter = nil;
    
    [self.categoriasViewController viewWillAppear:YES];
    [self.inventarioViewController viewWillAppear:YES];
}


- (void)createInventoryButtons {
    NSArray *arr = [UserDefaults getInventoryCategories];
    self.arrInventoryCategories = [[NSMutableArray alloc]init];
    self.arrBtPontos = [[NSMutableArray alloc]init];

    int i = 0;
    int weight = 90;
    for (NSDictionary *dict in arr) {
        
        UIView *viewButton = [[UIView alloc]initWithFrame:CGRectMake(weight * i, 0 +20, weight, 120)];
        
        UIImage *imgIcon = [UIImage imageWithData:[dict valueForKey:@"iconData"]];
        
        UIImage *imgUnselected = [UIImage imageWithData:[dict valueForKey:@"iconDataDisabled"]];
        
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setImage:imgUnselected forState:UIControlStateNormal];
        [bt setImage:imgIcon forState:UIControlStateSelected];
        [bt setTag:[[dict valueForKey:@"id"]intValue]];
        [bt setFrame:CGRectMake(10, 0, 70, 70)];
        [bt addTarget:self action:@selector(btPontos:) forControlEvents:UIControlEventTouchUpInside];
        [bt setTag:[[dict valueForKey:@"id"]intValue]];
        [bt setBackgroundColor:[UIColor clearColor]];
        bt.alpha = .65;
        [bt setSelected:NO];
        [viewButton addSubview:bt];
        [self.arrBtPontos addObject:bt];
        
        [self.arrInventoryCategories addObject:bt];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 70, 45)];
        [lbl setText:[dict valueForKey:@"title"]];
        [lbl setNumberOfLines:2];
        [lbl setFont:[Utilities fontOpensSansLightWithSize:10]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [viewButton addSubview:lbl];
        
        [self.scrollInventoryCategories addSubview:viewButton];
        
        i ++;
    }
    
    [self.scrollInventoryCategories setContentSize:CGSizeMake(weight * arr.count, self.scrollInventoryCategories.frame.size.height)];
    
    
    if (self.scrollInventoryCategories.contentSize.width < self.view.frame.size.width) {
        
        [self.scrollInventoryCategories setFrame:CGRectMake(self.scrollInventoryCategories.frame.origin.x, self.scrollInventoryCategories.frame.origin.y, self.scrollInventoryCategories.contentSize.width, self.scrollInventoryCategories.frame.size.height)];
        
        CGRect frame = self.scrollInventoryCategories.frame;
     
        frame.origin.x = self.view.center.x - (weight * arr.count /2);
        
        [self.scrollInventoryCategories setFrame:frame];
        
        if ([Utilities isIpad]) {
            [self.scrollInventoryCategories setCenter:CGPointMake(self.view.center.x + 150, self.scrollInventoryCategories.center.y)];
        } else {
            [self.scrollInventoryCategories setCenter:CGPointMake(self.view.center.x + 150, self.scrollInventoryCategories.center.y)];
        }
    }
}

- (void)createReportButtons {

    NSArray *arr2 = [UserDefaults getReportCategories];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:arr2];

    
    self.arrReportCategorias = [[NSMutableArray alloc]init];
    self.arrButtonStatuses = [[NSMutableArray alloc]init];
    
    int i = 0;
    int weight = 90;
    for (NSDictionary *dict in arr) {
        
        UIView *viewButton = [[UIView alloc]initWithFrame:CGRectMake(weight * i, 0 +20, weight, 120)];
        
        UIImage *imgIcon = [UIImage imageWithData:[dict valueForKey:@"iconData"]];
        UIImage *imgUnselected = [UIImage imageWithData:[dict valueForKey:@"iconDataDisabled"]];

        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setImage:imgUnselected forState:UIControlStateNormal];
        [bt setImage:imgIcon forState:UIControlStateSelected];
        [bt setTag:[[dict valueForKey:@"id"]intValue]];
        [bt setFrame:CGRectMake(20, 0, 70, 70)];
        [bt setBackgroundColor:[UIColor clearColor]];
        bt.alpha = 1;
        [bt addTarget:self action:@selector(btExibirRelato:) forControlEvents:UIControlEventTouchUpInside];
        [bt setTag:[[dict valueForKey:@"id"]intValue]];
        [bt setSelected:YES];
        [viewButton addSubview:bt];
        
        [self.arrReportCategorias addObject:bt];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 70, 45)];
        [lbl setText:[dict valueForKey:@"title"]];
        [lbl setNumberOfLines:2];
        [lbl setFont:[Utilities fontOpensSansLightWithSize:10]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [viewButton addSubview:lbl];
        
        [self.scrollCat addSubview:viewButton];
        
        [self createStatusForCategory:dict atPosition:i];
        
        i ++;
        
    }
    
    [self.scrollCat setContentSize:CGSizeMake(weight * arr.count, self.scrollCat.frame.size.height)];

    NSLog(@"%f", self.scrollCat.contentSize.width);
    NSLog(@"%f", self.view.frame.size.width);
    
    CGRect frame = self.scrollCat.frame;
    frame.origin.x = self.view.center.x - (weight * arr.count /2);
    [self.scrollCat setFrame:frame];
}

- (void)createStatusForCategory:(NSDictionary*)dict atPosition:(int)position{

    NSMutableArray *arrMut = [[NSMutableArray alloc]init];
    for (NSDictionary *newDict in [dict valueForKey:@"statuses"]) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setTitle:[newDict valueForKey:@"title"] forState:UIControlStateNormal];
        [bt setTag:[[newDict valueForKey:@"id"]intValue]];
        [bt.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bt setTitleColor:[Utilities colorBlueLight] forState:UIControlStateSelected];
        [bt addTarget:self action:@selector(btStatus:) forControlEvents:UIControlEventTouchUpInside];
        [arrMut addObject:bt];
    }
    
    NSDictionary *dictTemp = @{@"idCategory": [dict valueForKey:@"id"],
                                       @"buttons" : arrMut
                               };
    
    [self.arrButtonStatuses addObject:dictTemp];
    
}

-(void)changeFont:(UIView *) view{
    for (id View in [view subviews]) {
        if ([View isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel*)View;
            CGFloat fontSize = label.font.pointSize;
            [View setFont:[Utilities fontOpensSansWithSize:fontSize]];
            [View setBackgroundColor:[UIColor clearColor]];
        }
        if ([View isKindOfClass:[UIView class]]) {
            [self changeFont:View];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sliderDidChange:(id)sender {

    UISlider *slider = (UISlider*)sender;
    float value = slider.value;
    int intValue = (int)value;
    float fractional = fmodf(value, (float)intValue);
    if(fractional > .5f)
        intValue++;
    
    switch (intValue) {
        case 0:
            self.exploreView.dayFilter = 30* 6;
            break;
        case 1:
            self.exploreView.dayFilter = 30* 3;
            break;
        case 2:
            self.exploreView.dayFilter = 30;
            break;
        case 3:
            self.exploreView.dayFilter = 7;
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        [slider setValue:intValue animated:YES];
    }];
    
}

- (IBAction)btExibirRelato:(id)sender {
    
    [self.btViewStatus setUserInteractionEnabled:YES];

    for (UIButton *bt in self.arrInventoryCategories) {
        [bt setSelected:NO];
    }
    
    [self.btViewStatus setHidden:NO];
    [self.imgSeta setHidden:NO];
    
    currentIdCategory = [sender tag];

    UIButton *currentBt = (UIButton*)sender;
    
    [currentBt setSelected:!currentBt.selected];
    
    for (UIButton *bt in self.arrCurrentButtonStatuses) {
        [bt setSelected:NO];
    }
    [self.btTodosStatus setSelected:YES];
    [self.btViewStatus setTitle:self.btTodosStatus.titleLabel.text forState:UIControlStateNormal];

    if (isMenuOpen)
        [self closeShowStatusView];
    
}

- (IBAction)btStatus:(id)sender {
    
    self.exploreView.statusToFilterId = 0;

    UIButton *bt = (UIButton*)sender;
    
    for (UIButton *newBt in self.arrCurrentButtonStatuses) {
        if (bt == newBt) {
            [newBt setSelected:YES];
            [self.btViewStatus setTitle:newBt.titleLabel.text forState:UIControlStateNormal];
            self.exploreView.statusToFilterId = bt.tag;
        } else
            [newBt setSelected:NO];
    }
    
    if (bt != self.btTodosStatus) {
        [self.btTodosStatus setSelected:NO];
    } else {
        [self.btTodosStatus setSelected:YES];
        [self.btViewStatus setTitle:self.btTodosStatus.titleLabel.text forState:UIControlStateNormal];
    }
    
    [self btViewStatus:nil];

}

- (IBAction)btPontos:(id)sender {
    
    [self.btViewStatus setUserInteractionEnabled:NO];
    if (isMenuOpen) {
        [self closeShowStatusView];

    }
    
    for (UIButton *bt in self.arrReportCategorias) {
        [bt setSelected:NO];
    }
    
    for (UIButton *bt in self.arrInventoryCategories) {
        [bt setSelected:NO];
    }
    
    UIButton *bt = (UIButton*)sender;
    [bt setSelected:!bt.selected];
    
    if (bt.selected) {
        bt.alpha = 1;
    } else {
        bt.alpha = .65;
    }
}

- (IBAction)btConcluido {
    
    [self.exploreView.arrMarkers removeAllObjects];
    [self.exploreView.arrFilterIDs removeAllObjects];
    [self.exploreView.arrFilterInventoryIDs removeAllObjects];
    self.exploreView.isDayFilter = NO;
    self.exploreView.isFromFilter = NO;
    self.exploreView.dayFilter = [self.periodoStatusViewController dayFilter];
    self.exploreView.statusToFilterId = [self.periodoStatusViewController selectedStatusId];
    
    NSArray* reportCategories = [self.categoriasViewController categoriesIds];
    for(NSNumber* catid in reportCategories)
    {
        [self addToFilterArray:[catid intValue]];
        self.exploreView.isDayFilter = YES;
        self.exploreView.isFromFilter = YES;
    }

    /*for (UIButton *bt in self.arrReportCategorias) {
        if (bt.selected) {
            [self addToFilterArray:bt.tag];
            self.exploreView.isDayFilter = YES;
            self.exploreView.isFromFilter = YES;
        }
    }*/
   
    for (NSNumber* catid in [self.inventarioViewController categoriesIds])
    {
        [self addToFilterInventoryArray:[catid intValue]];
        self.exploreView.isDayFilter = YES;
        self.exploreView.isFromFilter = YES;
    }
    
    /*for (UIButton *bt in self.arrBtPontos) {
        if (bt.selected) {
            [self addToFilterInventoryArray:bt.tag];
            self.exploreView.isDayFilter = YES;
            self.exploreView.isFromFilter = YES;
        }
    }*/
    
    if (self.exploreView.arrFilterIDs.count == 0) {
        self.exploreView.isNoReports = YES;
    } else {
        self.exploreView.isNoReports = NO;
    }
    
    if (self.exploreView.arrFilterInventoryIDs.count == 0) {
        self.exploreView.isNoInventories = YES;
    } else {
        self.exploreView.isNoInventories = NO;
    }
    
    [self.exploreView viewWillAppear:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.exploreView.mapView clear];
        [self.exploreView requestWithNewPosition];
        
    }];
}

- (void)addToFilterInventoryArray:(int)idFilter {
    
    NSNumber *numFilterId = [NSNumber numberWithInt:idFilter];
    if (![self.exploreView.arrFilterInventoryIDs containsObject:numFilterId]) {
        [self.exploreView.arrFilterInventoryIDs addObject:numFilterId];
    }
}

- (void)addToFilterArray:(int)idFilter {
    
    NSNumber *numFilterId = [NSNumber numberWithInt:idFilter];
    if (![self.exploreView.arrFilterIDs containsObject:numFilterId]) {
        [self.exploreView.arrFilterIDs addObject:numFilterId];
    }
    
}

- (IBAction)btViewStatus:(id)sender {
    
    for (UIView *view in self.viewStatus.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag != -1) {
            [view removeFromSuperview];
        }
    }
    
    self.arrCurrentButtonStatuses = [[NSMutableArray alloc]init];
    
    int i = 0;
    int i2 = 1;
    for (NSDictionary *dict in self.arrButtonStatuses) {
        
        UIButton *bt = [self.arrReportCategorias objectAtIndex:i];
        if (bt.selected) {
            
            NSArray *arrButtons = [dict valueForKey:@"buttons"];
            for (UIButton *bt in arrButtons) {
                
                BOOL isHave = NO;
                
                for (UIButton *btTemp in self.arrCurrentButtonStatuses) {
                    if (bt.tag == btTemp.tag) {
                        isHave = YES;
                    }
                }
                
                if (!isHave) {
                    [bt setFrame:CGRectMake(250, 44*i2, 120, 40)];
                    [self.viewStatus addSubview:bt];
                    [self.arrCurrentButtonStatuses addObject:bt];
                    i2 ++;
                }
                
            }
        
        }
        
        i ++;
    }
    
    CGRect viewFrame = self.viewStatus.frame;
    viewFrame.size.height = 44*i2;
    [self.viewStatus setFrame:viewFrame];
    
    [self closeShowStatusView];
    
}

- (void)closeShowStatusView {
    
    float position;
    CGSize size = self.scroll.contentSize;
    if (isMenuOpen) {
        position = self.viewStatus.frame.origin.y;
        size.height -= self.viewStatus.frame.size.height;
        [self.imgSeta setImage:[UIImage imageNamed:@"seta_expandir-1"]];
    } else {
        position = self.viewStatus.frame.origin.y + self.viewStatus.frame.size.height;
        size.height += self.viewStatus.frame.size.height;
        [self.imgSeta setImage:[UIImage imageNamed:@"seta_contrair-1"]];
    }
    
    CGRect frame = self.viewPontos.frame;
    frame.origin.y = position;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.viewPontos setFrame:frame];
        [self.scroll setContentSize:size];
    } completion:^(BOOL finished) {
        isMenuOpen = !isMenuOpen;
    }];

}

@end
