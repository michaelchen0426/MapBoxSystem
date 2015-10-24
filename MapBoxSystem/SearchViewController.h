//
//  SearchViewController.h
//  MapBoxSystem
//
//  Created by Michael Chen on 19/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;
#import "GCGeocodingService.h"
#import "DirectionMainViewController.h"
#import "HistoryTableViewCell.h"
@interface SearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) GCGeocodingService *gs_start;
@property (strong,nonatomic) GCGeocodingService *gs_end;
@property (strong,nonatomic) NSString *start_text;
@property (strong,nonatomic) NSString *end_text;
-(void)Search;
-(IBAction)touchStart:(id)sender;
-(IBAction)touchEnd:(id)sender;
@end
