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

#import <SVProgressHUD/SVProgressHUD.h>
@interface DirectionMainViewController : UIViewController<MGLMapViewDelegate,ContainerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *MapBoxView;
@property (nonatomic,assign)CLLocationCoordinate2D position_start;
@property (nonatomic,assign)CLLocationCoordinate2D position_end;
@property (strong,nonatomic)NSDictionary *wholeJson;
@property (strong,nonatomic) NSString *startLocation;
@property (strong,nonatomic) NSString *endLocation;
@end
