//
//  ContainerViewController.h
//  MapBoxSystem
//
//  Created by Michael Chen on 19/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ContainerViewControllerDelegate <NSObject>

// 代理传值方法
- (void)enterDetails;
- (void)enterDetailsTableView;

@end
@interface ContainerViewController : UIViewController
@property (strong,nonatomic) NSMutableArray *routes;
@property (strong,nonatomic) NSDictionary *summary_route;
@property (assign,nonatomic) NSInteger bad_traffic_num;
- (void)printRoute;
-(void)setInfo;
- (IBAction)intoDetails:(id)sender;
- (IBAction)showDetailsInTable:(id)sender;
@property (weak, nonatomic) id<ContainerViewControllerDelegate> delegate;
@end
