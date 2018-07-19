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

@end

@implementation CKDBManager

+ (void)recordsWithName:(NSString *)name block:(void(^)(NSArray <CKDBBaseRecord *>*records))block {
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:name predicate:predicate];
    [[self dataBase] performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if (block) {
            block([CKDBBaseRecord recordsWithCKRecords:results]);
        }
    }];
    
}

+ (void)saveRecords:(NSArray *)records complete:(void(^)(NSArray *recordIDs, NSError *error))complete {
    // 取出 CKDBBaseRecord 下面的 CKRecord
    records = [records valueForKeyPath:@"record"];
    // CK 操作
    CKModifyRecordsOperation *operation = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:records recordIDsToDelete:nil];
    operation.savePolicy = CKRecordSaveAllKeys;
    [operation setModifyRecordsCompletionBlock:^(NSArray<CKRecord *> * _Nullable savedRecords, NSArray<CKRecordID *> * _Nullable deletedRecordIDs, NSError * _Nullable operationError) {
            complete([savedRecords valueForKeyPath:@"recordID.recordName"], operationError);
    }];
    [[self dataBase] addOperation:operation];
}

+ (CKDatabase *)dataBase {
    return [CKContainer defaultContainer].privateCloudDatabase;
}

@end
