//
//  SolicitacaoMapViewController.h
//  Zup
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "SolicitacaoPhotoViewController.h"
#import "SearchTableViewController.h"
#import "GAITrackedViewController.h"

@interface SolicitacaoMapViewController : GAITrackedViewController<CLLocationManagerDelegate, UISearchBarDelegate, GMSMapViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate> {
    GMSMarker *userMarker;
    SolicitacaoPhotoViewController *photoView;
    SearchTableViewController *searchTable;
    UIImage *imageCurrentMarker;
    UIImage *imageInventoryMarker;
    NSString *strCurrentInventoryId;
    GMSMarker *currentInventoryMarker;
    GMSMarker *markerSearch;
    GMSCoordinateBounds *boundsCurrent;

    CustomButton * btFilter;
    UIActivityIndicatorView* activityIndicator;
    
    float zoomCurrent;
    BOOL isEditingNumber;
    BOOL isGettingLocation;
    NSTimer *timerLoadingAddress;
    NSTimer *timerPlaceholder;
    
    BOOL isSearch;
    
    int locationJobId;
    int freeJobId;
    
    BOOL mapCameraChangeIsFromNumberChange;
    BOOL isBoundsOk;
    int boundsValidationJobId;
    
    @public BOOL isCustomNumber;
}

@property (weak, nonatomic) IBOutlet UITextView *tvReferencia;
@property (strong, nonatomic) UIImageView *imageMarkerPositionCenter;
@property (weak, nonatomic) IBOutlet UITextField *tfNumber;
@property (weak, nonatomic) IBOutlet UIView *viewSearchBar;

@property (strong, nonatomic) NSString *catStr;
@property (strong, nonatomic) NSString *catID;
@property (nonatomic, retain) NSDictionary *dictMain;

@property (strong, nonatomic) UIImage *imgIcon;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CustomButton *btNext;

@property (weak, nonatomic) IBOutlet UIView *viewInvalidPosition;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (nonatomic, strong) NSMutableArray *arrMainInventory;
@property (nonatomic, strong) NSMutableArray *arrMarkers;

- (IBAction)btNext:(id)sender;
- (void)setMarkerWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)setLocationWithCoordinate:(CLLocationCoordinate2D)coordinate zoom:(int)zoom;
- (void)moveSearchBarIsTop:(BOOL)isTop;
- (void)getIventoryPoints;
- (void)setPositionMarkerForSearch;
- (void)closeSearchTable;

@end

