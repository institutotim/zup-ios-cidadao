//
//  EstatisticasViewController.m
//  Zup
//

#import "EstatisticasViewController.h"
#import "FilterEstatisticasViewController.h"
#import "GraphicCell.h"

@interface EstatisticasViewController ()

@end

@implementation EstatisticasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"Estatísticas";
    
    //[self getValues];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.daysFilter = 0;
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for(NSDictionary* dict in [UserDefaults getReportRootCategories])
    {
        NSNumber* catid = [dict valueForKey:@"id"];
        [arr addObject:catid];
    }
    
    self.selectedCategories = arr;
    
    [self.spin setHidesWhenStopped:YES];
    NSString *titleStr = @"Estatísticas";
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    [lblTitle setFont:[Utilities fontOpensSansLightWithSize:18]];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setText:titleStr];
    [self.navigationController.navigationBar.topItem setTitleView:lblTitle];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView registerClass:[GraphicCell class] forCellWithReuseIdentifier:@"Cell"];
    
    CustomButton *btFilter = [[CustomButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 65, 5, 60, 35)];
    
    [btFilter setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_normal-1"] forState:UIControlStateNormal];
    [btFilter setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_active-1"] forState:UIControlStateHighlighted];
    [btFilter setFontSize:14];
    [btFilter setTitle:@"Filtrar" forState:UIControlStateNormal];
    [btFilter addTarget:self action:@selector(btFilter:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:btFilter];
    
    [self.collectionView setContentMode:UIViewContentModeCenter];
    
    [self getValues];
}


- (IBAction)btFilter:(id)sender {
    FilterEstatisticasViewController *filterVC = [[FilterEstatisticasViewController alloc]initWithNibName:@"FilterEstatisticasViewController" bundle:nil];
    filterVC.estatisticasVC = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:filterVC];
    
    [nav setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:nav animated:YES completion:nil];
    
    if ([Utilities isIpad]) {
        nav.view.superview.bounds = CGRectMake(-25, 0, 470, 620);
        [nav.view.superview setBackgroundColor:[UIColor clearColor]];
    }
    
    [filterVC viewWillAppear:YES];
}

- (void)refreshWithFilter:(int)days categoryId:(int)categoryId {
    
    [self.collectionView setHidden:YES];
    [self.spin startAnimating];
    
    ServerOperations *serverOP = [[ServerOperations alloc]init];
    [serverOP setTarget:self];
    [serverOP setAction:@selector(didReceiveSendResponse:)];
    [serverOP setActionErro:@selector(didReceiveError:)];
    [serverOP getStatsWithFilter:days categoryId:categoryId];
    
}

- (void)refreshWithFilter:(int)days categoryIds:(NSArray*)categoryIds {
    
    [self.collectionView setHidden:YES];
    [self.spin startAnimating];
    
    ServerOperations *serverOP = [[ServerOperations alloc]init];
    [serverOP setTarget:self];
    [serverOP setAction:@selector(didReceiveSendResponse:)];
    [serverOP setActionErro:@selector(didReceiveError:)];
    [serverOP getStatsWithFilter:days categoryIds:categoryIds];
    
}

- (void)getValues {
    
    [self.spin startAnimating];
    [self.collectionView setHidden:YES];
    
    ServerOperations *serverOP = [[ServerOperations alloc]init];
    [serverOP setTarget:self];
    [serverOP setAction:@selector(didReceiveSendResponse:)];
    [serverOP setActionErro:@selector(didReceiveError:)];
    [serverOP getStats];
    
}

- (void)didReceiveSendResponse:(NSData*)data {
    
    [self.collectionView setHidden:NO];
    [self.spin stopAnimating];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
    
    
    NSArray *arrStatuses = [dict valueForKey:@"stats"];
    NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
    
    int totalCount = 0;
    for (NSArray *arr in [arrStatuses valueForKey:@"statuses"]) {
        for (NSMutableDictionary *dict in arr) {
            [arrTemp addObject:dict];
            totalCount += [[dict valueForKey:@"count"]intValue];
        }
    }
    
    NSMutableArray *arrMerge = [[NSMutableArray alloc]init];
    NSMutableArray *arrMerge2 = [[NSMutableArray alloc]init];
    
    for (NSMutableDictionary *dict1 in arrTemp) {
        BOOL contains = NO;
        
        int i = 0;
        for (NSMutableDictionary *dict2 in arrMerge) {
            //if ([[dict1 valueForKey:@"status_id"]intValue] == [[dict2 valueForKey:@"status_id"]intValue]) {
            if ([[[dict1 valueForKey:@"title"] lowercaseString] isEqualToString:[[dict2 valueForKey:@"title"] lowercaseString]]) {
                contains = YES;
            }
            if (!contains) {
                i ++;
            }
        }
       
        if (contains) {
            
            NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:[arrMerge2 objectAtIndex:i]];
            int count = [[newDict valueForKey:@"count"]intValue];
            count += [[dict1 valueForKey:@"count"]intValue];
            [newDict setObject:[NSString stringWithFormat:@"%i", count] forKey:@"count"];
            [arrMerge2 setObject:newDict atIndexedSubscript:i];
        } else {
            [arrMerge addObject:dict1];
            [arrMerge2 addObject:dict1];
        }
        
    }
    
    NSMutableArray *arrMerge3 = [[NSMutableArray alloc]init];
    
    for (NSMutableDictionary *dict in arrMerge2) {
        NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [newDict setObject:[NSString stringWithFormat:@"%i", totalCount] forKey:@"totalCount"];
        [arrMerge3 addObject:newDict];
    }
    
    self.arrMain = [[NSArray alloc]initWithArray:arrMerge3];
    
    if ([Utilities isIpad]) {
        if (self.arrMain.count == 4) {
            [self.collectionView setContentInset:UIEdgeInsetsMake(160 * 2, 20, 0, 20)];
            
            
        } else if (self.arrMain.count == 3) {
            [self.collectionView setContentInset:UIEdgeInsetsMake(160 * 2, 80, 0, 80)];
        }
        else if (self.arrMain.count <= 8) {
            [self.collectionView setContentInset:UIEdgeInsetsMake(170, 20, 0, 20)];
        }
    }
    
    [self.collectionView reloadData];
}

- (void)didReceiveError:(NSError*)error {
    [Utilities alertWithServerError];
    [self.spin stopAnimating];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.arrMain count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GraphicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setValues:[self.arrMain objectAtIndex:indexPath.row]];
    
    return cell;
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
