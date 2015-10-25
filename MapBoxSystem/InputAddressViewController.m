//
//  InputAddressViewController.m
//  MapBoxSystem
//
//  Created by Michael Chen on 21/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import "InputAddressViewController.h"
#import "SearchViewController.h"
@import GoogleMaps;
@interface InputAddressViewController ()
@property (nonatomic, weak) HistoryTableViewController *historyTableViewController;
@end

@implementation InputAddressViewController{
    NSInteger auto_num;
    GMSPlacesClient *_placesClient;
    GMSCoordinateBounds *bounds;
   
}
@synthesize addressField;
@synthesize autocompleteTableView;

@synthesize start_text;
@synthesize end_text;
@synthesize is_Start;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    if (start_text.length>0&&is_Start) {
        addressField.text=start_text;
    }else if(end_text.length>0&&!is_Start){
        addressField.text=end_text;
    }
    /*
    id desiredColor = [UIColor lightGrayColor];
    self.historyTableView.backgroundColor = desiredColor;
    self.historyTableView.backgroundView.backgroundColor = desiredColor;
    */
    addressField.delegate=self;
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    places_collection=[[NSMutableArray alloc] init];
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(22.12, 113.815);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(22.584, 114.517);
    bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                     coordinate:southWest];
    auto_num=5;
    _placesClient=[[GMSPlacesClient alloc] init];
    [addressField becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    //NSLog(@"InputAddressViewController searchAutocompleteEntriesWithSubstring");
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterEstablishment;
    
    [places_collection removeAllObjects];
    [_placesClient autocompleteQuery:substring
                              bounds:bounds
                              filter:filter
                            callback:^(NSArray *results, NSError *error) {
                                if (error != nil) {
                                    NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                    return;
                                }
                                auto_num=[results count];
                                for (GMSAutocompletePrediction* result in results) {
                                    [places_collection addObject:result.attributedFullText.string];
                                    NSLog(@"Result '%@' , num is %lu", result.attributedFullText.string, (unsigned long)[places_collection count]);
                                }
                                
                                [autocompleteTableView reloadData];
                                
                                
                                                               
                            }];
    
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    //NSLog(@"shouldChangeCharactersInRange: %@",substring);
    if (substring.length>0) {
        autocompleteTableView.hidden = NO;
    }else{
        autocompleteTableView.hidden = YES;
    }
    
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    //NSLog(@"numberOfRowsInSection is %lu",(unsigned long)[places_collection count]);
    return [places_collection count];
    //return auto_num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    UILabel *cell_label = (UILabel *)[cell viewWithTag:1];
   
    if (indexPath.row>= [places_collection count]) {
        cell_label.text = [[NSString alloc] initWithFormat:@""];
    }else{
        cell_label.text = [places_collection objectAtIndex:indexPath.row];
    }
    
    
    
    
    //NSLog(@"cell_label.text is %@",cell_label.text);
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *cell_label = (UILabel *)[selectedCell viewWithTag:1];
    addressField.text = cell_label.text;
    autocompleteTableView.hidden = YES;
    [addressField resignFirstResponder];
    
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"SearchSegue"]){
        //id theSegue = segue.destinationViewController;
        SearchViewController *directions=(SearchViewController*)segue.destinationViewController;
        if (is_Start) {
            directions.start_text=addressField.text;
            directions.end_text=end_text;
        }else{
            directions.end_text=addressField.text;
            directions.start_text=start_text;
        }
        
        //[theSegue setValue:self.EndField.text forKey:@"endInfo"];
        //[theSegue setValue:self.EndField.text forKey:@"endInfo"];
        
    }else if ([segue.identifier isEqualToString:@"BackSegue"]){
        SearchViewController *directions=(SearchViewController*)segue.destinationViewController;
        directions.start_text=start_text;
        directions.end_text=addressField.text;
        
    }else if ([segue.identifier isEqualToString:@"embedContainer"]) {
        NSLog(@"embedContainer segure execute");
        self.historyTableViewController = segue.destinationViewController;
        self.historyTableViewController.isStart=self.is_Start;
        [self.historyTableViewController setDelegate:self];
    }
}
- (void)passHistoryInfo:(NSString *)selectedText{
    addressField.text=selectedText;
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
