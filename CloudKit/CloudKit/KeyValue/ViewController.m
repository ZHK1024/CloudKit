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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"data = %ld", data.length);
    }];
    
    
//    [[CKContainer defaultContainer] requestApplicationPermission:CKApplicationPermissionUserDiscoverability completionHandler:^(CKApplicationPermissionStatus applicationPermissionStatus, NSError * _Nullable error) {
//        if (applicationPermissionStatus == CKApplicationPermissionStatusGranted) {
//            return ;
//            if (@available(iOS 10.0, *)) {
//
//                [[CKContainer defaultContainer] discoverAllIdentitiesWithCompletionHandler:^(NSArray<CKUserIdentity *> * _Nullable userIdentities, NSError * _Nullable error) {
//                    NSPersonNameComponents *comps = [userIdentities firstObject].nameComponents;
//                    NSLog(@"%@", userIdentities);
////                    NSPersonNameComponents;
////                    NSString *s = [NSPersonNameComponentsFormatter localizedStringFromPersonNameComponents:comps style:NSPersonNameComponentsFormatterStyleLong options:NSPersonNameComponentsFormatterPhonetic];
////                    NSLog(@"%@   %@    %@   %@", comps.familyName, comps.givenName, comps.nickname, s);
//                }];
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//    }];
    
    if (@available(iOS 9.0, *)) {
        [[NSNotificationCenter defaultCenter] addObserverForName:CKAccountChangedNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            
        }];
    } else {
        // Fallback on earlier versions
    }
    
    
//    [[CKQuerySubscription alloc] initWithRecordType:@"Note" predicate:[NSPredicate predicateWithValue:YES] options:CKQuerySubscriptionOptionsFiresOnRecordCreation];
    
    
    
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
    CKContainer *container = [CKContainer defaultContainer];
    
    [container accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error) {
        
    }];
    
    CKDatabase *db = container.privateCloudDatabase;
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
//    predicate = [NSPredicate predicateWithFormat:@"title = \"11111\" && date = 1512989693"];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Notes" predicate:predicate];
//    CKQueryOperation *operation = [[CKQueryOperation alloc] initWithQuery:query];
//    [db addOperation:operation];
//    [operation setQueryCompletionBlock:^(CKQueryCursor * _Nullable cursor, NSError * _Nullable operationError) {
//
//    }];
    [db performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error = %@", error);
        }
        self.dataSource = results;
//        NSLog(@"dataSource = %@", _dataSource);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView.mj_header endRefreshing];
            [_tableView reloadData];
        });
        
//        CKRecord *record = [results lastObject];
//        if (@available(iOS 10.0, *)) {
//            [[CKContainer defaultContainer] discoverUserIdentityWithUserRecordID:record.recordID completionHandler:^(CKUserIdentity * _Nullable userInfo, NSError * _Nullable error) {
//
//                NSPersonNameComponents *comps = userInfo.nameComponents;
//                NSString *s = [NSPersonNameComponentsFormatter localizedStringFromPersonNameComponents:comps style:NSPersonNameComponentsFormatterStyleLong options:NSPersonNameComponentsFormatterPhonetic];
//                NSLog(@"%@   %@    %@   %@", comps.familyName, comps.givenName, comps.nickname, s);
//            }];
//        } else {
//            // Fallback on earlier versions
//        }
    }];
    
//    [CKSubscription alloc] initWithZoneID:<#(nonnull CKRecordZoneID *)#> options:<#(CKSubscriptionOptions)#>
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
    CKRecord *record = _dataSource[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@-%@", [record valueForKey:@"title"], [record valueForKey:@"aaaaaa"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%u)", arc4random() % 100 + 30];
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
