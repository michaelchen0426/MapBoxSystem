//
//  HistoryTableViewController.h
//  MapBoxSystem
//
//  Created by Michael Chen on 24/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryTableViewControllerDelegate <NSObject>

// 代理传值方法
- (void)passHistoryInfo:(NSString *)selectedText;

@end
@interface HistoryTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property(assign,nonatomic) Boolean isStart;
@property (weak, nonatomic) id<HistoryTableViewControllerDelegate> delegate;
@end
