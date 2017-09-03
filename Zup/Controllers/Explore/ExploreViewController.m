//
//  ExploreViewController.m
//  Zup
//

#import "ExploreViewController.h"
#import "ListExploreViewController.h"
#import "PerfilDetailViewController.h"
#import "InfoWindow.h"
#import "AppDelegate.h"
#import "ImageCache.h"

static int ZOOMLEVELDEFAULT = 16;

@interface ExploreViewController ()

@property (nonatomic, strong) ServerOperations *serverOperationsReport;
@property (nonatomic, strong) ServerOperations *serverOperationsInventory;
@property (nonatomic, strong) ServerOperations *serverOperationsInventoryList;
@property (nonatomic, strong) GMSMarker *currentMarker;
@property (nonatomic, strong) CustomButton *btFilter;
@property (nonatomic, strong) UIView *viewLogo;
@property (nonatomic, strong) UIImageView *viewHeader;
@property (nonatomic, strong) SearchTableViewController *searchTable;
@property (nonatomic, strong) GMSMarker *markerSearch;
@property (nonatomic, strong) GMSCoordinateBounds *boundsCurrent;
@property (nonatomic, strong) FiltrarViewController *filtrarVC;

@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoord;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) BOOL isFromSolicit;
@property (nonatomic, assign) BOOL initializing;

@end

@implementation ExploreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.initializing = YES;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.initializing = YES;
    
    [self initMap];
    
    NSString *imageName = [NSString stringWithFormat:@"explore_logo_%@", [Utilities getCurrentTenant]];
    UIImage *logoImage = [UIImage imageNamed:imageName];
    if (!logoImage)
        logoImage = [UIImage imageNamed:@"explore_logo"];
    
    // Calcular largura da imagem redimensionada
    float height = MIN(logoImage.size.height, 22.0f);
    int hwidth = (logoImage.size.width / logoImage.size.height) * height;

    self.viewLogo = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - hwidth/2, (44-height)/2/*14*/, hwidth, height)];
    UIImageView *image = [[UIImageView alloc]initWithImage:logoImage];
    image.frame = CGRectMake(0, 0, hwidth, 22);
    image.contentMode = UIViewContentModeScaleAspectFit;
    [self.viewLogo addSubview:image];
    self.navigationItem.titleView = self.viewLogo;
    
    self.viewHeader = [[UIImageView alloc] initWithImage:[Utilities getTenantHeaderImage]];

    int width = (self.viewHeader.image.size.width / self.viewHeader.image.size.height) * 34.0f;
    int realwidth = MIN(self.view.bounds.size.width/2 - 64, width);

    self.viewHeader.frame = CGRectMake(10, 5, realwidth, 44 - 10);
    self.viewHeader.contentMode = UIViewContentModeScaleAspectFit;

    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] init];
    spacer.width = -5;
    UIBarButtonItem *headerBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.viewHeader];
    self.navigationItem.leftBarButtonItems = @[spacer, headerBarButton];

    [self.searchBar setBackgroundImage:[UIImage new]];
    [self.searchBar setDelegate:self];
    
    [self.mapView setDelegate:self];
    [self.mapView setMyLocationEnabled:YES];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if (![Utilities isIOS7]) {
        [[UISearchBar appearance]setTintColor:[UIColor whiteColor]];
    }

    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[Utilities fontOpensSansWithSize:15]];
    
    self.btFilter = [[CustomButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 65, 5, 60, 35)];
    [self.btFilter setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_normal-1"] forState:UIControlStateNormal];
    [self.btFilter setBackgroundImage:[UIImage imageNamed:@"menubar_btn_filtrar-editar_active-1"] forState:UIControlStateHighlighted];
    [self.btFilter setFontSize:14];
    [self.btFilter setTitle:@"Filtrar" forState:UIControlStateNormal];
    [self.btFilter addTarget:self action:@selector(btFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    spacer = [[UIBarButtonItem alloc] init];
    spacer.width = -5;
    
    UIBarButtonItem *filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.btFilter];
    self.navigationItem.rightBarButtonItems = @[spacer, filterBarButton];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(didPan:)];
    self.mapView.gestureRecognizers = @[panRecognizer];
    
    self.isDayFilter = YES;
    self.dayFilter = 7;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Explore";
    
    //[viewLogo setHidden:NO];
    //[viewHeader setHidden:NO];
    
    if (self.isFromSolicit) {
        [self.arrMarkers removeAllObjects];
        [self requestWithNewPosition];
        self.isFromSolicit = NO;
    }
    
    if (self.isFromOtherTab) {
        self.isFromOtherTab = NO;
        [self.arrMarkers removeAllObjects];
        // [self requestWithNewPosition];
        [self createInventoryPoints];
//        [self createPoints];
    }
    
    [self performSelector:@selector(tryToShowPendingReport) withObject:nil afterDelay:1.0f];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    //[btFilter removeFromSuperview];
    //[viewLogo setHidden:YES];
    //[viewHeader setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Auxiliar Methods

//- (void)setDayFilter:(int)dayFilter {
//    self.dayFilter = dayFilter;
//}

- (void)initMap {
    self.isNoInventories = YES;
    
    self.arrFilterIDs = [[NSMutableArray alloc] init];
    self.arrFilterInventoryIDs = [[NSMutableArray alloc] init];
    self.arrMain = [[NSMutableArray alloc] init];
    self.arrMainInventory = [[NSMutableArray alloc] init];
    self.arrMarkers = [[NSMutableArray alloc] init];
    
    [self getCurrentLocation];
    
    if (self.initializing) {
        int zoom;
        if ([Utilities isIpad])
            zoom = ZOOMLEVELDEFAULT;
        else
            zoom = ZOOMLEVELDEFAULT;
        
        CLLocationCoordinate2D coordinate = [Utilities getTenantInitialLocation];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                                longitude:coordinate.longitude
                                                                     zoom:zoom];
        
        self.mapView.camera = camera;
        [self.mapView clear];
        
        [self requestWithNewPosition];
        
        self.initializing = NO;
    }
}

