//
//  DirectionMainViewController.h
//  MapBoxSystem
//
//  Created by Michael Chen on 19/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ContainerViewController.h"
#import "Mapbox.h"
#import "MBProgressHUD.h"
#import <SVProgressHUD/SVProgressHUD.h>
@interface DirectionMainViewController : UIViewController<MGLMapViewDelegate,ContainerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *MapBoxView;
@property (nonatomic,assign)CLLocationCoordinate2D position_start;

@property (nonatomic,assign)CLLocationCoordinate2D position_end;
- (void)setDirectionsQuery:(NSDictionary *)object withSelector:(SEL)selector
              withDelegate:(id)delegate;
- (void)retrieveDirections:(SEL)sel withDelegate:(id)delegate;
- (void)fetchedData:(NSData *)data withSelector:(SEL)selector
       withDelegate:(id)delegate;
@end
