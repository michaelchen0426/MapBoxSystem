//
//  SingleHistoryTabelViewCell.h
//  MapBoxSystem
//
//  Created by Michael Chen on 24/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleHistoryTabelViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *SingleLabel;
- (void)setSingleLabelText:(NSString *)text;
@end