- (void)didPan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateEnded) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(requestWithNewPosition) withObject:nil afterDelay:0];
    }
}

- (void)tryToShowPendingReport {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.pendingReport) {
        [self buildDetail:delegate.pendingReport];
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"backToMap" object:nil userInfo:delegate.pendingReport];
        delegate.pendingReport = nil;
    }
}

- (void)convertButtonTitle:(NSString *)from toTitle:(NSString *)to inView:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        if (from == nil || [[button titleForState:UIControlStateNormal] isEqualToString:from]) {
            [button setTitle:to forState:UIControlStateNormal];
            [button sizeToFit];
        }
    }
    
    for (UIView *subview in view.subviews) {
        [self convertButtonTitle:from toTitle:to inView:subview];
    }
}

- (void)moveSearchBarIsTop:(BOOL)isTop {
    int positionBox = 7;
    int positionSearchBar = 10;
    
    if (isTop) {
        positionBox = 27;
        positionSearchBar = 30;
    }
    
    CGRect frameBox = self.imgSearchBox.frame;
    frameBox.origin.y = positionBox;
    
    CGRect frameSBar = self.searchBar.frame;
    frameSBar.origin.y = positionSearchBar;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.searchBar setFrame:frameSBar];
        [self.imgSearchBox setFrame:frameBox];
    }];
}

#pragma mark - Actions

- (IBAction)btFilter:(id)sender {
    if (!self.filtrarVC) {
        self.filtrarVC = [[FiltrarViewController alloc] initWithNibName:@"FiltrarViewControllerNovo" bundle:nil];
    }
    self.filtrarVC.exploreView = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.filtrarVC];
    [nav.navigationBar setTranslucent:NO];
    
    if ([Utilities isIpad]) {
        [nav setModalPresentationStyle:UIModalPresentationFormSheet];
    }
    
    [self presentViewController:nav animated:YES completion:nil];
    
    if ([Utilities isIpad]) {
        nav.view.superview.bounds = CGRectMake(-25, 0, 470, 620);
        [nav.view.superview setBackgroundColor:[UIColor clearColor]];
    }
    
    [self.filtrarVC viewWillAppear:YES];
    
    //[self viewWillAppear:YES];
}

#pragma mark - Core Location

- (void)getCurrentLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    CLLocation *location = [self.locationManager location];
    self.currentCoordinate = [location coordinate];
    
//    #warning TESTE
//    currentCoordinate = CLLocationCoordinate2DMake(-23.557040, -46.638610);
    
    int zoom;
    if ([Utilities isIpad])
        zoom = ZOOMLEVELDEFAULT;
    else
        zoom = ZOOMLEVELDEFAULT;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentCoordinate.latitude
                                                            longitude:self.currentCoordinate.longitude
                                                                 zoom:zoom];
    
    
    self.mapView.camera = camera;
    [self.mapView clear];
    
    [self requestWithNewPosition];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = [self.locationManager location];
    self.currentCoordinate = [location coordinate];
    
    int zoom;
    if ([Utilities isIpad])
        zoom = ZOOMLEVELDEFAULT;
    else
        zoom = ZOOMLEVELDEFAULT;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentCoordinate.latitude
                                                            longitude:self.currentCoordinate.longitude
                                                                 zoom:zoom];
    
    
    self.mapView.camera = camera;
    [self.mapView clear];
    
    [self requestWithNewPosition];
    
//    if (currentCoordinate.latitude == 0) {
//        [self getCurrentLocation];
//    } else {
        [self.locationManager stopUpdatingLocation];
//    }
}

- (void)setLocationWithClLocation:(CLLocationCoordinate2D)coordinate zoom:(int)newZoom{
    
    int zoom;
    if ([Utilities isIpad])
        zoom = ZOOMLEVELDEFAULT + 2;
    else
        zoom = ZOOMLEVELDEFAULT;
    
    if (newZoom != 0) {
        zoom = newZoom;
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:zoom];
    
    
    self.mapView.camera = camera;
    
    self.currentCoordinate = coordinate;
    [self getPoints];
    
    [self.searchBar resignFirstResponder];
}

