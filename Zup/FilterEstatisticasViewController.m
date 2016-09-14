//
//  FilterEstatisticasViewController.m
//  Zup
//

#import "FilterEstatisticasViewController.h"
#import "CellFiltrarCategoria.h"

int positionY;

@interface FilterEstatisticasViewController ()

@end

@implementation FilterEstatisticasViewController

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
    
    NSString *titleStr = @"Filtros";
  
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        [lblTitle setFont:[Utilities fontOpensSansLightWithSize:18]];
        [lblTitle setTextColor:[UIColor blackColor]];
        [lblTitle setText:titleStr];
        [self.navigationController.navigationBar.topItem setTitleView:lblTitle];
        
        UIImage *clearImage = [[UIImage alloc] init];
        [self.slider setMinimumTrackImage:clearImage forState:UIControlStateNormal];
        [self.slider setMaximumTrackImage:clearImage forState:UIControlStateNormal];
        
        CGRect frame = self.slider.frame;
        //frame.origin.y +=4;
        [self.slider setFrame:frame];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.scroll addSubview:self.viewContent];
    
    [self changeFont:self.view];
    
    for (UIButton *bt in self.arrBtStatus) {
        [bt.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];
    }
    
    [self.btTodasCategorias.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];

    [self.scroll setBackgroundColor:[Utilities colorGrayLight]];
    [self.viewCategories setBackgroundColor:[Utilities colorGrayLight]];
    [self.viewContent setBackgroundColor:[Utilities colorGrayLight]];
    [self.view setBackgroundColor:[Utilities colorGrayLight]];
    [self.ViewAllCat setBackgroundColor:[Utilities colorGrayLight]];
    [self.viewSlider setBackgroundColor:[Utilities colorGrayLight]];
    
    [self createStatus];

    self->selectedCategories = [NSMutableArray arrayWithArray:self.estatisticasVC.selectedCategories];
    self->categories = [UserDefaults getReportRootCategories];
    [self.tableView registerNib:[UINib nibWithNibName:@"CellFiltrarCategoria" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CellFiltrarInventarioHeader" bundle:nil] forCellReuseIdentifier:@"CellHeader"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    CGRect tframe = self.tableView.frame;
    tframe.origin.y = self.viewSlider.frame.origin.y + 1 + self.viewSlider.frame.size.height;
    tframe.size.height = self.view.frame.size.height - tframe.origin.y;
    
    [self.tableView setFrame:tframe];
    
    /*for(NSDictionary* dict in self->categories)
    {
        NSNumber* catid = [dict valueForKey:@"id"];
        [self->selectedCategories addObject:catid];
    }*/
    
    if(self.estatisticasVC.daysFilter == 30 * 6)
    {
        self.slider.value = 0;
    }
    else if(self.estatisticasVC.daysFilter == 30 * 3)
    {
        self.slider.value = 1;
    }
    else if(self.estatisticasVC.daysFilter == 30)
    {
        self.slider.value = 2;
    }
    else if(self.estatisticasVC.daysFilter == 7)
    {
        self.slider.value = 3;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"Filtrar Estatísticas";
    
    self->categories = [UserDefaults getReportRootCategories];
    
    NSMutableArray* elementsToRemove = [[NSMutableArray alloc] init];
    for(NSNumber* num in self->selectedCategories)
    {
        if(![UserDefaults getCategory:[num intValue]])
            [elementsToRemove addObject:num];
    }
    
    [self->selectedCategories removeObjectsInArray:elementsToRemove];

    
    CustomButton *btFilter = nil;
    btFilter = [[CustomButton alloc] initWithFrame:CGRectMake(self.navigationController.view.bounds.size.width - 83, 5, 78, 35)];
    [btFilter setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_normal-1"] forState:UIControlStateNormal];
    [btFilter setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_active-1"] forState:UIControlStateHighlighted];
    [btFilter setFontSize:14];
    [btFilter setTitle:@"Concluído" forState:UIControlStateNormal];
    [btFilter addTarget:self action:@selector(btFilter:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:btFilter];
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

- (void)createStatus{
    
    NSArray *arr = [UserDefaults getReportCategories];
    
    self.arrButtonStatuses = [[NSMutableArray alloc]init];
    
    for (NSDictionary *newDict in arr) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setTitle:[newDict valueForKey:@"title"] forState:UIControlStateNormal];
        [bt setTag:[[newDict valueForKey:@"id"]intValue]];
        [bt.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bt setTitleColor:[Utilities colorBlueLight] forState:UIControlStateSelected];
        [bt addTarget:self action:@selector(btStatus:) forControlEvents:UIControlEventTouchUpInside];
        [self.arrButtonStatuses addObject:bt];
    }
    
    int i = 1;
    for (UIButton *bt in self.arrButtonStatuses) {
        
        [bt setFrame:CGRectMake(0, 44*i + 6, 320, 40)];
        [self.viewCategories addSubview:bt];
        i ++;
    }
    
    CGRect viewFrame = self.viewCategories.frame;
    viewFrame.size.height = 44*i + 10;
    viewFrame.origin.y -= 44*i + 10;
    positionY = viewFrame.origin.y;
    [self.viewCategories setFrame:viewFrame];
    
    CGRect frameLine = self.imgLineBottomCategoriesBox.frame;
    frameLine.origin.y = self.viewCategories.frame.size.height;
    [self.imgLineBottomCategoriesBox setFrame:frameLine];

}

- (IBAction)btStatus:(id)sender {
    
    UIButton *bt = (UIButton*)sender;
    
    BOOL isAll = YES;
    for (UIButton *newBt in self.arrButtonStatuses) {
        if (bt == newBt) {
            [newBt setSelected:YES];
            currentIdCat = [sender tag];
            [self.btTodasCategorias setTitle:newBt.titleLabel.text forState:UIControlStateNormal];
            isAll = NO;
        } else
            [newBt setSelected:NO];
    }
    
    if (isAll) {
        [self.btTodasCategorias setTitle:@"Todas as categorias" forState:UIControlStateNormal];
    }
    
    [self btCategories:nil];
    
}

- (IBAction)btFilter:(id)sender {
    
    float value = self.slider.value;
    int intValue = (int)value;
    float fractional = fmodf(value, (float)intValue);
    if(fractional > .5f)
        intValue++;

    int daysPassed = 0;
    switch (intValue) {
        case 0:
            daysPassed = 30* 6;
            break;
        case 1:
            daysPassed = 30* 3;
            break;
        case 2:
            daysPassed = 30;
            break;
        case 3:
            daysPassed = 7;
            break;
            
        default:
            break;
    }

    //[self.estatisticasVC refreshWithFilter:daysPassed categoryId:currentIdCat];
    self.estatisticasVC.selectedCategories = self->selectedCategories;
    self.estatisticasVC.daysFilter = daysPassed;
    [self.estatisticasVC refreshWithFilter:daysPassed categoryIds:self->selectedCategories];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btCategories:(id)sender {
    
    CGRect frame = self.viewCategories.frame;
    
    if (isCategoriesOpen) {
        frame.origin.y = positionY;
        [self.imgSeta setImage:[UIImage imageNamed:@"seta_expandir-1"]];
    } else {
        frame.origin.y = 147;
        [self.imgSeta setImage:[UIImage imageNamed:@"seta_contrair-1"]];
    }
    
    isCategoriesOpen = !isCategoriesOpen;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.viewCategories setFrame:frame];
        [self.scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, self.viewCategories.frame.size.height + self.viewCategories.frame.origin.y)];
    }];
    
}


- (IBAction)slider:(id)sender {
    
    UISlider *slider = (UISlider*)sender;
    float value = slider.value;
    int intValue = (int)value;
    float fractional = fmodf(value, (float)intValue);
    if(fractional > .5f)
        intValue++;
        
    [UIView animateWithDuration:0.1 animations:^{
        [slider setValue:intValue animated:YES];
    }];

}


- (BOOL)categoryIsSelected:(int)catid
{
    return [self->selectedCategories containsObject:[NSNumber numberWithInt:catid]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self->categories count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item == 0)
        return 30;
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    CellFiltrarCategoria *cell = (CellFiltrarCategoria *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
    if(cell == nil)
    {
        cell = [[CellFiltrarCategoria alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewBackgroundColor:[self.view backgroundColor]];
    
    if (indexPath.item == 0) // Placeholder
    {
        [cell setPlaceholder];
        return cell;
    }
    
        
    NSDictionary* cat = [self->categories objectAtIndex:indexPath.item - 1];
    NSNumber *catid = [cat objectForKey:@"id"];
        
    BOOL selected = [self categoryIsSelected:[catid intValue]];
        
    [cell setvalues:cat selected:selected iconColored:selected];
        
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* cat = [self->categories objectAtIndex:indexPath.item - 1];
    NSNumber *catid = [cat objectForKey:@"id"];
    BOOL selected = [self categoryIsSelected:[catid intValue]];
    
    if(selected)
        [self->selectedCategories removeObject:catid];
    else
        [self->selectedCategories addObject:catid];
    
    [tableView reloadData];
}

@end
