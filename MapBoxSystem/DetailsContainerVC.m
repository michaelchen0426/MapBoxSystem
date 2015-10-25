//
//  DetailsContainerVC.m
//  MapBoxSystem
//
//  Created by Michael Chen on 19/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import "DetailsContainerVC.h"

@interface DetailsContainerVC ()

@end

@implementation DetailsContainerVC{
    NSInteger index_now;
    NSInteger total_length;
}
@synthesize routes;
@synthesize roadName_Label;
@synthesize Length_Lab;
@synthesize Speed_Label;
@synthesize trafficCondition_Label;
@synthesize direction_Label;
@synthesize time_Label;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"DetailsContainerVC viewDidLoad");
    index_now=0;
    total_length=[routes count];
    roadName_Label.text=routes[index_now][1];
    Length_Lab.text=routes[index_now][5];
    time_Label.text=[[NSString alloc] initWithFormat:@"%@ s", [routes[index_now][4] stringValue]];
    direction_Label.text=routes[index_now][6];
    Speed_Label.text=routes[index_now][15];
    trafficCondition_Label.text=routes[index_now][18];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)resetContent{
    total_length=[routes count];
    if ([routes[index_now][1] length]>1) {
        roadName_Label.text=routes[index_now][1];
    }else{
        roadName_Label.text=@"UnKnown";
    }
    
    Length_Lab.text=routes[index_now][5];
    time_Label.text=[[NSString alloc] initWithFormat:@"%@ s", [routes[index_now][4] stringValue]];
    direction_Label.text=routes[index_now][6];
    Speed_Label.text=routes[index_now][15];
    if ([routes[index_now][18] isEqualToString:@"-1"]) {
        trafficCondition_Label.text=@"UnKnown";
    }else{
        trafficCondition_Label.text=routes[index_now][18];
    }
   
}
- (IBAction)gotoNext:(id)sender{
    //NSLog(@"DetailsContainerVC gotoNext");
    if (index_now<total_length-1) {
        index_now++;
        [_delegate nextDetail:index_now];
        [self resetContent];
    }
    
}
- (IBAction)gotoBefore:(id)sender{
    //NSLog(@"DetailsContainerVC gotoNext");
    if (index_now>0) {
        index_now--;
        [_delegate beforeDetail:index_now];
        [self resetContent];
    }
    
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