- (void)setIsFromOtherTab:(BOOL)isFromOtherTab {
    
}

#pragma mark - Get Reports

- (void)getPoints {
    
    if ([Utilities isInternetActive]) {
        
        self.isReportsLoading = YES;
        
        int radius = self.mapView.camera.zoom;
        radius = 21 - radius;
        
        if ([Utilities isIpad]) {
            radius = radius * 2000;
        } else {
            radius = radius * 1400;
        }
        
        GMSVisibleRegion visibleRegion = [[self.mapView projection] visibleRegion];
        double distance = [self getDistance:visibleRegion.nearRight p2:visibleRegion.nearLeft];
        
        [self.serverOperationsReport CancelRequest];
        self.serverOperationsReport = nil;
        
        self.serverOperationsReport = [[ServerOperations alloc]init];
        [self.serverOperationsReport setTarget:self];
        [self.serverOperationsReport setAction:@selector(didReceiveData:)];
        [self.serverOperationsReport setActionErro:@selector(didReceiveError:data:)];
        
        NSArray *searchCategories = nil;
        NSDate *searchDate = nil;
        NSArray *searchStatuses = nil;
        
        if ([self.arrFilterIDs count] > 0)
            searchCategories = self->_arrFilterIDs;
        
        searchDate = [Utilities todayMinusDays:self.dayFilter];
        if (self.statusToFilterId != 0)
            searchStatuses = @[[NSNumber numberWithInt:self->_statusToFilterId]];
        
        [self.serverOperationsReport getReportItemsForPosition:self.currentCoordinate.latitude
                                                     longitude:self.currentCoordinate.longitude
                                                        radius:distance
                                                          zoom:self.mapView.camera.zoom 
                                                   categoryIds:searchCategories
                                                     sinceDate:searchDate
                                                      statuses:searchStatuses];
        
        /*if([self->_arrFilterIDs count] > 0)
        {
            [serverOperationsReport getReportItemsForPosition:currentCoordinate.latitude longitude:currentCoordinate.longitude radius:distance zoom:self.mapView.camera.zoom categoryIds:_arrFilterIDs];
        }
        else
            [serverOperationsReport getReportItemsForPosition:currentCoordinate.latitude longitude:currentCoordinate.longitude radius:distance zoom:self.mapView.camera.zoom];*/
    }
}

- (void)clearMap {
    [self.arrMainInventory removeAllObjects];
    [self.arrMain removeAllObjects];
    
    for (GMSMarker *marker in self.arrMarkers) {
        marker.map = nil;
    }
    
    [self.arrMarkers removeAllObjects];
}

- (void)clearClusters {
    NSMutableArray *itemsToRemove = [[NSMutableArray alloc] init];
    
    for (GMSMarker *marker in self.arrMarkers) {
        if ([[marker.userData valueForKey:@"isCluster"] boolValue]) {
            marker.map = nil;
            [itemsToRemove addObject:marker];
        }
    }
    
    [self.arrMarkers removeObjectsInArray:itemsToRemove];
}

- (void)clearNonClusters {
    NSMutableArray *itemsToRemove = [[NSMutableArray alloc] init];
    
    for (GMSMarker *marker in self.arrMarkers) {
        if (![[marker.userData valueForKey:@"isCluster"] boolValue]) {
            marker.map = nil;
            [itemsToRemove addObject:marker];
        }
    }
    
    [self.arrMarkers removeObjectsInArray:itemsToRemove];
}

- (GMSMarker *)nearestClusterToMarker:(GMSMarker *)marker withArrayOfMarkers:(NSArray *)markers {
    GMSMarker *nearest = nil;
    CLLocationDistance nearestDistance = CLLocationDistanceMax;
    
    for (GMSMarker *m in markers) {
        if ([[m.userData valueForKey:@"isCluster"] boolValue]) {
            CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:marker.position.latitude longitude:marker.position.longitude];
            CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:m.position.latitude longitude:m.position.longitude];
            
            CLLocationDistance dist = [loc1 distanceFromLocation:loc2];
            
            if (dist < nearestDistance) {
                nearest = m;
                nearestDistance = dist;
            }
        }
    }
    
    return nearest;
}

- (GMSMarker *)clusterForReport:(int)reportId withArrayOfMarkers:(NSArray *)markers {
    for (GMSMarker *m in markers) {
        if ([[m.userData valueForKey:@"isCluster"] boolValue]) {
            NSArray *reportIds = [m.userData valueForKey:@"reports_ids"];
            if(reportIds && [reportIds containsObject:[NSNumber numberWithInt:reportId]])
                return m;
        }
    }
    
    return nil;
}

- (void)removeMarkers:(NSArray*)markers exceptFor:(NSArray *)arr {
    NSMutableArray *objsToRemove = [[NSMutableArray alloc] init];
    for (GMSMarker *marker in markers) {
        if (![arr containsObject:marker]) {
            marker.map = nil;
            [objsToRemove addObject:marker];
        }
    }
    [self.arrMarkers removeObjectsInArray:objsToRemove];
}

