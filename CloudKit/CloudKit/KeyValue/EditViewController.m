//
//  EditViewController.m
//  iCloud
//
//  Created by ZHK on 2017/12/11.
//  Copyright © 2017年 ZHK. All rights reserved.
//

#import "EditViewController.h"
#import <CloudKit/CloudKit.h>
#import "DataStroage.h"
#import "LocalDBBaseRecord.h"

@interface EditViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)save:(UIBarButtonItem *)sender;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self display];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)display {
    if (_record) {
        _textField.text = _record.title;
        _textView.text = _record.content;
    }
}

#pragma mark - Action

- (IBAction)save:(UIBarButtonItem *)sender {
    NSInteger timestamp = [[NSDate date] timeIntervalSince1970];
    
    LocalDBBaseRecord *record = nil;
    if (_record) {
        record = _record;
        record.operation = DBOperationUpdate;
    } else {
        record = [[LocalDBBaseRecord alloc] init];
        record.date      = timestamp;
        record.operation = DBOperationAdd;
    }
    record.title     = _textField.text;
    record.content   = _textView.text;
    record.sync      = NO;
    
    [DataStroage saveRecord:record block:^(BOOL success) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
//
//    CKNotificationInfo *notificationInfo = [CKNotificationInfo new];
//    notificationInfo.alertBody = @"New artwork by your favorite artist.";
//    notificationInfo.shouldBadge = YES;
//
//    CKSubscription *subscription = [[CKSubscription alloc] initWithRecordType:@"Notes" predicate:[NSPredicate predicateWithValue:YES] options:CKSubscriptionOptionsFiresOnRecordCreation];
//    subscription.notificationInfo = notificationInfo;
//
//
    CKRecord *ckd;
    
    
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *dataBase = container.privateCloudDatabase;
//    dataBase
    
//    [dataBase saveSubscription:subscription completionHandler:^(CKSubscription * _Nullable subscription, NSError * _Nullable error) {
//        NSLog(@"error = %@", error);
//    }];
    
//    [dataBase saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"error = %@", error);
//        } else {
//            NSLog(@"success");
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//            });
//        }
//    }];
}

@end
