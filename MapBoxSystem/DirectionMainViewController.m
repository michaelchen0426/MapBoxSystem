//
//  DirectionMainViewController.m
//  NavigationSystemPlus
//
//  Created by Michael Chen on 17/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import "DirectionMainViewController.h"
#import "MDDirectionService.h"
#import "ContainerViewController.h"
#import "DetailsViewController.h"
#import "SubDirectionViewController.h"

@interface DirectionMainViewController ()
@property (nonatomic, weak) ContainerViewController *containerViewController;
@property (nonatomic, weak) DetailsViewController *detailsViewController;
@property (nonatomic, weak) SubDirectionViewController *subDirectionViewController;
@end

@implementation DirectionMainViewController{
    //GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
    double start_lat,start_lon,end_lat,end_lon;
    NSMutableArray *routes;
    UIEdgeInsets paddingInsets;
    NSString *overview_route;
    NSMutableArray *route_points;
    NSInteger bad_traffic_num;
    BOOL _sensor;
    BOOL _alternatives;
    NSURL *_directionsURL;
    NSArray *_waypoints;
}

@synthesize position_start;
@synthesize position_end;
@synthesize wholeJson;
static NSString *kMDDirectionsURL=@"http://localhost:3000/api/v1/Mapbox?";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    //NSLog(@"%@,%@",startInfo,endInfo);
    NSLog(@"%f,%f,%f,%f",position_start.latitude,position_start.longitude,position_end.latitude,position_end.longitude);
    start_lat=position_start.latitude;start_lon=position_start.longitude;
    end_lat=position_end.latitude; end_lon=position_end.longitude;
    
    /*
     mapView_ = [GMSMapView mapWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-container_height)  camera:camera];
     mapView_.myLocationEnabled = YES;
     
     mapView_.settings.myLocationButton=YES;
     mapView_.delegate = self;
     */
    self.MapBoxView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(start_lat, start_lon),
                                                         CLLocationCoordinate2DMake(end_lat, end_lon));
    paddingInsets = UIEdgeInsetsMake(14.0, 14.0, 14.0, 14.0);
    //[self.MapBoxView setVisibleCoordinateBounds:bounds];
    /*
     [self.MapBoxView setCenterCoordinate:CLLocationCoordinate2DMake((start_lat+end_lat)/2, (start_lon+end_lon)/2)
     zoomLevel:17
     animated:NO];
     */
    [self.MapBoxView setVisibleCoordinateBounds:bounds edgePadding:paddingInsets animated:YES];
    
    self.MapBoxView.delegate=self;
    [SVProgressHUD show];
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showDirectionsStartPosition:position_start EndPosition:position_end];
            [SVProgressHUD dismiss];
        });
         
    //});
    //[self showDirectionsStartPosition:position_start EndPosition:position_end];
    /*
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    */
    
    
    /*
     GMSCoordinateBounds* bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:position_start coordinate:position_start];
     bounds = [bounds includingCoordinate:position_end];
     GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
     [mapView_ moveCamera:update];
     */
    //MapView=mapView_;
    
    //[MapView addSubview:mapView_];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"DirectionMainViewController viewWillAppear %lu",(unsigned long)[routes count]);
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealWithStartString:(NSString*)start EndString:(NSString*)end{
    
    NSArray *array_start = [start componentsSeparatedByString:@","];
    start_lat=[array_start[0] doubleValue];
    start_lon=[array_start[1] doubleValue];
    NSArray *array_end = [end componentsSeparatedByString:@","];
    end_lat=[array_end[0] doubleValue];
    end_lon=[array_end[1] doubleValue];
    NSLog(@"Got coordination is: %f,%f,%f,%f",start_lat,start_lon,end_lat,end_lon);
}

-(void)showDirectionsStartPosition:(CLLocationCoordinate2D)start_point EndPosition:(CLLocationCoordinate2D)end_point{
    MGLPointAnnotation *start_marker = [[MGLPointAnnotation alloc] init];
    start_marker.coordinate = CLLocationCoordinate2DMake(start_lat, start_lon);
    [self.MapBoxView addAnnotation:start_marker];
    MGLPointAnnotation *end_marker = [[MGLPointAnnotation alloc] init];
    end_marker.coordinate = CLLocationCoordinate2DMake(end_lat, end_lon);
    [self.MapBoxView addAnnotation:end_marker];
    
    [waypoints_ addObject:start_marker];
    [waypoints_ addObject:end_marker];

    [self addDirections:wholeJson];
    
}
- (void)addDirections:(NSDictionary *)json {
    //NSLog(@"json is: %@",json);
    routes = [json objectForKey:@"route_instructions"];
    route_points= [json objectForKey:@"route_points"];
    bad_traffic_num=[[json objectForKey:@"Bad_Traffic_Num"] integerValue];
    self.containerViewController.routes=routes;
    self.containerViewController.summary_route=[json objectForKey:@"route_summary"];
    self.containerViewController.bad_traffic_num=bad_traffic_num;
    [self.containerViewController setInfo];
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
                       [weakSelf.MapBoxView addAnnotation:polyline];
                   });
    
    //[weakSelf.MapBoxView addAnnotation:polyline];
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        NSLog(@"embedContainer segue execute");
        self.containerViewController = segue.destinationViewController;
        [self.containerViewController setDelegate:self];
        
    }else if ([segue.identifier isEqualToString:@"Details"]){
        NSLog(@"Details segue execute");
        self.detailsViewController = segue.destinationViewController;
        self.detailsViewController.routes=routes;
        self.detailsViewController.route_points=route_points;
        
    }else if ([segue.identifier isEqualToString:@"DetailsTableView"]){
        NSLog(@"DetailsTableView segue execute: %lu",(unsigned long)[routes count]);
        self.subDirectionViewController = segue.destinationViewController;
        self.subDirectionViewController.routes=routes;
        
    }
}
- (void)enterDetails{
    NSLog(@"Enter enterDetails Method");
    
    [self performSegueWithIdentifier:@"Details" sender:self];
    
}
- (void)enterDetailsTableView{
    [self performSegueWithIdentifier:@"DetailsTableView" sender:self];
}
- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation {
    return nil;
}

// Allow markers callouts to show when tapped
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    return YES;
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





