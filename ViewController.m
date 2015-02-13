//
//  ViewController.m
//  I-transpose_TableView
//
//  Created by Phuong Nguyen on 1/24/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "ViewController.h"

#import "song.h"
//#import "SongSvcCache.h"
//#import "SongSvcArchive.h"

#import "SongSvcSQLite.h"


@interface ViewController ()

@end

@implementation ViewController


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[songSvc retrieveAllSongs] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:simpleTableIdentifier];
    }
    Song *song = [[songSvc retrieveAllSongs]
                        objectAtIndex:indexPath.row];
    cell.textLabel.text = [song description];
    return cell;
}

//SongSvcCache *songSvc = nil;

//SongSvcArchive *songSvc = nil;

SongSvcSQLite *songSvc = nil;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // songSvc = [[SongSvcCache alloc] init];
    
   //  songSvc = [[SongSvcArchive alloc] init];
    
    songSvc = [[SongSvcSQLite alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveButton:(id)sender {
    NSLog(@"saveButton: entering");
    
    [self.view endEditing:YES];
    
    Song *song = [[Song alloc] init];
    song.title = _titleTextField.text;
    song.key = _keyTextField.text;
    song.lyric = _lyricTextField.text;
    [songSvc createSong:song];
    
    [self.tableView reloadData];
    
    NSLog(@"saveButton: song saved");
}

- (IBAction)deleteButton:(id)sender {
    
    NSLog(@"deleteButton");
    
    [self.view endEditing:YES];
}
@end
