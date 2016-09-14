//
//  FiltrarPeriodoStatusViewController.m
//  zup
//

#import "FiltrarPeriodoStatusViewController.h"

@interface FiltrarPeriodoStatusViewController ()

@end

@implementation FiltrarPeriodoStatusViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)createReportButtons {
    
    NSArray *arr2 = [UserDefaults getReportCategories];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:arr2];
    
    
    self.arrReportCategorias = [[NSMutableArray alloc]init];
    self.arrButtonStatuses = [[NSMutableArray alloc]init];
    
    int i = 0;
    //int weight = 90;
    for (NSDictionary *dict in arr) {
        
        [self createStatusForCategory:dict atPosition:i];
        
        i ++;
        
    }
    
    CGRect frame = self.viewStatus.frame;
    frame.size.height = 0;
    self.viewStatus.frame = frame;
    
    [self.btTodosStatus.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];
    [self.btViewStatus.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];
    [self.viewStatus setClipsToBounds:YES];
}

- (void)createStatusForCategory:(NSDictionary*)dict atPosition:(int)position{
    
    NSMutableArray *arrMut = [[NSMutableArray alloc]init];
    for (NSDictionary *newDict in [dict valueForKey:@"statuses"]) {
        if([[newDict valueForKey:@"private"] boolValue])
            continue;
        
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
        
        //UIButton *bt = [self.arrReportCategorias objectAtIndex:i];
        if (true) {
            
            NSArray *arrButtons = [dict valueForKey:@"buttons"];
            ;
            for (UIButton *bt in arrButtons) {
                
                BOOL isHave = NO;
                
                for (UIButton *btTemp in self.arrCurrentButtonStatuses) {
                    if (bt.tag == btTemp.tag) {
                        isHave = YES;
                    }
                }
                
                if (!isHave) {
                    //[bt setFrame:CGRectMake(250, 44*i2, 120, 40)];
                    [bt setFrame:CGRectMake(150, 44*i2, self.view.frame.size.width, 40)];
                    [self.viewStatus addSubview:bt];
                    [self.arrCurrentButtonStatuses addObject:bt];
                    i2 ++;
                }
                
            }
            
        }
        
        i ++;
    }
    
    [self closeShowStatusView];
}

- (IBAction)btStatus:(id)sender {
    
    self->selectedStatusid = 0;
    
    UIButton *bt = (UIButton*)sender;
    
    for (UIButton *newBt in self.arrCurrentButtonStatuses) {
        if (bt == newBt) {
            [newBt setSelected:YES];
            [self.btViewStatus setTitle:newBt.titleLabel.text forState:UIControlStateNormal];
            self->selectedStatusid = bt.tag;
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

- (int)selectedStatusId
{
    return self->selectedStatusid;
}

- (int)dayFilter
{
    return self->dayFilter;
}

- (void)closeShowStatusView {

    CGSize size = self.viewStatus.frame.size;
    if (isMenuOpen) {
        size.height = 0;
        [self.imgSeta setImage:[UIImage imageNamed:@"seta_expandir-1"]];
    } else {
        size.height = 44 * 4;
        [self.imgSeta setImage:[UIImage imageNamed:@"seta_contrair-1"]];
    }
    
    CGRect frame = self.viewStatus.frame;
    frame.size.height = size.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.viewStatus setFrame:frame];
        //[self.scroll setContentSize:size];
    } completion:^(BOOL finished) {
        isMenuOpen = !isMenuOpen;
    }];
    
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
            self->dayFilter = 30* 6;
            break;
        case 1:
            self->dayFilter = 30* 3;
            break;
        case 2:
            self->dayFilter = 30;
            break;
        case 3:
            self->dayFilter = 7;
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        [slider setValue:intValue animated:YES];
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createReportButtons];
    
    UIImage *clearImage = [[UIImage alloc] init];
    [self.slider setMinimumTrackImage:clearImage forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:clearImage forState:UIControlStateNormal];
    
    if (![Utilities isIOS7]) {
        CGRect frame = self.slider.frame;
        frame.origin.y +=4;
        [self.slider setFrame:frame];
        
    }
    
    self->dayFilter = 7;
    self.slider.value = 3;
    //self->dayFilter = 30 * 6;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"Filtrar relatos por período";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
