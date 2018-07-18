//
//  CKDBManager.m
//  UserData
//
//  Created by ZHK on 2018/7/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "CKDBManager.h"
#import <CloudKit/CloudKit.h>


static CKDBManager *manager = nil;

@interface CKDBManager ()

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation CKDBManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CKDBManager alloc] init];
        manager.queue = [[NSOperationQueue alloc] init];
        manager.queue.maxConcurrentOperationCount = 1;
    });
    return manager;
}

#pragma mark -

+ (void)recordsWithName:(NSString *)name block:(void(^)(NSArray <CKDBBaseRecord *>*records))block {
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:name predicate:predicate];
    [[self dataBase] performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if (block) {
            block([CKDBBaseRecord recordsWithCKRecords:results]);
        }
        NSLog(@"error = %@, results", error, results);
    }];
    
}

+ (void)saveRecords:(NSArray *)records syncRecord:(void(^)(CKDBBaseRecord *record))block complete:(void(^)(BOOL success))complete {
    for (CKDBBaseRecord *record in records) {
        [[CKDBManager manager].queue addOperationWithBlock:^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [[self dataBase] saveRecord:record.record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, 5);
            block(record);
        }];
    }
    
    [manager.queue addOperationWithBlock:^{
        complete(YES);
    }];
}

+ (CKDatabase *)dataBase {
    return [CKContainer defaultContainer].privateCloudDatabase;
}

@end
