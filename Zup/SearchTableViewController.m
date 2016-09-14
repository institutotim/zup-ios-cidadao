//
//  SearchTableViewController.m
//  Zup
//

#import "SearchTableViewController.h"
#import "SolicitacaoMapViewController.h"
#import "ExploreViewController.h"

int ZOOMLEVELSEARCH = 16;

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)getLocationWithString:(NSString*)strKey andLocation:(GMSCoordinateBounds*)coord{
    ServerOperations *server = [[ServerOperations alloc]init];
    [server setTarget:self];
    [server setAction:@selector(didReceiveAddress:)];
    [server getAddressWithString:strKey andGeo:coord.northEast.latitude lng:coord.northEast.longitude southLat:coord.southWest.latitude southLng:coord.southWest.longitude];
}

- (void)getLocationWithLoction:(CLLocationCoordinate2D)location {
    ServerOperations *server = [[ServerOperations alloc]init];
    [server setTarget:self];
    [server setAction:@selector(didReceiveAddress:)];
    [server getAddressWitLatitude:location.latitude andLongitude:location.longitude];
}

- (void)didReceiveAddress:(NSData*)data {
    dict = [[NSDictionary alloc]init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    if ([dict valueForKey:@"results"]) {
        
        int count = 0;
        
        if ([Utilities isIpad]) {
            count = 3;
            if ([[dict valueForKey:@"results"]count] < 3) {
                count = [[dict valueForKey:@"results"]count];
            }
        } else {
            count = [[dict valueForKey:@"results"]count];
        }
        
        NSMutableArray *arrMut = [[NSMutableArray alloc]init];
        for (int i = 0; i < count; i ++) {
            NSMutableString *str = [[NSMutableString alloc]init];
            
            if ([[[dict valueForKey:@"results"]objectAtIndex:i]valueForKey:@"address_components"]) {

                [str appendString:[[[dict valueForKey:@"results"]objectAtIndex:i]valueForKey:@"formatted_address"]];
              
                [arrMut addObject:str];
            }
            
        }
        
        self.arrLocations = [[NSArray alloc]initWithArray:arrMut];
        [self.tableView reloadData];
        
    }
}

- (void)clearTable {
    self.arrLocations = nil;
    [self.tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrLocations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.arrLocations objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[Utilities fontOpensSansLightWithSize:15]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    float lat = [[[[dict valueForKey:@"results"]objectAtIndex:indexPath.row]valueForKeyPath:@"geometry.location.lat"]floatValue];
    
    float lng = [[[[dict valueForKey:@"results"]objectAtIndex:indexPath.row]valueForKeyPath:@"geometry.location.lng"]floatValue];

    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat, lng);
    
    
    if (self.isExplore) {
        [self.explorerView.mapView clear];
        [self.explorerView.arrMarkers removeAllObjects];
        //[self.explorerView.arrFilterIDs removeAllObjects];
        //[self.explorerView.arrFilterInventoryIDs removeAllObjects];
        
        
        [self.explorerView setLocationWithClLocation:location zoom:ZOOMLEVELSEARCH];
        
        if (![Utilities isIpad])
            [self.explorerView moveSearchBarIsTop:NO];
        
        [self.explorerView.searchBar resignFirstResponder];
        
        self.explorerView.isReportsLoading = NO;
        self.explorerView.isInventoryLoading = NO;
        [self.explorerView requestWithNewPosition];
        [self.explorerView setPositionMarkerForSearch];
        [self.explorerView.searchBar setText:[self.arrLocations objectAtIndex:indexPath.row]];
    } else {
        
        int diffZoom = 3;
        float zoomCurrent;
        if ([Utilities isIpad])
            zoomCurrent = ZOOMLEVELSEARCH + diffZoom;
        else
            zoomCurrent = ZOOMLEVELSEARCH + diffZoom;
            
        [self.solicitacaoView setLocationWithCoordinate:location zoom:zoomCurrent];
        if(self.solicitacaoView.tfNumber.text.length > 0)
            self.solicitacaoView->isCustomNumber = YES;
        else
            self.solicitacaoView->isCustomNumber = NO;
        
        if (![Utilities isIpad])
            [self.solicitacaoView moveSearchBarIsTop:NO];
        
        [self.solicitacaoView.searchBar resignFirstResponder];
        
        [self.solicitacaoView getIventoryPoints];
        [self.solicitacaoView setPositionMarkerForSearch];
        
        [self.solicitacaoView.searchBar setShowsCancelButton:NO animated:YES];
        [self.solicitacaoView closeSearchTable];
        [self.solicitacaoView.tfNumber resignFirstResponder];
    }
    
    [self.view setHidden:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
 


@end
