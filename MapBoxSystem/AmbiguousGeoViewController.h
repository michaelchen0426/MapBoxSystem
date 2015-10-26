//
//  AmbiguousGeoViewController.h
//  MapBoxSystem
//
//  Created by Michael Chen on 26/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCGeocodingService.h"
@interface AmbiguousGeoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UITableView *ambiguousTableView;

@property (strong,nonatomic) NSDictionary *geoResult;
@property (strong,nonatomic) GCGeocodingService *gs_start;
@property (strong,nonatomic) GCGeocodingService *gs_end;
-(void) resetView;
@end
