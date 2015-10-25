//
//  SubDirectionViewController.m
//  MapBoxSystem
//
//  Created by Michael Chen on 25/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import "SubDirectionViewController.h"
#import "DetailsTableViewController.h"
@interface SubDirectionViewController ()

@property (nonatomic, weak) DetailsTableViewController *detailsTableViewController;
@end

@implementation SubDirectionViewController
@synthesize routes;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"SubDirectionViewController viewDidLoad %lu",(unsigned long)[routes count]);
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"SubDirectionViewController viewWillAppear %lu",(unsigned long)[routes count]);
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        NSLog(@"SubDirectionViewController embedContainer segue execute %lu",(unsigned long)[routes count]);
        self.detailsTableViewController = segue.destinationViewController;
        self.detailsTableViewController.routes=routes;
        
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
