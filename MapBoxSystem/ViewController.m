//
//  ViewController.m
//  MapBoxSystem
//
//  Created by Michael Chen on 19/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import "ViewController.h"
#import "Mapbox.h"
//#import "MDDirectionService.h"
@interface ViewController ()



@end

@implementation ViewController{
    //NSMutableArray *waypointStrings_;
    //NSMutableArray *route_points;
    MGLUserLocation *userlocation;
    double userLattitude,userLongitude;
}
@synthesize locationManager;
@synthesize myLocation;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    // initialize the map view
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    locationManager.delegate=self;
    userlocation =[[MGLUserLocation alloc] init];
    [locationManager startUpdatingLocation];
    self.MapBoxView.showsUserLocation=YES;
    
    //self.MapBoxView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.MapBoxView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // set the map's center coordinate
    [self.MapBoxView setCenterCoordinate:CLLocationCoordinate2DMake(22.252734, 114.1777)
                            zoomLevel:11
                             animated:NO];
    NSLog(@"User Location: %f,%f",userlocation.coordinate.latitude,userlocation.coordinate.longitude);
   
    /*
    waypointStrings_ = [[NSMutableArray alloc]init];
    NSString *positionString_start = [[NSString alloc] initWithFormat:@"lon_s=22.282999&lat_s=114.137085"];
    //..
    NSString *positionString_end = [[NSString alloc] initWithFormat:@"lon_e=22.421514&lat_e=114.207843"];
    [waypointStrings_ addObject:positionString_start];
    [waypointStrings_ addObject:positionString_end];
    
    NSArray *parameters = [NSArray arrayWithObjects:waypointStrings_,
                           nil];
    NSArray *keys = [NSArray arrayWithObjects: @"waypoints", nil];
    NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                      forKeys:keys];
    MDDirectionService *mds=[[MDDirectionService alloc] init];
    SEL selector = @selector(addDirections:);
    [mds setDirectionsQuery:query
               withSelector:selector
               withDelegate:self];
     */
}

- (IBAction)enterNext:(id)sender{
    [self performSegueWithIdentifier:@"EnterNext" sender:sender];
}
- (IBAction)myLocation:(id)sender{
    
    //NSLog(@"myLocation Coordinate is %f,%f",userLattitude,userLongitude);
    [self.MapBoxView setCenterCoordinate:CLLocationCoordinate2DMake(userLattitude, userLongitude)
                               zoomLevel:15
                                animated:NO];
}
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    NSString *currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 newLocation.coordinate.latitude];

    
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%+.6f",
                                  newLocation.coordinate.longitude];
    
    userLattitude=currentLatitude.doubleValue;
    userLongitude=currentLongitude.doubleValue;
    //NSLog(@"Coordinate is %f,%f",currentLatitude.doubleValue,currentLongitude.doubleValue);
}
/*
- (void)addDirections:(NSDictionary *)json {
 
    //NSLog(@"json is: %@",json);
    route_points= [json objectForKey:@"route_points"];
    //NSLog(@"json is: %@",route_points);
    NSUInteger coordinatesCount = route_points.count;
    
    // Create a coordinates array, sized to fit all of the coordinates in the line.
    // This array will hold the properly formatted coordinates for our MGLPolyline.
    CLLocationCoordinate2D coordinates[coordinatesCount];
    
    // Iterate over `rawCoordinates` once for each coordinate on the line
    for (NSUInteger index = 0; index < coordinatesCount; index++)
    {
        // Get the individual coordinate for this index
        
        
        // GeoJSON is "longitude, latitude" order, but we need the opposite
        CLLocationDegrees lat = [route_points[index][0] doubleValue];
        CLLocationDegrees lng = [route_points[index][1] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
        
        // Add this formatted coordinate to the final coordinates array at the same index
        coordinates[index] = coordinate;
    }
     MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coordinates count:coordinatesCount];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [weakSelf.mapView addAnnotation:polyline];
                   });
    
}
*/
@end