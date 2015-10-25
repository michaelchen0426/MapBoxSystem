//
//  DetailsTableViewCell.h
//  MapBoxSystem
//
//  Created by Michael Chen on 24/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *roadLabel;
@property (weak, nonatomic) IBOutlet UILabel *trafficLabel;
@property (weak, nonatomic) IBOutlet UIImageView *instructionImage;

- (void)initializeCell:(NSString *)roadName trafficCondition:(NSString *)trafficCon instructionCode:(NSInteger)inCode;
@end