- (BOOL)arrayOfMarkers:(NSArray *)array hasReport:(int)reportId {
    for (GMSMarker *marker in array) {
        if (![[marker.userData valueForKey:@"isCluster"] boolValue]) {
            NSNumber *_id = [marker.userData valueForKey:@"id"];
            if (_id && !(_id.class == [NSNull class]) && [_id intValue] == reportId)
               return YES;
        }
    }
               
    return NO;
}

- (void)didReceiveData:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isReportsLoading = NO;
        
        if (self.isNoReports)
            return;
        
        //[self clearMap];
        //NSArray* oldItems = [self.arrMain copy];
        NSArray* markersToRemoveFromMap = [self.arrMarkers copy];
        //[self clearMap];
        
        [self.arrMain removeAllObjects];
        [self.arrMarkers removeAllObjects];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *arr = [dict valueForKey:@"reports"];
        NSArray* arrClusters = [dict valueForKey:@"clusters"];
        
        for (NSDictionary *dict in arr) {
            if (![self.arrMain containsObject:dict]) {
                [self.arrMain addObject:dict];
            }
        }
        
        int maxCount = 0;
        if ([Utilities isIpad] || [Utilities isIphone4inch]) maxCount = maxMarkersCountiPhone5iPad;
        else maxCount = maxMarkersCountiPhone4;
        
        NSUInteger markersCount = [self.arrMain count];
        if (markersCount > maxCount) {
            unsigned long markersToRemove = self.arrMain.count - maxCount;
            
            for (int i = 0; i < markersToRemove; i ++) {
                
                NSDictionary *dict = [self.arrMain objectAtIndex:0];
                if(![self markerPassesValidation:dict])
                {
                    [self.arrMain removeObjectAtIndex:0];
                    continue;
                }
                
                int markerId = [[dict valueForKey:@"id"]intValue];
                
                NSArray *arr = [NSArray arrayWithArray:self.arrMarkers];
                for (GMSMarker *tempMarker in arr) {
                    int tempMarkerId = [[tempMarker.userData valueForKey:@"id"]intValue];
                    if (tempMarkerId == markerId) {
                        tempMarker.map = nil;
                        [self.arrMarkers removeObject:tempMarker];
                    }
                }
                
                [self.arrMain removeObjectAtIndex:0];
                
            }
            
        }
        
        [self createPointsWithOldMarkers:markersToRemoveFromMap];
        [self createPointsForClusters:arrClusters inventory:NO];
        
        // Prematurely remove clusters
        for (GMSMarker *marker in markersToRemoveFromMap) {
            if ([[marker.userData valueForKey:@"isCluster"] boolValue])
                marker.map = nil;
        }
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            for (GMSMarker *marker in markersToRemoveFromMap) {
                marker.map = nil;
            }
        }];
        [CATransaction setAnimationDuration:.350];
        
        for (GMSMarker *marker in markersToRemoveFromMap) {
            if (![[marker.userData valueForKey:@"isCluster"] boolValue]) {
                int _id = [[marker.userData valueForKey:@"id"] intValue];
                GMSMarker *cluster = [self clusterForReport:_id withArrayOfMarkers:self.arrMarkers];
                
                marker.position = cluster.position;
                marker.opacity = 0;
            }
        }
        
        [CATransaction commit];
        
        //[self removeMarkers:markersToRemoveFromMap exceptFor:self.arrMarkers];
    });
}

- (void)didReceiveError:(NSError *)error data:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utilities alertWithServerError];
        _isReportsLoading = NO;
    });
}

- (void)createPointsForClusters:(NSArray *)clusters inventory:(BOOL)inv {
    for (NSDictionary *cluster in clusters) {
        /*BOOL passesCategoryValidation = NO;
        
        if (self.arrFilterIDs.count > 0) {
            NSNumber* numberId = [cluster valueForKey:@"category_id"];
            
            if ([numberId isKindOfClass:[NSNull class]] || [self.arrFilterIDs containsObject:numberId])
                passesCategoryValidation = YES;
        }
        else
            passesCategoryValidation = YES;
        
        if(!passesCategoryValidation)
            continue;*/
        
        float lat = [[[cluster valueForKeyPath:@"position"] objectAtIndex:0] floatValue];
        float lon = [[[cluster valueForKeyPath:@"position"] objectAtIndex:1] floatValue];
        
        GMSMarker* marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(lat, lon);
        marker.map = self.mapView;
    
        UIImage* img = [Utilities iconForCluster:cluster inventory:inv];
        img = [Utilities imageWithImage:img scaledToSize:CGSizeMake(img.size.width/2, img.size.height/2)];
        marker.icon = img;
        marker.userData = @{ @"isCluster": @YES, @"reports_ids": [cluster valueForKey:@"items_ids"] };
        
        [self.arrMarkers addObject:marker];
    }
}

