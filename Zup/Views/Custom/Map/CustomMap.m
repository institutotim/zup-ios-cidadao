//
//  CustomMap.m
//  Zup
//

#import "CustomMap.h"

@implementation CustomMap

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPositionWithLocation:(CLLocationCoordinate2D)coordinate andCategory:(int)idCategory isReport:(BOOL)isReport{
    
    NSDictionary *dict = nil;
    if (isReport) {
        dict = [UserDefaults getCategory:idCategory];
    } else {
        dict = [UserDefaults getInventoryCategory:idCategory];
    }
  
    UIImage *imgIcon = [UIImage imageWithData:[dict valueForKey:@"markerData"]];
    imgIcon = [Utilities imageWithImage:imgIcon scaledToSize:CGSizeMake(imgIcon.size.width/2, imgIcon.size.height/2)];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    marker.draggable = NO;
    marker.userData = dict;
    [marker setInfoWindowAnchor:CGPointMake(0.4, 0.1)];
    [marker setAppearAnimation:kGMSMarkerAnimationPop];
    
    if (dict) {
        marker.icon = imgIcon;
    }
    
    marker.Map = self;

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                            longitude:coordinate.longitude
                                                                 zoom:16];
    
    self.camera = camera;
    
}


@end
