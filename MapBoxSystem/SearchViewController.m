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
    CLLocationCoordinate2D position_start;
    CLLocationCoordinate2D position_end;
    NSMutableArray *waypointStrings_;
    NSURL *_directionsURL;
    NSDictionary *wholeJson;
    Boolean loadFinished;
    GCGeocodingService *gs_start;
    GCGeocodingService *gs_end;
    
}
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (weak, nonatomic) IBOutlet UITextField *StartField;
@property (weak, nonatomic) IBOutlet UITextField *EndField;
@end

@implementation SearchViewController
@synthesize start_text;
@synthesize end_text;
@synthesize historyTableView;
@synthesize startDictionary;
@synthesize endDictionary;

static NSString *kMDDirectionsURL=@"http://10.89.116.116:3000/api/v1/Mapbox?";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    loadFinished=false;
    waypointStrings_ = [[NSMutableArray alloc]init];
    
    if (startDictionary ==nil) {
        NSLog(@"SearchViewController first viewDidLoad");
        gs_start = [[GCGeocodingService alloc] init];
        gs_end = [[GCGeocodingService alloc] init];
        if (start_text.length>0) {
            self.StartField.text=start_text;
        }
        if (end_text.length>0) {
            self.EndField.text=end_text;
        }
    }else{
        NSLog(@"SearchViewController second viewDidLoad");
        self.StartField.text=[startDictionary objectForKey:@"address"];
        self.EndField.text=[endDictionary objectForKey:@"address"];
        start_lat=[[startDictionary objectForKey:@"lat"] doubleValue];
        start_lon=[[startDictionary objectForKey:@"lng"] doubleValue];
        end_lat=[[endDictionary objectForKey:@"lat"] doubleValue];
        end_lon=[[endDictionary objectForKey:@"lng"] doubleValue];
        position_start = (CLLocationCoordinate2D){start_lat,start_lon};
        position_end = (CLLocationCoordinate2D){end_lat,end_lon};
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self callWebAPI];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (loadFinished) {
                    [SVProgressHUD dismiss];
                }
            });
        });
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
    [self.navigationController setNavigationBarHidden:YES];
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
    [SVProgressHUD show];
    NSLog(@"SearchViewController Search!");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [gs_start geocodeAddress:self.StartField.text];
        [gs_end geocodeAddress:self.EndField.text];
        if ([gs_start isGeocoded]&&[gs_end isGeocoded] ) {
            if ([gs_start isAmbiguous]||[gs_end isAmbiguous]) {
                NSLog(@"Geocode Ambiguous!");
                loadFinished=true;
                dispatch_async(dispatch_get_main_queue(), ^{
                    loadFinished=true;
                    [self performSegueWithIdentifier:@"AmbiguousSegue" sender:self];
                });
            }else{
                NSLog(@"Geocode Successfully!");
                start_lat = [[[gs_start.geocode objectForKey:@"Result0"] objectForKey:@"lat"] doubleValue];
                //start_lat = [[gs_start.geocode objectForKey:@"lat"] doubleValue];
                start_lon = [[[gs_start.geocode objectForKey:@"Result0"] objectForKey:@"lng"] doubleValue];
                //start_lon = [[gs_start.geocode objectForKey:@"lng"] doubleValue];
                end_lat = [[[gs_end.geocode objectForKey:@"Result0"] objectForKey:@"lat"] doubleValue];
                //end_lat = [[gs_end.geocode objectForKey:@"lat"] doubleValue];
                end_lon = [[[gs_end.geocode objectForKey:@"Result0"] objectForKey:@"lng"] doubleValue];
                
                //end_lon = [[gs_end.geocode objectForKey:@"lng"] doubleValue];
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
                position_start = (CLLocationCoordinate2D){start_lat,start_lon};
                position_end = (CLLocationCoordinate2D){end_lat,end_lon};
                [self callWebAPI];
            }
            
            
        }else{
            NSLog(@"Geocode Error!");
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Geocoded Error" message:[NSString stringWithFormat:@"1, %@; 2, %@",[gs_start getErrorInfo],[gs_end getErrorInfo]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                loadFinished=true;
                [self presentViewController:alertController animated:YES completion:nil];
                
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (loadFinished) {
                [SVProgressHUD dismiss];
            }
            
        });
    });
}

