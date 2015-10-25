//
//  DetailsTableViewController.m
//  MapBoxSystem
//
//  Created by Michael Chen on 24/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import "DetailsTableViewController.h"
#import "DetailsTableViewCell.h"
@interface DetailsTableViewController ()

@end

@implementation DetailsTableViewController
static BOOL isRegNib = NO;
@synthesize routes;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"DetailsTableViewController  viewDidLoad %lu",(unsigned long)[routes count]);
    isRegNib = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     NSLog(@"DetailsTableViewController  viewDidLoad %lu",(unsigned long)[routes count]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"DetailsTableViewController numberOfRowsInSection %lu",[routes count]-1);
    return [routes count]-1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *detailsTableViewCell = @"DetailsTableViewCell";
    
    // 2. 注册自定义Cell的到TableView中，并设置cell标识符为paperCell
    
    if (!isRegNib) {
        [tableView registerNib:[UINib nibWithNibName:@"DetailsTableViewCell" bundle:nil] forCellReuseIdentifier:detailsTableViewCell];
        isRegNib = YES;
    }
    
    // 3. 从TableView中获取标识符为paperCell的Cell
    DetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailsTableViewCell];
    
    // 4. 设置单元格属性
    [cell initializeCell:routes[indexPath.row][1] trafficCondition:routes[indexPath.row][18]  instructionCode:[routes[indexPath.row][0] integerValue]];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
