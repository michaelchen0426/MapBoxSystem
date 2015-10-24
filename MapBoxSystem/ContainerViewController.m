//
//  ContainerViewController.m
//  MapBoxSystem
//
//  Created by Michael Chen on 19/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *Start_Label;
@property (weak, nonatomic) IBOutlet UILabel *End_Label;
@property (weak, nonatomic) IBOutlet UILabel *Dis_label;
@property (weak, nonatomic) IBOutlet UILabel *Time_Label;
@property (weak, nonatomic) IBOutlet UILabel *Traffic_con_Label;
@property (weak, nonatomic) IBOutlet UIButton *Background_Button;

@end

@implementation ContainerViewController
@synthesize routes;
@synthesize summary_route;
@synthesize bad_traffic_num;
@synthesize Start_Label;
@synthesize End_Label;
@synthesize Dis_label;
@synthesize Time_Label;
@synthesize Traffic_con_Label;
- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"ContainerViewController %@",routes);
    // Do any additional setup after loading the view.
    [self printRoute];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)printRoute{
    NSLog(@"ContainerViewController printRoute %@",summary_route);
}
-(void)setInfo{
    NSLog(@"ContainerViewController setInfo %@",summary_route);
    
    Start_Label.text=[summary_route objectForKey:@"start_point"];
    End_Label.text=[summary_route objectForKey:@"end_point"];
    NSString *dis_str=[[summary_route objectForKey:@"total_distance"] stringValue];
    Dis_label.text=[[NSString alloc] initWithFormat:@"%@ m", dis_str];
    NSString *time_str=[[summary_route objectForKey:@"total_time"] stringValue];
    Time_Label.text=[[NSString alloc] initWithFormat:@"%@ s", time_str];
    if (bad_traffic_num>0) {
        Traffic_con_Label.text=[[NSString alloc] initWithFormat:@"There are %ld routes which traffic is bad!", (long)bad_traffic_num];
        Traffic_con_Label.textColor=[UIColor redColor];
        Traffic_con_Label.font= [UIFont boldSystemFontOfSize:13.0f];
    }else{
        Traffic_con_Label.text=[[NSString alloc] initWithFormat:@"No routes traffic is bad."];
        Traffic_con_Label.textColor=[UIColor greenColor];
        Traffic_con_Label.font= [UIFont boldSystemFontOfSize:13.0f];
    }
    NSLog(@"ContainerViewController setInfo End!");
}
-(IBAction)intoDetails:(id)sender{
    //NSLog(@"Touch Button and enter into intoDetails");
    [_delegate enterDetails];
    //[self performSegueWithIdentifier:@"Details" sender:self];
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
