//
//  InputAddressViewController.h
//  MapBoxSystem
//
//  Created by Michael Chen on 21/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryTableViewController.h"
@interface InputAddressViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,HistoryTableViewControllerDelegate>{
    NSMutableArray *places_collection;
}
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITableView *autocompleteTableView;

@property (strong,nonatomic) NSString *start_text;
@property (strong,nonatomic) NSString *end_text;
@property (assign,nonatomic) Boolean is_Start;
-(IBAction)editEnd:(id)sender;
@end
