//
//  FiltrarInventarioViewController.m
//  zup
//

#import "FiltrarInventarioViewController.h"
#import "CellFiltrarCategoria.h"

@interface FiltrarInventarioViewController ()

@end

@implementation FiltrarInventarioViewController

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
    self.screenName = @"Filtrar itens de inventário";
    
    self->categories = [UserDefaults getInventoryCategories];
    NSMutableArray* elementsToRemove = [[NSMutableArray alloc] init];
    for(NSNumber* num in self->selectedCategories)
    {
        if(![UserDefaults getInventoryCategory:[num intValue]])
            [elementsToRemove addObject:num];
    }
    
    [self->selectedCategories removeObjectsInArray:elementsToRemove];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self->selectedCategories = [[NSMutableArray alloc] init];
    self->categories = [UserDefaults getInventoryCategories];
    [self.tableView registerNib:[UINib nibWithNibName:@"CellFiltrarCategoria" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CellFiltrarInventarioHeader" bundle:nil] forCellReuseIdentifier:@"CellHeader"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)setDelegate:(id)obj selector:(SEL)_delegate
{
    self->delegateObj = obj;
    self->delegate = _delegate;
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
    static NSString *cellIdentifier = @"Cell";
    
    if(indexPath.item == 0)
        return 100;
    else
    {
        CellFiltrarCategoria *cell = (CellFiltrarCategoria *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil)
        {
            cell = [[CellFiltrarCategoria alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        NSDictionary* cat = [self->categories objectAtIndex:indexPath.item - 1];
        NSNumber *catid = [cat objectForKey:@"id"];
        
        BOOL selected = [self categoryIsSelected:[catid intValue]];
        
        [cell setvalues:cat selected:selected iconColored:selected];
        cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        return cell.height;
        //return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    if(indexPath.item == 0)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellHeader"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellHeader"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        CellFiltrarCategoria *cell = (CellFiltrarCategoria *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
        if(cell == nil)
        {
            cell = [[CellFiltrarCategoria alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
        NSDictionary* cat = [self->categories objectAtIndex:indexPath.item - 1];
        NSNumber *catid = [cat objectForKey:@"id"];
        
        BOOL selected = [self categoryIsSelected:[catid intValue]];
        
        [cell setvalues:cat selected:selected iconColored:selected];
    
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item == 0)
        return;
    
    NSDictionary* cat = [self->categories objectAtIndex:indexPath.item - 1];
    NSNumber *catid = [cat objectForKey:@"id"];
    BOOL selected = [self categoryIsSelected:[catid intValue]];
    
    if(selected)
        [self->selectedCategories removeObject:catid];
    else
    {
        [self->selectedCategories removeAllObjects];
        [self->selectedCategories addObject:catid];
    }
    
    [tableView reloadData];
    [self->delegateObj performSelector:self->delegate withObject:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isCategorySelected:(NSDictionary*)cat
{
    NSNumber* catid = [cat valueForKey:@"id"];
    return [self->selectedCategories containsObject:catid];
}

- (NSArray*) categoriesIds
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    /*for(NSDictionary* cat in self->categories)
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

- (void) deselectAll
{
    [self->selectedCategories removeAllObjects];
    [self.tableView reloadData];
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
