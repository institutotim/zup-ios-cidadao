//
//  FiltrarCategoriasViewController.m
//  zup
//

#import "FiltrarCategoriasViewController.h"
#import "CellFiltrarCategoria.h"
#import "CellMinhaConta.h"

@interface FiltrarCategoriasViewController ()

@end

@implementation FiltrarCategoriasViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CellFiltrarCategoria" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self->categories = [UserDefaults getReportRootCategories];
    self->allcategories = [UserDefaults getReportCategories];
    
    self->selectedCategories = [[NSMutableArray alloc] init];
    self->expandedCategories = [[NSMutableArray alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    for(NSDictionary* cat in [UserDefaults getReportCategories])
    {
        NSNumber *catid = [cat objectForKey:@"id"];
        
        [self selectCategory:catid];
    }
}

- (NSArray*) getReportSubCategories:(int)idCat
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    NSArray *arr = self->allcategories;
    
    for (NSDictionary *dict in arr)
    {
        if ([dict objectForKey:@"parent_id"] != nil && [[dict objectForKey:@"parent_id"] intValue] == idCat)
        {
            [result addObject:dict];
        }
    }
    
    return result;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"Filtrar relatos por categoria";
    
    self->categories = [UserDefaults getReportRootCategories];
    NSMutableArray* elementsToRemove = [[NSMutableArray alloc] init];
    for(NSNumber* num in self->selectedCategories)
    {
        if(![UserDefaults getCategory:[num intValue]])
            [elementsToRemove addObject:num];
    }
    NSMutableArray* elementsToRemove2 = [[NSMutableArray alloc] init];
    for(NSNumber* num in self->expandedCategories)
    {
        if(![UserDefaults getCategory:[num intValue]])
            [elementsToRemove2 addObject:num];
    }
    
    [self->selectedCategories removeObjectsInArray:elementsToRemove];
    [self->expandedCategories removeObjectsInArray:elementsToRemove2];
    
    [self.tableView reloadData];
}

- (void)setDelegate:(id)obj selector:(SEL)_delegate;
{
    self->delegateObj = obj;
    self->delegate = _delegate;
}

