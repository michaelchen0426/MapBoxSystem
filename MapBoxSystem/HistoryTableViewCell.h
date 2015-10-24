//
//  HistoryTableViewCell.h
//  MapBoxSystem
//
//  Created by Michael Chen on 23/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@property (weak, nonatomic) IBOutlet UILabel *startLaebl;
-(void)setupCellStart:(NSString *)start End:(NSString *)end;
@end
