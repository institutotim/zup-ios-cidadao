//
//  RelateViewController.m
//  Zup
//

#import "RelateViewController.h"
#import "SolicitacaoMapViewController.h"
#import "NavigationControllerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "CellFiltrarCategoria.h"

@interface RelateViewController ()

@end

@implementation RelateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.screenName = @"Seleção de Categoria (Novo Relato)";

    [self setToken];
    
    self->categories = [UserDefaults getReportRootCategories];
    self->selectedCategoryId = 0;
    self->expandedCategories = [[NSMutableArray alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView reloadData];
    
    //[self.navigationController presentViewController:self animated:YES completion:nil];
}

- (void)setToken {
    tokenStr = [UserDefaults getToken];

}

- (void)callLoginView {
    
    MainViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
    loginVC.isFromSolicit = YES;
    loginVC.relateVC = self;
    loginVC.exploreVC = self.exploreVC;
    UINavigationController *navLogin = [[UINavigationController alloc]initWithRootViewController:loginVC];
    
    if ([Utilities isIpad]) {
        [navLogin setModalPresentationStyle:UIModalPresentationFormSheet];
        navLogin.view.superview.bounds = CGRectMake(-25, 0, 470, 620);
        [navLogin.view.superview setBackgroundColor:[UIColor clearColor]];
        
    }
    [self presentViewController:navLogin animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.lblTitle setFont:[Utilities fontOpensSansBoldWithSize:12]];
    
    
    for (UILabel *lbl in self.arrLabel) {
        [lbl setFont:[Utilities fontOpensSansLightWithSize:10]];
    }

    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSString *titleStr = @"Nova solicitação";
 
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        [lblTitle setFont:[Utilities fontOpensSansLightWithSize:18]];
        [lblTitle setTextColor:[UIColor blackColor]];
        [lblTitle setText:titleStr];
        [self.navigationController.navigationBar.topItem setTitleView:lblTitle];
    
    [self createButtons];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CellFiltrarCategoria" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self->categories = [UserDefaults getReportRootCategories];
    self->selectedCategoryId = 0;
    self->expandedCategories = [[NSMutableArray alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self hideToolbar:NO];
}

- (void)createButtons {
    
    self.arrMain = [[NSArray alloc]initWithArray:[UserDefaults getReportCategories]];

    int i = 0;
    int lines = 1;
    int positionX = 0;
    int positionY = 0;
    int weight = 90;
    int viewHeight = 120;
    int space = 24;
    for (NSDictionary *dict in self.arrMain) {
        
        float newPositionX = weight * positionX;
        
        if (self.arrMain.count == 1) {
            newPositionX = 90;
        } else if (self.arrMain.count == 2) {
            if (i == 0) {
                newPositionX += 25;
            } else {
                newPositionX += weight - space;
            }
        }
        
        UIView *viewButton = [[UIView alloc]initWithFrame:CGRectMake(newPositionX + space, positionY +20, weight, viewHeight)];

        if (newPositionX > weight) {
            positionX = 0;
            positionY += viewHeight;
            lines ++;
        } else {
            positionX ++;
        }
        
        UIImage *imgIcon = [UIImage imageWithData:[dict valueForKey:@"iconDataDisabled"]];
        
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setImage:imgIcon forState:UIControlStateNormal];
        [bt setTag:i];
        [bt setFrame:CGRectMake(10, 0, 70, 70)];
        [bt addTarget:self action:@selector(btExibirRelato:) forControlEvents:UIControlEventTouchUpInside];
        [bt setAlpha:0.5];
        
        [viewButton addSubview:bt];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, weight, 40)];
        [lbl setText:[dict valueForKey:@"title"]];
        [lbl setNumberOfLines:2];
        [lbl setFont:[Utilities fontOpensSansLightWithSize:10]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [viewButton addSubview:lbl];
        
        [self.scroll addSubview:viewButton];
        
        i ++;
    }
    
    
    [self.scroll setContentSize:CGSizeMake(320, viewHeight * (lines + 1))];
    
    if (self.scroll.contentSize.width < self.view.frame.size.width) {
        
        [self.scroll setFrame:CGRectMake(self.scroll.frame.origin.x, self.scroll.frame.origin.y, self.scroll.contentSize.width, self.scroll.frame.size.height)];
        
        CGRect frame = self.scroll.frame;
        [self.scroll setFrame:frame];
        
    }
    
    if (self.scroll.contentSize.height < self.view.frame.size.height) {
        
        NSLog(@"%f", self.scroll.contentSize.height);
        
        [self.scroll setFrame:CGRectMake(self.scroll.frame.origin.x, self.scroll.frame.origin.y, self.scroll.contentSize.width, self.scroll.contentSize.height)];
        
        [self.scroll setScrollEnabled:NO];
        
    }
    
    [self.scroll setCenter:self.view.center];
    
    
    
}

