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

@interface EditViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)save:(UIBarButtonItem *)sender;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action

- (IBAction)save:(UIBarButtonItem *)sender {
    NSLog(@"title = %@   %@", _textField.text, _textView.text);
    
    NSInteger timestamp = [[NSDate date] timeIntervalSince1970];
    
    LocalDBBaseRecord *record = [[LocalDBBaseRecord alloc] init];
    record.date      = timestamp;
    record.title     = _textField.text;
    record.content   = _textView.text;
    record.sync      = NO;
    record.operation = DBOperationAdd;
    [DataStroage saveRecord:record block:^(BOOL success) {
//        dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
//           
//        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [DataStroage upload];
        });
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
//    CKContainer *container = [CKContainer defaultContainer];
//    CKDatabase *dataBase = container.privateCloudDatabase;
    
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
