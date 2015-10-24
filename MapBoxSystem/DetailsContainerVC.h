//
//  DetailsContainerVC.h
//  MapBoxSystem
//
//  Created by Michael Chen on 19/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol DetailsContainerVCDelegate <NSObject>

// 代理传值方法
- (void)nextDetail:(NSInteger) next_index;

@end
@interface DetailsContainerVC : UIViewController
@property (strong,nonatomic) NSMutableArray *routes;

-(void)resetContent;
- (IBAction)gotoNext:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *roadName_Label;
@property (weak, nonatomic) IBOutlet UILabel *Length_Lab;
@property (weak, nonatomic) IBOutlet UILabel *Speed_Label;
@property (weak, nonatomic) IBOutlet UILabel *trafficCondition_Label;
@property (weak, nonatomic) IBOutlet UILabel *direction_Label;
@property (weak, nonatomic) IBOutlet UILabel *time_Label;
@property (weak, nonatomic) id<DetailsContainerVCDelegate> delegate;
@end
