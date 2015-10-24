//
//  MDDirectionService.h
//  NavigationSystemPlus
//
//  Created by Michael Chen on 17/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDDirectionService : NSObject
- (void)setDirectionsQuery:(NSDictionary *)object withSelector:(SEL)selector
              withDelegate:(id)delegate;
- (void)retrieveDirections:(SEL)sel withDelegate:(id)delegate;
- (void)fetchedData:(NSData *)data withSelector:(SEL)selector
       withDelegate:(id)delegate;
@end
