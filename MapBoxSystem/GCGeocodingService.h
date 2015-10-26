//
//  GCGeocodingService.h
//  MapBoxSystem
//
//  Created by Michael Chen on 19/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCGeocodingService : NSObject

-(id)init;
-(void)geocodeAddress:(NSString *)address;
-(BOOL) isGeocoded;
-(NSString*) getErrorInfo;
-(bool) isAmbiguous;
-(void) setClear;
@property (nonatomic, strong) NSDictionary *geocode;

@end
