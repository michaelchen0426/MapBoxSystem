//
//  DetailsTableViewCell.m
//  MapBoxSystem
//
//  Created by Michael Chen on 24/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import "DetailsTableViewCell.h"

@implementation DetailsTableViewCell
@synthesize roadLabel;
@synthesize trafficLabel;
@synthesize instructionImage;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)initializeCell:(NSString *)roadName trafficCondition:(NSString *)trafficCon instructionCode:(NSInteger)inCode{
    
    NSArray *traffic_instruction=[NSArray arrayWithObjects: @"NoTurn" ,
                                  @"GoStraight",
                                  @"TurnSlightRight",
                                  @"TurnRight",
                                  @"TurnSharpRight",
                                  @"UTurn",
                                  @"TurnSharpLeft",
                                  @"TurnLeft",
                                  @"TurnSlightLeft",
                                  @"ReachViaLocation",
                                  @"HeadOn",
                                  @"EnterRoundAbout",
                                  @"LeaveRoundAbout",
                                  @"StayOnRoundAbout",
                                  @"StartAtEndOfStreet",
                                  @"ReachedYourDestination",
                                  @"EnterAgainstAllowedDirection",
                                  @"LeaveAgainstAllowedDirection",nil];
    if (roadName.length>0) {
        roadLabel.text=roadName;
    }else{
        roadLabel.text=[NSString stringWithFormat:@"UnKnown Road Name"];
    }
    
    trafficLabel.font= [UIFont boldSystemFontOfSize:13.0f];
    if ([trafficCon isEqualToString:@"TRAFFIC GOOD"]) {
        trafficLabel.text=@"Clear";
        trafficLabel.textColor=[UIColor greenColor];
    }else if([trafficCon isEqualToString:@"TRAFFIC AVERAGE"]) {
        trafficLabel.text=@"Average";
        trafficLabel.textColor=[UIColor yellowColor];
    }else if([trafficCon isEqualToString:@"TRAFFIC BAD"]) {
        trafficLabel.text=@"Crowded";
        trafficLabel.textColor=[UIColor redColor];
    }else{
        trafficLabel.text=@"UnKnown";
        trafficLabel.textColor=[UIColor grayColor];
    }
    switch (inCode) {
        case 127:
            
            break;
        case 128:
            
            break;
        case 129:
            
            break;
        default:
            [instructionImage setImage:[UIImage imageNamed: [NSString stringWithFormat:@"%@.png", traffic_instruction[inCode]]]];
            break;
    }
    
}
@end
