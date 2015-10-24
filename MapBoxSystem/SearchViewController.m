//
//  SearchViewController.m
//  MapBoxSystem
//
//  Created by Michael Chen on 19/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import "SearchViewController.h"
#import "InputAddressViewController.h"
@import GoogleMaps;
@interface SearchViewController (){
    double start_lat,start_lon,end_lat,end_lon;
    NSArray *history_search_arr;

}
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (weak, nonatomic) IBOutlet UITextField *StartField;
@property (weak, nonatomic) IBOutlet UITextField *EndField;
@end

@implementation SearchViewController
@synthesize gs_start;
@synthesize gs_end;
@synthesize start_text;
@synthesize end_text;
@synthesize historyTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"SearchViewController viewDidLoad");
    gs_start = [[GCGeocodingService alloc] init];
    gs_end = [[GCGeocodingService alloc] init];
    if (start_text.length>0) {
        self.StartField.text=start_text;
    }
    if (end_text.length>0) {
        self.EndField.text=end_text;
    }
    historyTableView.delegate=self;
    historyTableView.dataSource=self;
    historyTableView.scrollEnabled=YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    history_search_arr=[userDefaults objectForKey:@"history_search"];
    NSLog(@"history_search_arr length is : %lu",(unsigned long)[history_search_arr count]);
    
    [historyTableView reloadData];
    
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (end_text.length>0 && start_text.length>0) {
        [self Search];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    // Implement here to check if already KVO is implemented.
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)NextField:(id)sender {
    [self.StartField resignFirstResponder];
    [self.EndField becomeFirstResponder];
}
- (void)Search{
    NSLog(@"SearchViewController Search!");
    [gs_start geocodeAddress:self.StartField.text];
    [gs_end geocodeAddress:self.EndField.text];
    if ([gs_start isGeocoded]&&[gs_end isGeocoded] ) {
        NSLog(@"Geocode Successfully!");
        start_lat = [[gs_start.geocode objectForKey:@"lat"] doubleValue];
        start_lon = [[gs_start.geocode objectForKey:@"lng"] doubleValue];
        end_lat = [[gs_end.geocode objectForKey:@"lat"] doubleValue];
        end_lon = [[gs_end.geocode objectForKey:@"lng"] doubleValue];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *search_one = [NSArray arrayWithObjects:self.StartField.text, self.EndField.text, nil];
        //NSDictionary *myDictionary = [userDefaults dictionaryForKey:@"myDictionary"];
        if([userDefaults objectForKey:@"history_search"]){
            NSArray *old_history_Dictionary = [userDefaults arrayForKey:@"history_search"];
            NSMutableArray *new_history_Dictionary=[old_history_Dictionary mutableCopy];
            Boolean is_repeated=false;
            for (NSArray *one in new_history_Dictionary) {
                if ([one[0] isEqualToString:search_one[0]]&&[one[1] isEqualToString:search_one[1]]) {
                    is_repeated=true;
                    break;
                }
            }
            if (!is_repeated) {
                [new_history_Dictionary addObject:search_one];
                [userDefaults removeObjectForKey:@"history_search"];
                [userDefaults setObject:new_history_Dictionary forKey:@"history_search"];
            }
        }else{
            NSMutableArray *new_history_Dictionary=[[NSMutableArray alloc] init];
            [new_history_Dictionary addObject:search_one];
            [userDefaults setObject:new_history_Dictionary forKey:@"history_search"];
        }
        [self performSegueWithIdentifier:@"Search" sender:self];
        
    }else{
        NSLog(@"Geocode Error!");

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Geocoded Error" message:[NSString stringWithFormat:@"1, %@; 2, %@",[gs_start getErrorInfo],[gs_end getErrorInfo]] preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (IBAction)doSearch:(id)sender {
    NSLog(@"doSearch button!!");
    [self Search];
    
    
}
- (IBAction)switchFieldContent:(id)sender {
    NSString *temp=self.StartField.text;
    [self.StartField setText:self.EndField.text];
    [self.EndField setText:temp];
}

-(IBAction)backgroundTap:(id)sender{
    [self.StartField resignFirstResponder];
    [self.EndField resignFirstResponder];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Search"]){
        //id theSegue = segue.destinationViewController;
        NSLog(@"Perform Segure Search!");
        CLLocationCoordinate2D position_start = (CLLocationCoordinate2D){start_lat,start_lon};
        CLLocationCoordinate2D position_end = (CLLocationCoordinate2D){end_lat,end_lon};
        DirectionMainViewController *directions=(DirectionMainViewController*)segue.destinationViewController;
        directions.position_start=position_start;
        directions.position_end=position_end;
        //[theSegue setValue:self.EndField.text forKey:@"endInfo"];
        //[theSegue setValue:self.EndField.text forKey:@"endInfo"];
        
    }else if ([segue.identifier isEqualToString:@"InputStart"]){
        InputAddressViewController *directions=(InputAddressViewController*)segue.destinationViewController;
        directions.start_text=self.StartField.text;
        directions.end_text=self.EndField.text;
        directions.is_Start=true;
        
    }else if ([segue.identifier isEqualToString:@"InputEnd"]){
        InputAddressViewController *directions=(InputAddressViewController*)segue.destinationViewController;
        directions.start_text=self.StartField.text;
        directions.end_text=self.EndField.text;
        directions.is_Start=false;
    }
}
-(IBAction)touchStart:(id)sender{
    [self performSegueWithIdentifier:@"InputStart" sender:sender];
}
-(IBAction)touchEnd:(id)sender{
    [self performSegueWithIdentifier:@"InputEnd" sender:sender];
}
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    //NSLog(@"numberOfRowsInSection is %lu",(unsigned long)[places_collection count]);
    return [history_search_arr count];
    //return auto_num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"HistoryCell";
    HistoryTableViewCell *cell = (HistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        // 3. 把 WPaperCell.xib 放入数组中
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:self options:nil] ;
        
        // 获取nib中的第一个对象
        for (id oneObject in nib){
            // 判断获取的对象是否为自定义cell
            if ([oneObject isKindOfClass:[HistoryTableViewCell class]]){
                // 4. 修改 cell 对象属性
                cell = [(HistoryTableViewCell *)oneObject initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
        }
    }
    [cell setupCellStart:history_search_arr[indexPath.row][0] End:history_search_arr[indexPath.row][1]];
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.StartField.text=history_search_arr[indexPath.row][0];
    self.EndField.text=history_search_arr[indexPath.row][1];
    [self doSearch:self];
    
}
@end