- (IBAction)btExibirRelato:(id)sender {
   
    if (tokenStr.length == 0) {
        [self callLoginView];
        return;
    }
    
    UIButton *bt = (UIButton*)sender;
    
    [bt setSelected:YES];
    
    NSDictionary *dict = [self.arrMain objectAtIndex:[sender tag]];
    
    NSString *strCat = [dict valueForKey:@"id"];
    
    SolicitacaoMapViewController *solicVC = [[SolicitacaoMapViewController alloc]initWithNibName:@"SolicitacaoMapViewController" bundle:nil];
    
    solicVC.dictMain = dict;
    solicVC.catStr = strCat;
    
    solicVC.imgIcon = bt.imageView.image;
    NavigationControllerViewController *nav = [[NavigationControllerViewController alloc]initWithRootViewController:solicVC];
    
    if ([Utilities isIpad])
        [nav setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self presentViewController:nav animated:YES completion:^{}];
    
    if ([Utilities isIpad]) {
        nav.view.superview.bounds = CGRectMake(-25, 0, 470, 620);
        [nav.view.superview setBackgroundColor:[UIColor clearColor]];
    }
    
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) hideToolbar:(BOOL)animated
{
    CGRect newframe_tableview = self.tableView.frame;
    newframe_tableview.size.height = self.view.frame.size.height - newframe_tableview.origin.y;
    
    CGRect newframe_bar = self.toolbarView.frame;
    newframe_bar.origin.y = self.view.frame.size.height;
    
    if(animated)
    {
        [UIView animateWithDuration:.3 animations:^{
            self.tableView.frame = newframe_tableview;
            self.toolbarView.frame = newframe_bar;
        }];
    }
    else
    {
        self.tableView.frame = newframe_tableview;
        self.toolbarView.frame = newframe_bar;
    }
}

- (void) showToolbar:(BOOL)animated
{
    CGRect newframe_bar = self.toolbarView.frame;
    newframe_bar.origin.y = self.view.frame.size.height - newframe_bar.size.height;
    
    CGRect newframe_tableview = self.tableView.frame;
    newframe_tableview.size.height = self.view.frame.size.height - newframe_tableview.origin.y - newframe_bar.size.height;
    
    if(animated)
    {
        [UIView animateWithDuration:.3 animations:^{
            self.tableView.frame = newframe_tableview;
            self.toolbarView.frame = newframe_bar;
        }];
    }
    else
    {
        self.tableView.frame = newframe_tableview;
        self.toolbarView.frame = newframe_bar;
    }
}

- (IBAction)criarRelato:(id)sender
{
    if (tokenStr.length == 0) {
        [self callLoginView];
        return;
    }
    
    NSDictionary *dict = [UserDefaults getCategory:self->selectedCategoryId];
    UIImage* icon;
    if([dict valueForKey:@"parent_id"])
    {
        int parentid = [[dict valueForKey:@"parent_id"] intValue];
        NSDictionary* parentdict = [UserDefaults getCategory:parentid];
        
        icon = [UIImage imageWithData:[parentdict valueForKey:@"iconData"]];
    }
    else
        icon = [UIImage imageWithData:[dict valueForKey:@"iconData"]];
    
    NSString *strCat = [dict valueForKey:@"id"];
    
    SolicitacaoMapViewController *solicVC = [[SolicitacaoMapViewController alloc]initWithNibName:@"SolicitacaoMapViewController" bundle:nil];
    
    solicVC.dictMain = dict;
    solicVC.catStr = strCat;
    
    solicVC.imgIcon = icon;
    NavigationControllerViewController *nav = [[NavigationControllerViewController alloc]initWithRootViewController:solicVC];
    
    if ([Utilities isIpad])
        [nav setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self presentViewController:nav animated:YES completion:^{}];
    
    if ([Utilities isIpad]) {
        nav.view.superview.bounds = CGRectMake(-25, 0, 470, 620);
        [nav.view.superview setBackgroundColor:[UIColor clearColor]];
    }
}