- (void)selectCategory:(NSNumber*)catid
{
    [self->selectedCategories addObject:catid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int idx = 0;
    idx++; // Placeholder
    idx++; // Desativar/ativar todos
    idx++; // Placeholder
    for(int i = 0; i < [self->categories count]; i++)
    {
        NSDictionary* cat = [self->categories objectAtIndex:i];
        NSNumber *catid = [cat objectForKey:@"id"];
        
        BOOL selected = [self->selectedCategories containsObject:catid];
        BOOL expanded = [self->expandedCategories containsObject:catid];
        NSArray* subcategories = [self getReportSubCategories:[catid intValue]];
        
        idx++;
        
        if(expanded)
        {
            idx += [subcategories count];
        }
        
        //if ([subcategories count] > 0)
            idx++;
    }

    return idx;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isPhysicalCategory = [self isPhysicalCategory:indexPath.item];//(indexPath.item % 2) == 0;
    if(indexPath.item == 0)
    {
        return 20;
    }
    else if(indexPath.item == 1)
    {
        return 50;
    }
    else if(indexPath.item == 2)
    {
        return 40;
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
    idx++; // Desativar/ativar todos
    idx++; // Placeholder
    int extensorsSoFar = 0;
    for(int i = 0; i < [self->categories count]; i++)
    {
        NSDictionary* cat = [self->categories objectAtIndex:i];
        
        NSNumber *catid = [cat objectForKey:@"id"];
        
        NSArray* subcategories = [self getReportSubCategories:[catid intValue]];
        BOOL expanded = [self->expandedCategories containsObject:catid];
        
        if(expanded)
        {
            idx += [subcategories count];
        }
        
        idx++;
        if(idx == index)
            return extensorsSoFar;
        
        //if([subcategories count] > 0)
        {
            idx++;
            extensorsSoFar++;
        }
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
    idx++; // Desativar/ativar todos
    idx++; // Placeholder
    for(int i = 0; i < [self->categories count]; i++)
    {
        NSDictionary* cat = [self->categories objectAtIndex:i];
        if(idx == index)
            return cat;
        
        NSNumber *catid = [cat objectForKey:@"id"];
        
        BOOL selected = [self->selectedCategories containsObject:catid];
        BOOL expanded = [self->expandedCategories containsObject:catid];
        NSArray* subcategories = [self getReportSubCategories:[catid intValue]];
        
        idx++;
        
        if(expanded)
        {
            for(int j = 0; j < [subcategories count]; j++)
            {
                NSDictionary* subcat = [subcategories objectAtIndex:j];
                
                if(idx == index)
                    return subcat;
                
                idx++;
            }
        }
        
        //if([subcategories count] > 0)
            idx++;
    }
    
    return nil;
}

- (BOOL)areAllCategoriesEnabled
{
    for(NSDictionary* cat in self->categories)
    {
        if(![self isCategorySelected:cat])
            return NO;
    }
    
    return YES;
}

- (int)indexOfCategory:(int)cat_id
{
    int idx = 0;
    idx++; // Placeholder
    idx++; // Desativar/ativar todos
    idx++; // Placeholder
    for(int i = 0; i < [self->categories count]; i++)
    {
        NSDictionary* cat = [self->categories objectAtIndex:i];
        
        NSNumber *catid = [cat objectForKey:@"id"];
        
        if([catid intValue] == cat_id)
            return idx;
        
        BOOL selected = [self->selectedCategories containsObject:catid];
        BOOL expanded = [self->expandedCategories containsObject:catid];
        NSArray* subcategories = [self getReportSubCategories:[catid intValue]];
        
        idx++;
        
        if(expanded)
        {
            idx += [subcategories count];
        }
        
        //if([subcategories count] > 0)
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
    [cell setViewBackgroundColor:[UIColor colorWithRed:.94 green:.94 blue:.94 alpha:1]];

    
    BOOL isPhysicalCategory = [self isPhysicalCategory:indexPath.item];
    if(indexPath.item == 0 || indexPath.item == 2) // placeholder
    {
        [cell setPlaceholder];
    }
    else if(indexPath.item == 1) // ativar/desativar todos
    {
        [cell setActivateDeactivate:[self areAllCategoriesEnabled]];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else if(isPhysicalCategory)
    {
        NSDictionary* cat = [self categoryAtIndex:indexPath.item];
        NSNumber *catid = [cat objectForKey:@"id"];
        
        BOOL selected = [self isCategorySelected:cat];
        
        [cell setvalues:cat selected:selected iconColored:[self isRootCategorySelected:cat]];
    }
    else
    {
        NSDictionary* cat = [self categoryForExtensor:[self extensorNumberAtIndex:indexPath.item]];
        NSNumber *catid = [cat objectForKey:@"id"];
        BOOL expanded = [self->expandedCategories containsObject:catid];
        NSArray* subcategories = [self getReportSubCategories:[catid intValue]];
        
        if([subcategories count] > 0)
            [cell setShowMoreExpanded:expanded];
        else
            [cell setPlaceholder];
    }
    return cell;
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
    
    for(NSNumber* selcatid in self->selectedCategories)
    {
        NSDictionary* selcat = [UserDefaults getCategory:[selcatid intValue]];
        
        if([[selcat valueForKey:@"parent_id"] intValue] == [catid intValue])
            return YES;
    }
    
    return NO;
}

- (BOOL)isCategorySelected:(NSDictionary*)cat
{
    NSNumber *catid = [cat objectForKey:@"id"];
    
    if(![self isCategoryRoot:cat] || [[self getReportSubCategories:[catid intValue]] count] < 1)
    {
        return [self->selectedCategories containsObject:catid];
    }
    else if([[self getReportSubCategories:[catid intValue]] count] > 0)
    {
        NSArray* subcats = [self getReportSubCategories:[catid intValue]];
        
        for(NSDictionary* subcat in subcats)
        {
            NSNumber *subcatid = [subcat objectForKey:@"id"];
            
            if(![self->selectedCategories containsObject:subcatid])
                return NO;
        }
        
        return YES;
    }

    return NO;
}

- (void)deselectAll
{
    [self->selectedCategories removeAllObjects];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isPhysicalCategory = [self isPhysicalCategory:indexPath.item];
    if(indexPath.item == 0 || indexPath.item == 2)
        return;
    else if(indexPath.item == 1)
    {
        BOOL selected = [self areAllCategoriesEnabled];
        if(selected)
            [self->selectedCategories removeAllObjects];
        else
        {
            [self->selectedCategories removeAllObjects];
            
            for(NSDictionary* cat in [UserDefaults getReportCategories])
            {
                NSNumber *catid = [cat objectForKey:@"id"];
                
                [self selectCategory:catid];
            }
        }
        
        [self reloadData:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self->delegateObj performSelector:self->delegate withObject:self];
    }
    else if(isPhysicalCategory)
    {
        NSDictionary* cat = [self categoryAtIndex:indexPath.item];
        NSNumber *catid = [cat objectForKey:@"id"];
        
        BOOL selected = [self isCategorySelected:cat];
        
        if(![self isCategoryRoot:cat] || [[self getReportSubCategories:[catid intValue]] count] < 1)
        {
            if(selected)
                [self->selectedCategories removeObject:catid];
            else
            {
                [self selectCategory:catid];
            }
        }
        else if([[self getReportSubCategories:[catid intValue]] count] > 0)
        {
            NSArray* subcats = [self getReportSubCategories:[catid intValue]];
            
            for(NSDictionary* subcat in subcats)
            {
                NSNumber *subcatid = [subcat objectForKey:@"id"];
                
                if(selected)
                    [self->selectedCategories removeObject:subcatid];
                else
                    [self selectCategory:subcatid];
            }
        }
        
        //[self.tableView reloadData];
        [self reloadData:YES];
        [self->delegateObj performSelector:self->delegate withObject:self];
    }
    else
    {
        NSDictionary* cat = [self categoryForExtensor:[self extensorNumberAtIndex:indexPath.item]];
        NSNumber *catid = [cat objectForKey:@"id"];
        NSArray* subcats = [self getReportSubCategories:[catid intValue]];
        
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

- (NSArray*) categoriesIds
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    /*for(NSDictionary* cat in [UserDefaults getReportCategories])
    {
        NSNumber* catid = [cat valueForKey:@"id"];
        if ([self isCategorySelected:cat])
        {
            [result addObject:catid];
        }
    }*/
    
    for(NSNumber* catid in self->selectedCategories)
    {
        [result addObject:catid];
    }
    
    return result;
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
