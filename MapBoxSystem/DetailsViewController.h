//
//  DetailsViewController.h
//  MapBoxSystem
//
//  Created by Michael Chen on 19/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DetailsContainerVC.h"
#import "Mapbox.h"
@interface DetailsViewController : UIViewController<MGLMapViewDelegate,DetailsContainerVCDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *MapBoxView;
@property (strong,nonatomic) NSMutableArray *routes;

@property (strong,nonatomic) NSMutableArray *route_points;

@end
