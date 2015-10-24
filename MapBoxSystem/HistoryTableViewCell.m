//
//  HistoryTableViewCell.m
//  MapBoxSystem
//
//  Created by Michael Chen on 23/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setupCellStart:(NSString *)start End:(NSString *)end{
    self.startLaebl.text=start;
    self.endLabel.text=end;
}
@end