- (BOOL)markerPassesValidation:(NSDictionary*)dict
{
    /*BOOL passesCategoryValidation = NO;
    BOOL passesDaysValidation = NO;
    BOOL passesStatusValidation = NO;
    
    if (self.arrFilterIDs.count > 0) {
        
        int intId = [[dict valueForKey:@"category_id"]intValue];
        NSNumber *numberId = [NSNumber numberWithInt:intId];
        
        if ([self.arrFilterIDs containsObject:numberId])
            passesCategoryValidation = YES;
    }
    else
        passesCategoryValidation = YES;
    
    if(self.statusToFilterId != 0)
    {
        int statusId = [[dict  valueForKey:@"status_id"]intValue];
        if(statusId == self.statusToFilterId)
            passesStatusValidation = YES;
    }
    else
        passesStatusValidation = YES;
    
    if(self.isDayFilter)
    {
        int daysPassed = [Utilities calculateDaysPassed:[dict valueForKey:@"created_at"]];
        
        if (self.dayFilter >= daysPassed)
        {
            passesDaysValidation = YES;
        }
    }
    else
        passesDaysValidation = YES;
    
    return passesCategoryValidation && passesDaysValidation && passesStatusValidation;*/
    
    return YES;
}

- (void)createPointsWithOldMarkers:(NSArray*)markers {
    NSMutableArray* changes = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in self.arrMain) {
        GMSMarker* marker;
    
        if([self markerPassesValidation:dict])
        {
            marker = [self setLocationWithCoordinate:dict];
        }
        else
        {
            continue;
        }
        
        int _id = [[dict valueForKey:@"id"] intValue];
        if (![self arrayOfMarkers:markers hasReport:_id]) {
//            CLLocationCoordinate2D pos = marker.position;
            GMSMarker* nearestCluster = [self clusterForReport:_id withArrayOfMarkers:markers];
            
            NSDictionary* changeDict = @{
                                         @"marker": marker,
                                         @"fromLat": @(nearestCluster.position.latitude),
                                         @"fromLon": @(nearestCluster.position.longitude),
                                         @"toLat": @(marker.position.latitude),
                                         @"toLon": @(marker.position.longitude),
                                         @"fromAlpha": @(0.0f),
                                         @"toAlpha": @(1.0f)
                                         };
            
            if(nearestCluster)
                [changes addObject:changeDict];
        }
    }
    
    for(NSDictionary* changeDict in changes)
    {
        GMSMarker* marker = [changeDict valueForKey:@"marker"];
        marker.position = CLLocationCoordinate2DMake([[changeDict valueForKey:@"fromLat"] floatValue], [[changeDict valueForKey:@"fromLon"] floatValue]);
        marker.opacity = [[changeDict valueForKey:@"fromAlpha"] floatValue];
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:.350];
    for(NSDictionary* changeDict in changes)
    {
        GMSMarker* marker = [changeDict valueForKey:@"marker"];
        marker.position = CLLocationCoordinate2DMake([[changeDict valueForKey:@"toLat"] floatValue], [[changeDict valueForKey:@"toLon"] floatValue]);
        marker.opacity = [[changeDict valueForKey:@"toAlpha"] floatValue];
    }
    [CATransaction commit];
    
    if (self.isGoToReportDetail) {
        
        for (GMSMarker *marker in self.arrMarkers) {
            NSDictionary *dict = marker.userData;
            if ([[dict valueForKey:@"id"]intValue] == self.idCreatedReport) {
                [self gotoDetail:marker];
            }
        }
        self.isGoToReportDetail = NO;
    }
    
}

#pragma mark - Get Inventory

- (double)mtorad:(double)x {
    return x * M_PI / (double)180;
}

