//
//  DetailsViewController.m
//  MapBoxSystem
//
//  Created by Michael Chen on 19/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

//
//  DetailsViewController.m
//  NavigationSystemPlus
//
//  Created by Michael Chen on 18/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import "DetailsViewController.h"
#import "DetailsContainerVC.h"

@interface DetailsViewController ()
@property (nonatomic, weak) DetailsContainerVC *detailsContainerVC;
@end

@implementation DetailsViewController{
    double start_lon,start_lat,end_lon,end_lat;
    CLLocationCoordinate2D position_start;
    CLLocationCoordinate2D position_end;
    NSInteger index_now;
    NSInteger total_length;
    NSUInteger coordinatesCount;
    UIEdgeInsets paddingInsets;
    NSString *traffic_con;
}
@synthesize routes;
@synthesize route_points;

- (void)viewDidLoad {
    [super viewDidLoad];
    index_now=0;
    // Do any additional setup after loading the view.
    //NSLog(@"DetailsViewController viewdidload routes: %@",routes);
    total_length=[routes count];
    
    paddingInsets = UIEdgeInsetsMake(14.0, 14.0, 14.0, 14.0);
    coordinatesCount=[route_points count];
    self.MapBoxView.delegate=self;
    [self nextDetail:index_now];

    //self.GoogleMapView.tag=101;
    //[MapView addSubview:mapView_];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        NSLog(@"embedContainer segure execute");
        self.detailsContainerVC = segue.destinationViewController;
        self.detailsContainerVC.routes=routes;
        [self.detailsContainerVC setDelegate:self];
    }
}

- (void)nextDetail:(NSInteger) next_index{
    //[mapView_ removeFromSuperview];
    [self.MapBoxView removeAnnotations:self.MapBoxView.annotations];
    
    start_lat=[routes[next_index][9] doubleValue];
    start_lon=[routes[next_index][10] doubleValue];
    end_lat=[routes[next_index][11] doubleValue];
    end_lon=[routes[next_index][12] doubleValue];
    traffic_con=routes[next_index][18];
    NSLog(@"traffic_con is %@",traffic_con);
    position_start.latitude=start_lat;
    position_start.longitude=start_lon;
    position_end.latitude=end_lat;
    position_end.longitude=end_lon;
    NSLog(@"DetailsViewController nextDetail %f,%f,%f,%f",start_lon,start_lat,end_lon,end_lat);
    self.MapBoxView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(start_lat, start_lon),
                                                         CLLocationCoordinate2DMake(end_lat, end_lon));
    //[self.MapBoxView setCenterCoordinate:CLLocationCoordinate2DMake((start_lat+end_lat)/2, (start_lon+end_lon)/2)
                                //animated:YES];
    [self.MapBoxView setVisibleCoordinateBounds:bounds edgePadding:paddingInsets animated:NO];
    
    
    /*
     self.GoogleMapView = [GMSMapView mapWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-container_height)  camera:camera];
     */
    
    
    //Set Marker
    MGLPointAnnotation *start_marker = [[MGLPointAnnotation alloc] init];
    start_marker.coordinate = CLLocationCoordinate2DMake(start_lat, start_lon);
    [self.MapBoxView addAnnotation:start_marker];
    MGLPointAnnotation *end_marker = [[MGLPointAnnotation alloc] init];
    end_marker.coordinate = CLLocationCoordinate2DMake(end_lat, end_lon);
    [self.MapBoxView addAnnotation:end_marker];
    
    
    NSInteger start_position=[routes[next_index][16] integerValue];
    NSInteger end_position=[routes[next_index][17] integerValue];
    CLLocationCoordinate2D allcoordinates[coordinatesCount];
    CLLocationCoordinate2D specific_coordinates[end_position-start_position+1];
    // Create a coordinates array, sized to fit all of the coordinates in the line.
    // This array will hold the properly formatted coordinates for our MGLPolyline.
    
    // Iterate over `rawCoordinates` once for each coordinate on the line
    for (NSUInteger index = 0; index < coordinatesCount; index++)
    {
        // Get the individual coordinate for this index
        
        
        // GeoJSON is "longitude, latitude" order, but we need the opposite
        CLLocationDegrees lat = [route_points[index][0] doubleValue];
        CLLocationDegrees lng = [route_points[index][1] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
        if (index>=start_position&&index<=end_position) {
            specific_coordinates[index-start_position]=coordinate;
        }
        // Add this formatted coordinate to the final coordinates array at the same index
        allcoordinates[index] = coordinate;
    }
    
    
    
    
    //Draw the whole Polyline
    MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:allcoordinates count:coordinatesCount];
    polyline.title=@"Whole_Line";
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [weakSelf.MapBoxView addAnnotation:polyline];
                   });
    
    // Draw Specific Polyline
    MGLPolyline *polyline_specific = [MGLPolyline polylineWithCoordinates:specific_coordinates count:end_position-start_position+1];
    if ([traffic_con isEqualToString:@"null"]) {
        polyline_specific.title=@"Specific_Line";
    }else if([traffic_con isEqualToString:@"TRAFFIC GOOD"]) {
        polyline_specific.title=@"Good_line";
    }else if([traffic_con isEqualToString:@"TRAFFIC AVERAGE"]) {
        polyline_specific.title=@"Average_line";
    }else if([traffic_con isEqualToString:@"TRAFFIC BAD"]) {
        polyline_specific.title=@"Bad_line";
    }
    //NSLog(@"polyline_specific.title is %@",polyline_specific.title);
    __weak typeof(self) weakSelf_2 = self;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [weakSelf_2.MapBoxView addAnnotation:polyline_specific];
                   });
    //[MapView viewWithTag:101]=mapView_;
    //[MapView addSubview:mapView_];
    
}
- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation
{
    // Set the stroke color for shape annotations
    // ... but give our polyline a unique color by checking for its `title` property
    if ([annotation.title isEqualToString:@"Specific_Line"])
    {
        // Mapbox cyan
        return [UIColor colorWithRed:59.0f/255.0f green:178.0f/255.0f blue:208.0f/255.0f alpha:1.0f];
    }
    
    else if([annotation.title isEqualToString:@"Good_line"]){
        return [UIColor greenColor];
    }
    else if([annotation.title isEqualToString:@"Average_line"]){
        return [UIColor yellowColor];
    }
    else if([annotation.title isEqualToString:@"Bad_line"]){
        return [UIColor redColor];
    }
     
    else
    {
        return [UIColor blueColor];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

