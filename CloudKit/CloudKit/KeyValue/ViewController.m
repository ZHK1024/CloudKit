//
//  ViewController.m
//  iCloud
//
//  Created by ZHK on 2017/12/11.
//  Copyright © 2017年 ZHK. All rights reserved.
//

#import "ViewController.h"
#import <CloudKit/CloudKit.h>
#import "DisplayViewController.h"
#import "NotesListCell.h"
#import <MJRefresh.h>

//#import "UserData.h"
//#import <UserData/DataStroage.h>
//#import "UserData.h"
#import "DataStroage.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    NSLog(@"db = %@", [CKContainer defaultContainer].privateCloudDatabase);
    [[CKContainer defaultContainer] statusForApplicationPermission:CKApplicationPermissionUserDiscoverability completionHandler:^(CKApplicationPermissionStatus applicationPermissionStatus, NSError * _Nullable error) {
        
    }];
    
//    [CKContainer defaultContainer].privateCloudDatabase performQuery:<#(nonnull CKQuery *)#> inZoneWithID:<#(nullable CKRecordZoneID *)#> completionHandler:<#^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error)completionHandler#>
    
//    [[CKOperation alloc] init];
    
//    [[CKUserIdentity new] hasiCloudAccount];
    
//    [DataStroage upload];
//    [DataStroage download];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - UI

- (void)createUI {
    self.title = @"首页";
    [_tableView registerClass:[NotesListCell class] forCellReuseIdentifier:NotesListCell_INDEF];

    __weak typeof(self) ws = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws refreshData];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Data

- (void)refreshData {
    [DataStroage records:^(NSArray *records) {
        self.dataSource = records;
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
    }];
}

#pragma mark - UITableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotesListCell *cell = [tableView dequeueReusableCellWithIdentifier:NotesListCell_INDEF];
    LocalDBBaseRecord *record = _dataSource[indexPath.row];
    cell.titleLabel.text = record.title;
    
    cell.detailTextLabel.text = ({
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:record.date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [formatter stringFromDate:date];
    });
    
    NSLog(@"recordId = %@   %@", record, record.recordId);
    return cell;
}

#pragma mark - UITableView delegate

// row select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DisplayViewController *displayVC = [[DisplayViewController alloc] init];
    displayVC.record = _dataSource[indexPath.row];
    [self.navigationController pushViewController:displayVC animated:YES];
}

// row heighr
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

// header footer height
- (CGFloat)tableView:(UITableView *)tableView   :(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

// view for header footer
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        self.dataSource = @[];
    }
    return _dataSource;
}

@end