- (double)getDistance:(CLLocationCoordinate2D)p1 p2:(CLLocationCoordinate2D)p2 {
    double R = 6378137; // Earth’s mean radius in meter
    double dLat = [self mtorad:p2.latitude - p1.latitude];
    double dLong = [self mtorad:p2.longitude - p1.longitude];
    double a = sin(dLat / 2) * sin(dLat / 2) +
    cos([self mtorad:p1.latitude]) * cos([self mtorad:p1.longitude]) *
    sin(dLong / 2) * sin(dLong / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double d = R * c;
    
    return d; // returns the distance in meter
}

- (void)getIventoryPoints {
    if ([Utilities isInternetActive]) {
        
        CGPoint point = self.mapView.center;
        point.y -= 60;
        self.currentCoord = [self.mapView.projection coordinateForPoint:point];
        
        _isInventoryLoading = YES;
        
        int radius = self.mapView.camera.zoom;
        radius = 21 - radius;
        if ([Utilities isIpad]) {
            radius = radius * 2000;
        } else {
            radius = radius * 1400;
        }
        
        GMSVisibleRegion visibleRegion = [[self.mapView projection] visibleRegion];
        double distance = [self getDistance:visibleRegion.nearRight p2:visibleRegion.nearLeft];
        
        [self.serverOperationsInventory CancelRequest];
        self.serverOperationsInventory = nil;
        
        self.serverOperationsInventory = [[ServerOperations alloc]init];
        [self.serverOperationsInventory setTarget:self];
        [self.serverOperationsInventory setAction:@selector(didReceiveInventoryData:operation:)];
        [self.serverOperationsInventory setActionErro:@selector(didReceiveIventoryError:data:)];
        
        if (self.arrFilterInventoryIDs.count == 0) {
            [self.serverOperationsInventory getItemsForPosition:self.currentCoordinate.latitude
                                                      longitude:self.currentCoordinate.longitude
                                                         radius:distance
                                                           zoom:self.mapView.camera.zoom];
        } else {
            [self.serverOperationsInventory getItemsForPosition:self.currentCoordinate.latitude
                                                      longitude:self.currentCoordinate.longitude
                                                         radius:distance
                                                           zoom:self.mapView.camera.zoom
                                                    categoryIds:self.arrFilterInventoryIDs];
        }
    }
}

- (void)didReceiveInventoryData:(NSData*)data operation:(TIRequestOperation*)operation {
    self.isInventoryLoading = NO;
    
    if (self.isNoInventories)
        return;
    
    [self clearMap];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *arr = [dict valueForKey:@"items"];
    
    for (NSDictionary *dict in arr) {
        if (![self.arrMainInventory containsObject:dict]) {
            [self.arrMainInventory addObject:dict];
        }
    }
    
    NSArray *clusters = [dict valueForKey:@"clusters"];
    
    [self createInventoryPoints];
    [self createPointsForClusters:clusters inventory:YES];
}

- (void)didReceiveIventoryError:(NSError*)error data:(NSData*)data {
    [Utilities alertWithServerError];
    self.isInventoryLoading = NO;
}

- (void)createInventoryPoints {
    for (NSDictionary *dict in self.arrMainInventory) {
        if (self.arrFilterInventoryIDs.count > 0) {
            int intId = [[dict valueForKey:@"inventory_category_id"]intValue];
            NSNumber *numberId = [NSNumber numberWithInt:intId];
            if ([self.arrFilterInventoryIDs containsObject:numberId]) {
                [self setLocationWithCoordinate:dict];
            }
        } else if (!self.isFromFilter) {
            if (!self.isNoInventories) {
                [self setLocationWithCoordinate:dict];
            }
        }
    }
}

- (void)getMarkersForLocation:(CLLocationCoordinate2D)location {
    self.currentCoordinate = location;
    
    [self getPoints];
    [self getIventoryPoints];
}

- (GMSMarker*)setMarkerInventoryWithCoordinate:(CLLocationCoordinate2D)coordinate
                                 snippet:(NSString*)snippet
                               draggable:(BOOL)draggable
                                    type:(int)type
                                userData:(NSDictionary *)dict {
    NSDictionary *catDict = [UserDefaults getInventoryCategory:[[dict valueForKey:@"inventory_category_id"]intValue]];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    marker.title =  [catDict valueForKey:@"title"];
    //    marker.snippet = snippet;
    marker.draggable = draggable;
    marker.userData = dict;
    [marker setInfoWindowAnchor:CGPointMake(0.4, 0.1)];
    [marker setAppearAnimation:kGMSMarkerAnimationNone];
    
    UIImage *img;
    if([[catDict valueForKey:@"plot_format"] isEqualToString:@"marker"])
        img = [UIImage imageWithData:[catDict valueForKey:@"markerData"]];
    else
        img = [UIImage imageWithData:[catDict valueForKey:@"pinData"]];
    
    img = [Utilities imageWithImage:img scaledToSize:CGSizeMake(img.size.width/2, img.size.height/2)];
    marker.icon = img;
    
    int markerId = [[marker.userData valueForKey:@"id"]intValue];
    
    for (GMSMarker *tempMarker in self.arrMarkers) {
        int tempMarkerId = [[tempMarker.userData valueForKey:@"id"]intValue];
        if (tempMarkerId == markerId) {
            return tempMarker;
        }
    }
    
    marker.map = self.mapView;
    [self.arrMarkers addObject:marker];
    
    return marker;
}

#pragma mark - Get Inventory List

- (void)getInventoryListForId:(int)idCategory {
    if ([Utilities isInternetActive]) {
        [self.serverOperationsInventoryList CancelRequest];
        self.serverOperationsInventoryList = nil;
        
        self.serverOperationsInventoryList = [[ServerOperations alloc]init];
        [self.serverOperationsInventoryList setTarget:self];
        [self.serverOperationsInventoryList setAction:@selector(didReceiveData:)];
        [self.serverOperationsInventoryList setActionErro:@selector(didReceiveError:data:)];
        [self.serverOperationsInventoryList getInventoryForIdCategory:idCategory];
    }
}

- (void)didReceiveInventoryListData:(NSData *)data {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.arrMain = [[NSMutableArray alloc]initWithArray:[dict valueForKey:@"items"]];
    [self createInventoryPoints];
}

- (void)didReceiveInventoryListError:(NSError*)error data:(NSData*)data {
    [Utilities alertWithServerError];
}

#pragma mark - Map Handle

- (GMSMarker *)setLocationWithCoordinate:(NSDictionary *)dict {
    
    NSString *latStr = [dict valueForKeyPath:@"position.latitude"];
    
    NSString *lngStr = [dict valueForKeyPath:@"position.longitude"];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latStr.floatValue, lngStr.floatValue);
    
    if ([dict valueForKey:@"inventory_category_id"]) {
        return [self setMarkerInventoryWithCoordinate:coord snippet:nil draggable:NO type:[[dict valueForKey:@"inventory_category_id"]intValue] userData:dict];
    } else {
        return [self setMarkerWithCoordinate:coord snippet:nil draggable:NO type:[[dict valueForKey:@"category_id"]intValue] userData:dict];
        
    }
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    if([[[marker userData] valueForKey:@"isCluster"] boolValue])
        return nil;
    
    InfoWindow *view = [[InfoWindow alloc]initWithNibName:@"InfoWindow" bundle:nil];
    [view.view setFrame:CGRectMake(0, 0, 219, 57)];
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"map_popover_inteiro"]];
    [view.view addSubview:img];
    [view.view sendSubviewToBack:img];
    view.lbltitle.text = marker.title;
    
    return view.view;
}

