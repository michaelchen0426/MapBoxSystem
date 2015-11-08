//
//  ViewController.h
//  MapBoxSystem
//
//  Created by Michael Chen on 19/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mapbox.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController : UIViewController<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MGLMapView *MapBoxView;
@property (nonatomic, strong, readonly) CLLocation *myLocation;
@property(nonatomic,retain) CLLocationManager *locationManager;
- (IBAction)enterNext:(id)sender;
- (IBAction)myLocation:(id)sender;
@end

