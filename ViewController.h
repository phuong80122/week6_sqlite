//
//  ViewController.h
//  I-transpose_TableView
//
//  Created by Phuong Nguyen on 1/24/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UITextField *lyricTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)saveButton:(id)sender;

- (IBAction)deleteButton:(id)sender;

@end
