//
//  SingleHistoryTabelViewCell.m
//  MapBoxSystem
//
//  Created by Michael Chen on 24/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import "SingleHistoryTabelViewCell.h"

@implementation SingleHistoryTabelViewCell
@synthesize SingleLabel;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setSingleLabelText:(NSString *)text{
    SingleLabel.text=text;
}
@end
