//
//  AmbiguousGeoViewController.m
//  MapBoxSystem
//
//  Created by Michael Chen on 26/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import "AmbiguousGeoViewController.h"
#import "SearchViewController.h"
@interface AmbiguousGeoViewController (){
    BOOL isStart;
    BOOL isEnd;
    NSDictionary *mainDictionary;
    NSString *start_lat,*start_lon,*end_lat,*end_lon;
    NSString *startAddressText,*endAddressText;
    NSDictionary *startDictionary;
    NSDictionary *endDictionary;
}

@end

@implementation AmbiguousGeoViewController
@synthesize geoResult;
@synthesize gs_start;
@synthesize gs_end;
@synthesize ambiguousTableView;
@synthesize hintLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"AmbiguousGeoViewController viewDidLoad!");
    isStart=[gs_start isAmbiguous];
    isEnd=[gs_end isAmbiguous];
    ambiguousTableView.delegate=self;
    ambiguousTableView.dataSource=self;
    if (isStart) {
        mainDictionary=gs_start.geocode;
        hintLabel.text=@"Please Select the Valid Start Location:";
    }else if(isEnd){
        startAddressText= [[gs_start.geocode objectForKey:@"Result0"] objectForKey:@"address"];
        mainDictionary=gs_end.geocode;
        hintLabel.text=@"Please Select the Valid End Location:";
        start_lat = [[gs_start.geocode objectForKey:@"Result0"] objectForKey:@"lat"];
        //start_lat = [[gs_start.geocode objectForKey:@"lat"] doubleValue];
        start_lon = [[gs_start.geocode objectForKey:@"Result0"] objectForKey:@"lng"];
        startDictionary=[[NSDictionary alloc] initWithObjectsAndKeys:start_lat,@"lat",start_lon,@"lng",startAddressText,@"address", nil];
        
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)resetView{
    mainDictionary=gs_end.geocode;
    hintLabel.text=@"Please Select the Valid End Location:";
    [ambiguousTableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"BackSearch"]){
        SearchViewController *searchViewController=(SearchViewController *)segue.destinationViewController;
        searchViewController.startDictionary=startDictionary;
        searchViewController.endDictionary=endDictionary;
    }
}
#pragma mark UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    //NSLog(@"numberOfRowsInSection is %lu",(unsigned long)[places_collection count]);
    if (isStart||isEnd) {
        return [mainDictionary count];
    }
    return 0;
    
    //return auto_num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell = nil;
    static NSString *cellIdentifier = @"cell";
    
    // 判断是有空闲的cell,有进行重用，没有就创建一个
    UITableViewCell  *cell  = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }
    // 设置名字
    
    cell.textLabel.text = [[mainDictionary objectForKey:[NSString stringWithFormat:@"Result%ld",(long)indexPath.row]] objectForKey:@"address"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isStart) {
        start_lat = [[mainDictionary objectForKey:[NSString stringWithFormat:@"Result%ld",(long)indexPath.row]] objectForKey:@"lat"];
        start_lon = [[mainDictionary objectForKey:[NSString stringWithFormat:@"Result%ld",(long)indexPath.row]] objectForKey:@"lng"];
        startAddressText=[[mainDictionary objectForKey:[NSString stringWithFormat:@"Result%ld",(long)indexPath.row]] objectForKey:@"address"];
        startDictionary=[[NSDictionary alloc] initWithObjectsAndKeys:start_lat,@"lat",end_lat,@"lng",startAddressText,@"address", nil];
        [gs_start setClear];
        isStart=NO;
        if (isEnd) {
            [self resetView];
        }else{
            [self performSegueWithIdentifier:@"BackSearch" sender:self];
        }
    }else{
        end_lat = [[mainDictionary objectForKey:[NSString stringWithFormat:@"Result%ld",(long)indexPath.row]] objectForKey:@"lat"];
        end_lon = [[mainDictionary objectForKey:[NSString stringWithFormat:@"Result%ld",(long)indexPath.row]] objectForKey:@"lng"];
        endAddressText=[[mainDictionary objectForKey:[NSString stringWithFormat:@"Result%ld",(long)indexPath.row]] objectForKey:@"address"];
        endDictionary=[[NSDictionary alloc] initWithObjectsAndKeys:end_lat,@"lat",end_lon,@"lng",endAddressText,@"address", nil];
        [gs_end setClear];
        isEnd=NO;
        [self performSegueWithIdentifier:@"BackSearch" sender:self];
    }
    
}


@end
