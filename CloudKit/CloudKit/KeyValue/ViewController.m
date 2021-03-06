//
//  ViewController.m
//  iCloud
//
//  Created by ZHK on 2017/12/11.
//  Copyright © 2017年 ZHK. All rights reserved.
//

#import "ViewController.h"
#import <CloudKit/CloudKit.h>
#import "NotesListCell.h"
#import <MJRefresh.h>

#import "DataStroage.h"
#import "EditViewController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    CKSubscription *subscription = nil;
    if (@available(iOS 10.0, *)) {
        subscription = [[CKSubscription alloc] initWithRecordType:@"Notes" predicate:predicate options:CKQuerySubscriptionOptionsFiresOnRecordUpdate | CKQuerySubscriptionOptionsFiresOnRecordCreation];
    } else {
        subscription = [[CKSubscription alloc] initWithRecordType:@"Notes" predicate:predicate options:CKSubscriptionOptionsFiresOnRecordUpdate | CKSubscriptionOptionsFiresOnRecordCreation];
    }
    CKNotificationInfo *notiInfo = [[CKNotificationInfo alloc] init];
    notiInfo.alertBody = @"New artwork by your favorite artist.";
    notiInfo.shouldBadge = YES;
    
    subscription.notificationInfo = notiInfo;
    
    [[CKContainer defaultContainer].privateCloudDatabase saveSubscription:subscription completionHandler:^(CKSubscription * _Nullable subscription, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error = %@", error);
        } else {
            NSLog(@"success");
        }
    }];
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

- (IBAction)deleteCKDatabase {
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Notes" predicate:[NSPredicate predicateWithValue:YES]];
    [[CKContainer defaultContainer].privateCloudDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        for (CKRecord *record in results) {
            [[CKContainer defaultContainer].privateCloudDatabase deleteRecordWithID:record.recordID completionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
                NSLog(@"delete");
            }];
        }
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
        [NSString stringWithFormat:@"%@ -> %d", [formatter stringFromDate:date], record.sync];
    });
    return cell;
}

#pragma mark - UITableView delegate

// row select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditViewController *editVC = [sb instantiateViewControllerWithIdentifier:@"editvc"];
    editVC.record = _dataSource[indexPath.row];
    [self.navigationController pushViewController:editVC animated:YES];
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
