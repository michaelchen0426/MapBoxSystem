//
//  InputAddressViewController.h
//  MapBoxSystem
//
//  Created by Michael Chen on 21/10/15.
//  Copyright © 2015 Michael Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputAddressViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    NSMutableArray *places_collection;
}
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITableView *autocompleteTableView;
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong,nonatomic) NSString *start_text;
@property (strong,nonatomic) NSString *end_text;
@property (assign,nonatomic) Boolean is_Start;
@end
