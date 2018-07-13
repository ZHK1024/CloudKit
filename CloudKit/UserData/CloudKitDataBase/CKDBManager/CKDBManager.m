//
//  CKDBManager.m
//  UserData
//
//  Created by ZHK on 2018/7/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "CKDBManager.h"
#import <CloudKit/CloudKit.h>

@implementation CKDBManager

#pragma mark -

+ (void)recordsWithName:(NSString *)name block:(void(^)(NSArray <CKDBBaseRecord *>*records))block {
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:name predicate:predicate];
    [[self dataBase] performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if (block) {
            block([CKDBBaseRecord recordsWithCKRecords:results]);
        }
    }];
}

+ (void)saveRecords:(NSArray *)records block:(void(^)(BOOL success))block {
    
}

+ (CKDatabase *)dataBase {
    return [CKContainer defaultContainer].privateCloudDatabase;
}

@end