-(void)callWebAPI{
    NSString *positionString_start = [[NSString alloc] initWithFormat:@"lon_s=%f&lat_s=%f",
                                      position_start.latitude,position_start.longitude];
    NSString *positionString_end = [[NSString alloc] initWithFormat:@"lon_e=%f&lat_e=%f",
                                    position_end.latitude,position_end.longitude];
    [waypointStrings_ addObject:positionString_start];
    [waypointStrings_ addObject:positionString_end];
    NSString *sensor = @"false";
    NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                           nil];
    NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
    //NSLog(@"parameters is %@",parameters);
    //NSLog(@"keys is %@",keys);
    NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                      forKeys:keys];
    //MDDirectionService *mds=[[MDDirectionService alloc] init];
    SEL selector = @selector(setPassData:);
    //[mds setDirectionsQuery:query
    [self setDirectionsQuery: query
                withSelector:selector
                withDelegate:self];
}
-(void)setDirectionsQuery:(NSDictionary*) query withSelector:(SEL)selector withDelegate:(id)delegate{
    NSArray *waypoints=[query objectForKey:@"waypoints"];
    NSString *origin=[waypoints objectAtIndex:0];
    int waypointCount=[waypoints count];
    int destinationPos=waypointCount-1;
    NSString *destination=[waypoints objectAtIndex:destinationPos];
    //NSString *sensor=[query objectForKey:@"sensor"];
    NSMutableString *url=[NSMutableString stringWithFormat:@"%@%@&%@",kMDDirectionsURL,origin,destination];

    NSLog(@"api: %@",url);
    url=[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    _directionsURL=[NSURL URLWithString:url];
    [self retrieveDirections:selector withDelegate:delegate];
    
}

-(void)retrieveDirections:(SEL)selector withDelegate:(id)delegate{
    /*
     NSData* data=[NSData dataWithContentsOfURL:_directionsURL];
     [self fetchedData:data withSelector:selector withDelegate:delegate];
     */
    NSLog(@"retrieveDirections!");
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:_directionsURL
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSLog(@"placeGetRequest!");
                if (error==nil) {
                    NSLog(@"get data!");
                    wholeJson=[NSJSONSerialization
                               JSONObjectWithData:data
                               options:kNilOptions
                               error:&error];
                    loadFinished=true;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSegueWithIdentifier:@"Search" sender:self];
                    });
                    //[self fetchedData:data withSelector:selector withDelegate:delegate];
                }else{
                    NSLog(@"Connection fail!");
                    loadFinished=true;
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Connect Error" message:[NSString stringWithFormat:@"Direction Service is not available!"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:okAction];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }
                
            }] resume];
    
    
}
-(void) fetchedData:(NSData *)data withSelector:(SEL)selector withDelegate:(id)delegate{
    NSError* error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    [delegate performSelector:selector withObject:json];
    
}
- (void)setPassData:(NSDictionary *)json {
    wholeJson=json;
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
        
        DirectionMainViewController *directions=(DirectionMainViewController*)segue.destinationViewController;
        directions.position_start=position_start;
        directions.position_end=position_end;
        directions.wholeJson=wholeJson;
        directions.startLocation=[self.StartField text] ;
        directions.endLocation=[self.EndField text];
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
    }else if ([segue.identifier isEqualToString:@"AmbiguousSegue"]){
        AmbiguousGeoViewController *ambiguousVC=(AmbiguousGeoViewController*)segue.destinationViewController;
        ambiguousVC.gs_start=gs_start;
        ambiguousVC.gs_end=gs_end;
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
