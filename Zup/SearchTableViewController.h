//
//  SearchTableViewController.h
//  Zup
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@class SolicitacaoMapViewController;
@class ExploreViewController;

@interface SearchTableViewController : UITableViewController {
    NSDictionary *dict;
}

@property (nonatomic, retain) NSArray *arrLocations;
@property (nonatomic, retain) SolicitacaoMapViewController *solicitacaoView;
@property (nonatomic, retain) ExploreViewController *explorerView;
@property (nonatomic) BOOL isExplore;

- (void)getLocationWithLoction:(CLLocationCoordinate2D)location;
- (void)getLocationWithString:(NSString*)strKey andLocation:(GMSCoordinateBounds*)coord;
- (void)clearTable;

@end
