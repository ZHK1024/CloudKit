//
//  DataStroage.m
//  UserData
//
//  Created by ZHK on 2018/7/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "DataStroage.h"
#import "LocalDBManager.h"
#import "CKDBManager.h"
#import "CKDBRecord.h"
#import "LocalDBBaseRecord.h"

static DataStroage *stroage = nil;

@interface DataStroage ()

@property (nonatomic, strong) LocalDBManager *LDBManager;

@end

@implementation DataStroage

+ (instancetype)stroage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stroage = [[DataStroage alloc] init];
    });
    return stroage;
}

+ (void)saveRecord:(id <LocalDBRecord>)record block:(void(^)(BOOL success))block {
    NSArray<LocalDBRecord> *records = (NSArray<LocalDBRecord> *)@[record];
    [[DataStroage stroage].LDBManager saveRecords:records block:^(BOOL success) {
        if (block) {
            block(success);
        }
        [self upload];
    }];
}

+ (void)download {
    [CKDBManager recordsWithName:@"Notes" block:^(NSArray<CKDBBaseRecord *> *records) {
        NSLog(@"records = %@", records);
        [[DataStroage stroage].LDBManager saveRecords:[self localRecordWithCKRecords:records operation:DBOperationAdd] block:^(BOOL success) {
            NSLog(@"success = %d", success);
        }];
    }];
}

+ (void)upload {
    // 查询本地未同步到云端的记录
    [[DataStroage stroage].LDBManager baseUnsyncRecordsWithDataClass:[LocalDBBaseRecord class] block:^(NSArray *records) {
        // 同步记录
        [CKDBManager saveRecords:[self CKDBRecordsWithLocalRecords:records] complete:^(NSArray *recordIDs, NSError *error) {
            // 标记本地记录为已同步
            [[DataStroage stroage].LDBManager markRecordSuncedWithDataClass:[LocalDBBaseRecord class] recordIds:recordIDs block:^(BOOL finish) {
            }];
        }];
    }];
}

#pragma mark -

+ (void)records:(void(^)(NSArray *records))block {
    [[DataStroage stroage].LDBManager baseRecordsWithDataClass:[LocalDBBaseRecord class] block:block];
}

#pragma mark -

+ (NSArray <LocalDBRecord>*)localRecordWithCKRecords:(NSArray *)records operation:(DBOperations)operation {
    if (records.count == 0) {
        return nil;
    }
    NSMutableArray <LocalDBRecord>*temp = (NSMutableArray <LocalDBRecord>*)[NSMutableArray new];
    for (CKDBBaseRecord *record in records) {
        LocalDBBaseRecord *re = [[LocalDBBaseRecord alloc] init];
        re.recordId  = record.recordId;
        re.title     = record.title;
        re.content   = record.content;
        re.date      = record.date;
        re.sync      = YES;
        re.operation = operation;
        [temp addObject:re];
    }
    return temp;
}

+ (NSArray <CKDBRecord> *)CKDBRecordsWithLocalRecords:(NSArray *)records {
    if (records.count == 0) {
        return nil;
    }
    NSMutableArray<CKDBRecord> *temp = (NSMutableArray<CKDBRecord> *)[NSMutableArray new];
    for (LocalDBBaseRecord *record in records) {
        CKDBBaseRecord *re = [[CKDBBaseRecord alloc] initWithReocrdName:record.recordId];
        re.title    = record.title;
        re.content  = record.content;
        re.date     = record.date;
        re.sync     = YES;
        [temp addObject:re];
    }
    return temp;
}

#pragma mark - Getter

- (LocalDBManager *)LDBManager {
    if (_LDBManager == nil) {
        self.LDBManager = [[LocalDBManager alloc] init];
    }
    return _LDBManager;
}

@end