// -- TABLE VIEW -- //
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int idx = 0;
    idx++; // Placeholder
    for(int i = 0; i < [self->categories count]; i++)
    {
        NSDictionary* cat = [self->categories objectAtIndex:i];
        NSNumber *catid = [cat objectForKey:@"id"];
        
        BOOL expanded = [self->expandedCategories containsObject:catid];
        
        idx++;
        
        if(expanded)
        {
            NSArray* subcategories = [UserDefaults getReportSubCategories:[catid intValue]];
            
            idx += [subcategories count];
        }
        
        idx++;
    }
    
    return idx;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     BOOL isPhysicalCategory = [self isPhysicalCategory:indexPath.item];
    //BOOL isPhysicalCategory = (indexPath.item % 2) == 0;
    if(indexPath.item == 0)
    {
        return 20;
    }
    else if(isPhysicalCategory)
    {
        CellFiltrarCategoria *cell = (CellFiltrarCategoria *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if(cell == nil)
        {
            cell = [[CellFiltrarCategoria alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        
        NSDictionary* cat = [self categoryAtIndex:indexPath.item];
        NSNumber *catid = [cat objectForKey:@"id"];
        
        BOOL selected = [self isCategorySelected:cat];
        
        [cell setvalues:cat selected:selected iconColored:[self isRootCategorySelected:cat]];
        cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        return cell.height;
        //return 50;
    }
    else
    {
        return 50;
    }
    
}

- (BOOL) isPhysicalCategory:(int)index
{
    return [self categoryAtIndex:index] != nil;
}

- (int) extensorNumberAtIndex:(int)index
{
    int idx = 0;
    idx++; // Placeholder
    int extensorsSoFar = 0;
    for(int i = 0; i < [self->categories count]; i++)
    {
        NSDictionary* cat = [self->categories objectAtIndex:i];
        
        NSNumber *catid = [cat objectForKey:@"id"];
        
        BOOL expanded = [self->expandedCategories containsObject:catid];
        
        if(expanded)
        {
            NSArray* subcategories = [UserDefaults getReportSubCategories:[catid intValue]];
            
            idx += [subcategories count];
        }
        
        idx++;
        if(idx == index)
            return extensorsSoFar;
        
        idx++;
        extensorsSoFar++;
    }
    
    return -1;
}

- (NSDictionary*) categoryForExtensor:(int)index
{
    return [self->categories objectAtIndex:index];
}

- (NSDictionary*) categoryAtIndex:(int)index
{
    int idx = 0;
    idx++; // Placeholder
    for(int i = 0; i < [self->categories count]; i++)
    {
        NSDictionary* cat = [self->categories objectAtIndex:i];
        if(idx == index)
            return cat;
        
        NSNumber *catid = [cat objectForKey:@"id"];
        
        BOOL expanded = [self->expandedCategories containsObject:catid];
        
        idx++;
        
        if(expanded)
        {
            NSArray* subcategories = [UserDefaults getReportSubCategories:[catid intValue]];
            
            for(int j = 0; j < [subcategories count]; j++)
            {
                NSDictionary* subcat = [subcategories objectAtIndex:j];
                
                if(idx == index)
                    return subcat;
                
                idx++;
            }
        }
        
        idx++;
    }
    
    return nil;
}

- (int)indexOfCategory:(int)cat_id
{
    int idx = 0;
    idx++; // Placeholder
    for(int i = 0; i < [self->categories count]; i++)
    {
        NSDictionary* cat = [self->categories objectAtIndex:i];
        
        NSNumber *catid = [cat objectForKey:@"id"];
        
        if([catid intValue] == cat_id)
            return idx;
        
        BOOL expanded = [self->expandedCategories containsObject:catid];
        
        idx++;
        
        if(expanded)
        {
            NSArray* subcategories = [UserDefaults getReportSubCategories:[catid intValue]];
            
            idx += [subcategories count];
        }
        
        idx++;
    }
    
    return -1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    CellFiltrarCategoria *cell = (CellFiltrarCategoria *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[CellFiltrarCategoria alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewBackgroundColor:[UIColor whiteColor]];
    
    BOOL isPhysicalCategory = [self isPhysicalCategory:indexPath.item];
    if(indexPath.item == 0) // placeholder
    {
        [cell setPlaceholder];
    }
    else if(isPhysicalCategory)
    {
        NSDictionary* cat = [self categoryAtIndex:indexPath.item];//[self->categories objectAtIndex:indexPath.item / 2];
        NSNumber *catid = [cat objectForKey:@"id"];
        
        BOOL selected = [self isCategorySelected:cat];
        
        [cell setvalues:cat selected:selected iconColored:[self isRootCategorySelected:cat]];
    }
    else
    {
        NSDictionary* cat = [self categoryForExtensor:[self extensorNumberAtIndex:indexPath.item]];
        NSNumber *catid = [cat objectForKey:@"id"];
        BOOL expanded = [self->expandedCategories containsObject:catid];
        NSArray* subcategories = [UserDefaults getReportSubCategories:[catid intValue]];
        
        if([subcategories count] > 0)
            [cell setShowMoreExpanded:expanded];
        else
            [cell setPlaceholder];
    }
    return cell;
}

- (void)setIsFromOtherTab:(BOOL)isFromOtherTab
{
    
}

- (BOOL)isCategoryRoot:(NSDictionary*)cat
{
    return [cat objectForKey:@"parent_id"] == nil;
}

- (BOOL)isRootCategorySelected:(NSDictionary*)cat
{
    NSNumber *catid = [cat objectForKey:@"id"];
    if([self isCategorySelected:cat])
        return YES;
    
    if(self->selectedCategoryId != 0)
    {
        NSDictionary* selcat = [UserDefaults getCategory:self->selectedCategoryId];
        if([[selcat valueForKey:@"parent_id"] intValue] == [catid intValue])
            return YES;
    }
    
    return NO;
}

- (BOOL)isCategorySelected:(NSDictionary*)cat
{
    NSNumber *catid = [cat objectForKey:@"id"];
    
    return self->selectedCategoryId == [catid intValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isPhysicalCategory = [self isPhysicalCategory:indexPath.item];
    if(indexPath.item == 0)
        return;
    else if(isPhysicalCategory)
    {
        NSDictionary* cat = [self categoryAtIndex:indexPath.item];
        NSNumber *catid = [cat objectForKey:@"id"];
        
        BOOL selected = [self isCategorySelected:cat];
        BOOL expanded = [self->expandedCategories containsObject:catid];
        
        if(!expanded && [[UserDefaults getReportSubCategories:[catid intValue]] count] > 0)
        {
            [self expandCategory:[catid intValue]];
        }
        else
        {
        
        if(self->selectedCategoryId == 0)
        {
            [self showToolbar:YES];
        }
        
        self->selectedCategoryId = [catid intValue];
        
        //[self.tableView reloadData];
            [self reloadData:YES];
        }
    }
    else
    {
        NSDictionary* cat = [self categoryForExtensor:[self extensorNumberAtIndex:indexPath.item]];
        NSNumber *catid = [cat objectForKey:@"id"];
        NSArray* subcats = [UserDefaults getReportSubCategories:[catid intValue]];
        
        BOOL expanded = [self->expandedCategories containsObject:catid];
        
        if(expanded)
            [self->expandedCategories removeObject:catid];
        else
            [self->expandedCategories addObject:catid];
        
        [self.tableView beginUpdates];
        NSMutableArray* rowIndexes = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < [subcats count]; i++)
        {
            int index = [self indexOfCategory:[catid intValue]] + 1 + i;
            [rowIndexes addObject:[NSIndexPath indexPathForItem:index inSection:0]];
        }
        
        if(expanded)
            [self.tableView deleteRowsAtIndexPaths:rowIndexes withRowAnimation:UITableViewRowAnimationBottom];
        else
            [self.tableView insertRowsAtIndexPaths:rowIndexes withRowAnimation:UITableViewRowAnimationBottom];
        
        [self.tableView endUpdates];
        
        int indexToReload = [self indexOfCategory:[catid intValue]] + 1;
        if(!expanded)
            indexToReload += [subcats count];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:indexToReload inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (void)expandCategory:(int)catid
{
    [self->expandedCategories addObject:[NSNumber numberWithInt:catid]];
    
    NSArray* subcats = [UserDefaults getReportSubCategories:catid];
    
    [self.tableView beginUpdates];
    NSMutableArray* rowIndexes = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [subcats count]; i++)
    {
        int index = [self indexOfCategory:catid] + 1 + i;
        [rowIndexes addObject:[NSIndexPath indexPathForItem:index inSection:0]];
    }
    
    [self.tableView insertRowsAtIndexPaths:rowIndexes withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.tableView endUpdates];
    
    int indexToReload = [self indexOfCategory:catid] + 1;
    indexToReload += [subcats count];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:indexToReload inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
    
    if (animated) {
        
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionFade];
        [animation setSubtype:kCATransitionReveal];
        //[animation setType:kCATransitionPush];
        //[animation setSubtype:kCATransitionFromBottom];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setFillMode:kCAFillModeBoth];
        [animation setDuration:.15];
        [[self.tableView layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
        
    }
}

@end
