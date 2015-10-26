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
#import "AmbiguousGeoViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
@interface SearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) NSString *start_text;
@property (strong,nonatomic) NSString *end_text;
@property (strong,nonatomic) NSDictionary *startDictionary;
@property (strong,nonatomic) NSDictionary *endDictionary;

-(void)Search;
-(IBAction)touchStart:(id)sender;
-(IBAction)touchEnd:(id)sender;
- (void)setDirectionsQuery:(NSDictionary *)object withSelector:(SEL)selector
              withDelegate:(id)delegate;
- (void)retrieveDirections:(SEL)sel withDelegate:(id)delegate;
- (void)fetchedData:(NSData *)data withSelector:(SEL)selector
       withDelegate:(id)delegate;
- (void)callWebAPI;
@end
