//
//  MDDirectionService.m
//  NavigationSystemPlus
//
//  Created by Michael Chen on 17/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import "MDDirectionService.h"
#import "MBProgressHUD.h"
@implementation MDDirectionService{
@private
    BOOL _sensor;
    BOOL _alternatives;
    NSURL *_directionsURL;
    NSArray *_waypoints;
    
}
//static NSString *kMDDirectionsURL=@"https://maps.googleapis.com/maps/api/directions/json?";
static NSString *kMDDirectionsURL=@"http://localhost:3000/api/v1/Mapbox?";
-(void)setDirectionsQuery:(NSDictionary*) query withSelector:(SEL)selector withDelegate:(id)delegate{
    NSArray *waypoints=[query objectForKey:@"waypoints"];
    NSString *origin=[waypoints objectAtIndex:0];
    int waypointCount=(int)[waypoints count];
    int destinationPos=waypointCount-1;
    NSString *destination=[waypoints objectAtIndex:destinationPos];
    //NSString *sensor=[query objectForKey:@"sensor"];
    NSMutableString *url=[NSMutableString stringWithFormat:@"%@%@&%@",kMDDirectionsURL,origin,destination];
    /*
     if(waypointCount>2){
     [url appendString:@"&waypoints=optimize:true"];
     int wpCount=waypointCount-2;
     for(int i=1;i<wpCount;i++){
     [url appendString:@"|"];
     [url appendString:[waypoints objectAtIndex:i]];
     
     }
     }
     */
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
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data=[NSData dataWithContentsOfURL:_directionsURL];
        [self fetchedData:data withSelector:selector withDelegate:delegate];
    });
     
}
-(void) fetchedData:(NSData *)data withSelector:(SEL)selector withDelegate:(id)delegate{
    NSError* error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    [delegate performSelector:selector withObject:json];
    
}
@end
