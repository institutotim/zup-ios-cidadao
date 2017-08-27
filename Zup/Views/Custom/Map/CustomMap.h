//
//  CustomMap.h
//  Zup
//

#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface CustomMap : GMSMapView

- (void)setPositionWithLocation:(CLLocationCoordinate2D)coordinate andCategory:(int)idCategory isReport:(BOOL)isReport;

@end
