//
//  ExploreViewController.h
//  Zup
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>

#import "FiltrarViewController.h"
#import "SearchTableViewController.h"
#import "GAITrackedViewController.h"

@interface ExploreViewController : GAITrackedViewController <CLLocationManagerDelegate, UISearchBarDelegate, GMSMapViewDelegate>

@property (nonatomic, weak) IBOutlet GMSMapView *mapView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIImageView *imgSearchBox;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *arrMain;
@property (nonatomic, strong) NSMutableArray *arrMainInventory;
@property (nonatomic, strong) NSMutableArray *arrMarkers;
@property (nonatomic, strong) NSMutableArray *arrFilterIDs;
@property (nonatomic, strong) NSMutableArray *arrFilterInventoryIDs;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) NSString *currentInventoryId;

@property (nonatomic, assign) BOOL isFromOtherTab;
@property (nonatomic, assign) BOOL isInventoryLoading;
@property (nonatomic, assign) BOOL isReportsLoading;
@property (nonatomic, assign) BOOL isNoReports;
@property (nonatomic, assign) BOOL isNoInventories;
@property (nonatomic, assign) int statusToFilterId;
@property (nonatomic, assign) BOOL isFromFilter;
@property (nonatomic, assign) BOOL isDayFilter;
@property (nonatomic, assign) BOOL isGoToReportDetail;
@property (nonatomic, assign) int dayFilter;
@property (nonatomic, assign) int idCreatedReport;

- (void)createPoints;
- (void)createInventoryPoints;
- (void)requestWithNewPosition;
- (void)initMap;

- (void)setLocationWithClLocation:(CLLocationCoordinate2D)coordinate zoom:(int)newZoom;
- (void)moveSearchBarIsTop:(BOOL)isTop;
- (void)getInventoryListForId:(int)idCategory;
- (void)getMarkersForLocation:(CLLocationCoordinate2D)location;
- (void)setPositionMarkerForSearch;
- (void)buildDetail:(NSDictionary *)dict;

@end