- (GMSMarker*)setMarkerWithCoordinate:(CLLocationCoordinate2D)coordinate
                        snippet:(NSString*)snippet
                      draggable:(BOOL)draggable
                           type:(int)type
                       userData:(NSDictionary*)dict{
    
    
    NSDictionary *catDict = [UserDefaults getCategory:[[dict valueForKey:@"category_id"]intValue]];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    marker.title =  [catDict valueForKey:@"title"];
    //    marker.snippet = snippet;
    marker.draggable = draggable;
    marker.userData = dict;
    [marker setInfoWindowAnchor:CGPointMake(0.4, 0.1)];
    [marker setAppearAnimation:kGMSMarkerAnimationNone];
    
    UIImage* img;
    
    NSString* iconId = [NSString stringWithFormat:@"marker_category_%i", [[dict valueForKey:@"category_id"] intValue]];
    UIImage* cachedImage = [[ImageCache defaultCache] imageWithName:iconId];
    if (cachedImage)
        img = cachedImage;
    else {
        img = [UIImage imageWithData:[catDict valueForKey:@"markerData"]];
        img = [Utilities imageWithImage:img scaledToSize:CGSizeMake(img.size.width/2, img.size.height/2)];
    }
    
    marker.icon = img;
    
    int markerId = [[marker.userData valueForKey:@"id"]intValue];
    
    for (GMSMarker *tempMarker in self.arrMarkers) {
        int tempMarkerId = [[tempMarker.userData valueForKey:@"id"]intValue];
        if (tempMarkerId == markerId) {
            return tempMarker;
        }
    }
    marker.map = self.mapView;
    [self.arrMarkers addObject:marker];
    
    return marker;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    if ([[[marker userData] valueForKey:@"isCluster"] boolValue]) {
        GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:marker.position.latitude
                                                                longitude:marker.position.longitude
                                                                     zoom:self.mapView.camera.zoom + 1];
        
        [self.mapView animateToCameraPosition:camera];
        [self mapView:mapView didChangeCameraPosition:camera];
        
        return NO;
    }
    
    self.isMoving = YES;
    
    return NO;
}


- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    [self gotoDetail:marker];
}

- (void)gotoDetail:(GMSMarker*)marker {
    
    NSDictionary *dict = marker.userData;
    
    if (![dict valueForKey:@"inventory_category_id"]) {
        
        NSString *nibName = nil;
        if ([Utilities isIpad]) {
            nibName = @"PerfilDetailViewController_iPad";
        } else {
            nibName = @"PerfilDetailViewController";
        }
        
        PerfilDetailViewController *perfilDetailVC = [[PerfilDetailViewController alloc]initWithNibName:nibName bundle:nil];
        perfilDetailVC.isFromExplore = YES;
        perfilDetailVC.dictMain = marker.userData;
        perfilDetailVC.thatStoryboard = self.storyboard;
        
        BOOL animated;
        
        if (self.isGoToReportDetail) {
            animated = NO;
        } else
            animated = YES;
        
        [self.navigationController pushViewController:perfilDetailVC animated:YES];
    } else {
        ListExploreViewController *listVC = [[ListExploreViewController alloc]initWithNibName:@"ListExploreViewController" bundle:nil];
        listVC.isColeta = YES;
        listVC.strTitle = marker.title;
        listVC.dictMain = marker.userData;
        
        [self.navigationController pushViewController:listVC animated:YES];
    }
    
}

