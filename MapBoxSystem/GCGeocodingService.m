//
//  GCGeocodingService.m
//  MapBoxSystem
//
//  Created by Michael Chen on 19/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT,0)//1
#import "GCGeocodingService.h"

@implementation GCGeocodingService{
    BOOL is_ok;
    BOOL isMultiResults;
    NSString *check_info;
}

@synthesize geocode;
-(id)init{
    self=[super init];
    geocode=[[NSDictionary alloc] initWithObjectsAndKeys:@"0.0",@"lat",@"0.0",@"lng",@"Null Island",@"address", nil];
    is_ok=YES;
    isMultiResults=NO;
    return self;
    
}
-(void)geocodeAddress:(NSString *)address{
    NSString *geocodingBaseUrl=@"https://maps.googleapis.com/maps/api/geocode/json?";
    NSString *url=[NSString stringWithFormat:@"%@address=%@&sensor=false&components=country:HK",geocodingBaseUrl,address];
    //NSLog(@"API is %@",url);
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *queryUrl=[NSURL URLWithString:url];
    //dispatch_sync(kBgQueue, ^{
        NSData *data=[NSData dataWithContentsOfURL:queryUrl];
        [self fetchedData:data];
    //});
    
}
-(void) fetchedData:(NSData *)data{
    NSError* error;
    NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    // NSLog(@"json is %@",json);
    NSString* check=[json objectForKey:@"status"];
    
    // NSLog(@"fetchedData is %@",check);
    if([check isEqualToString:@"OK"]){
        NSArray* results=[json objectForKey:@"results"];
        if ([results count]>1) {
            isMultiResults=YES;
            
        }else{
            isMultiResults=NO;
        }
        NSDictionary *result=[[NSDictionary alloc] init];
        NSDictionary *geometry=[[NSDictionary alloc] init];
        NSDictionary *location=[[NSDictionary alloc] init];
        NSMutableDictionary *gc=[[NSMutableDictionary alloc] initWithCapacity:[results count]];
        for (int i=0; i<[results count]; i++) {
            result=[results objectAtIndex:i];
            NSString *address=[result objectForKey:@"formatted_address"];
            geometry=[result objectForKey:@"geometry"];
            location=[geometry objectForKey:@"location"];
            NSString *lat=[location objectForKey:@"lat"];
            NSString *lng=[location objectForKey:@"lng"];
            NSDictionary *oneDic=[[NSDictionary alloc]initWithObjectsAndKeys:lat,@"lat",lng,@"lng",address,@"address", nil];
            [gc setObject:oneDic forKey:[NSString stringWithFormat:@"Result%d",i]];
            
        }
        geocode=gc;
    }else{
        is_ok=NO;
        check_info=check;
    }
    
}
-(BOOL) isGeocoded{
    return is_ok;
}
-(NSString*) getErrorInfo{
    return check_info;
}
-(BOOL) isAmbiguous{
    return isMultiResults;
}
-(void) setClear{
    isMultiResults=NO;
}
@end