- (void)buildDetail:(NSDictionary*)dict {
    if (![self.navigationController.visibleViewController isKindOfClass:[ExploreViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    NSString *latStr = [dict valueForKeyPath:@"position.latitude"];
    NSString *lngStr = [dict valueForKeyPath:@"position.longitude"];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latStr.floatValue, lngStr.floatValue);
    
    self.currentCoordinate = coord;
    
    self.isFromSolicit = YES;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentCoordinate.latitude
                                                            longitude:self.currentCoordinate.longitude
                                                                 zoom:16];
    
    self.mapView.camera = camera;
        
    if (![dict valueForKey:@"inventory_category_id"]) {

        NSString *nibName = nil;
        if ([Utilities isIpad]) {
            nibName = @"PerfilDetailViewController_iPad";
        } else {
            nibName = @"PerfilDetailViewController";
        }
        
        PerfilDetailViewController *perfilDetailVC = [[PerfilDetailViewController alloc]initWithNibName:nibName bundle:nil];
        perfilDetailVC.isFromExplore = YES;
        perfilDetailVC.dictMain = dict;
        perfilDetailVC.thatStoryboard = self.storyboard;
        perfilDetailVC.exploreVC = self;
        
        BOOL animated;
        
        if (self.isGoToReportDetail) {
            animated = NO;
        } else
            animated = YES;
        
        perfilDetailVC.navCtrl = self.navigationController;
        [perfilDetailVC viewWillAppear:YES];

        [self.navigationController pushViewController:perfilDetailVC animated:YES];
    } else {
        ListExploreViewController *listVC = [[ListExploreViewController alloc]init];
        listVC.isColeta = YES;
        listVC.dictMain = dict;

        [self.navigationController pushViewController:listVC animated:YES];
    }
}

- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker {
    self.currentMarker = marker;
    self.currentCoordinate = marker.position;
}

- (void)setPositionMarkerForSearch {
    
    CLLocationCoordinate2D location = self.currentCoordinate;
    location.latitude -= 0.001;
    self.markerSearch = [GMSMarker markerWithPosition:location];
    [self.markerSearch setTappable:NO];
    self.markerSearch.map = self.mapView;
}

- (void)requestWithNewPosition {
    if (!self.isFromSolicit) {
        CGPoint point = self.mapView.center;
        point.y -= 60;
        self.currentCoordinate = [self.mapView.projection coordinateForPoint:point];
    }
    
    self.isFromSolicit = NO;
    
    self.boundsCurrent = [[GMSCoordinateBounds alloc]
                                   initWithRegion: self.mapView.projection.visibleRegion];
    
    if (!_isInventoryLoading && !_isNoInventories)[self getIventoryPoints];
    if (!_isReportsLoading && !_isNoReports)[self getPoints];
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(mapMovementEnd) object:nil];
    
    //[self mapMovementEnd];
    if (!self.isMoving) {
        [self performSelector:@selector(mapMovementEnd) withObject:nil afterDelay:0.15];
    }
}

- (void)mapMovementEnd {
    self.isMoving = NO;
    //    [self.mapView clear];
    
    [self getIventoryPoints];
    [self getPoints];
}

#pragma mark - Search Bar delegates

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    [self convertButtonTitle:nil toTitle:@"Cancelar" inView:searchBar];
    [searchBar setNeedsLayout];
    [searchBar layoutIfNeeded];
    
    if (!self.searchTable) {
        
        self.searchTable = [[SearchTableViewController alloc]initWithNibName:@"SearchTableViewController" bundle:nil];
        self.searchTable.explorerView = self;
        self.searchTable.isExplore = YES;
        
        if ([Utilities isIpad]) {
            [self.searchTable.view setFrame:CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y + self.searchBar.frame.size.height + 10, self.searchTable.view.frame.size.width, self.searchTable.view.frame.size.height)];
        } else {
            [self.searchTable.view setFrame:self.view.bounds];
            [self.searchTable.view setBackgroundColor:[Utilities colorGrayLight]];
            [self.searchTable.tableView setContentInset:UIEdgeInsetsMake(80, 0, 0, 0)];
            [self.searchTable.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(80, 0, 0, 0)];
            
        }
        
        [self.searchTable.view.layer setCornerRadius:5];
        [self.searchTable.view.layer setShadowOffset:CGSizeMake(0, 2)];
        [self.searchTable.view.layer setShadowColor:[[UIColor blackColor]CGColor]];
        [self.view addSubview:self.searchTable.view];
        
        [self.view bringSubviewToFront:self.imgSearchBox];
        [self.view bringSubviewToFront:self.searchBar];
    }
    
    if (![Utilities isIpad]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self moveSearchBarIsTop:YES];
    }
    
    [self.searchTable.view setHidden:NO];
    [self.searchTable.view setAlpha:0];
    [UIView animateWithDuration:0.7 animations:^{
        [self.searchTable.view setAlpha:1];
    }];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    //[self.arrFilterIDs removeAllObjects];
    //[self.arrFilterInventoryIDs removeAllObjects];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.searchTable.view setHidden:YES];
    
    if (![Utilities isIpad]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self moveSearchBarIsTop:NO];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (self.markerSearch) {
        self.markerSearch.map = nil;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(requestAddresses) withObject:nil afterDelay:0.3];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchTable getLocationWithString:searchBar.text andLocation:self.boundsCurrent];
}

- (void)requestAddresses {
    [self.searchTable getLocationWithString:self.searchBar.text andLocation:self.boundsCurrent];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    [searchBar setText:@""];
    
    [self.searchTable clearTable];
    
    [self.searchTable.view setHidden:YES];
    
    if (![Utilities isIpad]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self moveSearchBarIsTop:NO];
    }
}

@end
