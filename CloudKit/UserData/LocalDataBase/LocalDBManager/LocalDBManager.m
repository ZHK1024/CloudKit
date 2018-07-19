//
//  LocalDBBaseManager.m
//  UserData
//
//  Created by ZHK on 2018/7/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "LocalDBManager.h"
#import <FMDB.h>
#import "LocalDBRecord.h"
#import "LocalDBQuery.h"
//static FMDatabaseQueue *dbQueue = nil;

@interface LocalDBManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation LocalDBManager

- (void)saveRecords:(NSArray <LocalDBRecord>*)records block:(void(^)(BOOL success))block {
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db open];
        for (id <LocalDBRecord> record in records) {
            if (record.query.exetuteQuery == nil) {
                continue;
            }
            [db executeUpdate:[[record class] createQuery]];
            [db executeUpdate:record.query.exetuteQuery withArgumentsInArray:record.query.arguments];
        }
        [db close];
        // 主队列调用, 防止数据库队列嵌套, 造成死锁
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(YES);
            }
        });
    }];
}

- (void)baseRecordsWithDataClass:(Class<LocalDBRecord>)className block:(void(^)(NSArray *records))block {
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db open];
        [db executeUpdate:[className createQuery]];
        FMResultSet *result = [db executeQuery:[className selectQuery]];
        NSArray *records = [className recordsWithResultSet:result];
        [db close];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(records);
            }
        });
    }];
}

- (void)baseUnsyncRecordsWithDataClass:(Class<LocalDBRecord>)className block:(void(^)(NSArray *records))block {
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db open];
        [db executeUpdate:[className createQuery]];
        FMResultSet *result = [db executeQuery:[className unsyncQuery]];
        NSArray *records = [className recordsWithResultSet:result];
        [db close];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(records);
            }
        });
    }];
}

- (void)markRecordSuncedWithDataClass:(Class<LocalDBRecord>)className recordIds:(NSArray *)recordIDs block:(void(^)(BOOL finish))block {
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db open];
        [db executeUpdate:[className createQuery]];
        
        NSString *query = [NSString stringWithFormat:@"%@ ('%@')", [className markSyncedQuery], [recordIDs componentsJoinedByString:@"','"]];
        [db executeUpdate:query];
        [db close];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(YES);
            }
        });
    }];
}

#pragma mark - Getter

- (FMDatabaseQueue *)dbQueue {
    if (_dbQueue == nil) {
        NSString *DBFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/local_db"];
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:DBFilePath];
    }
    return _dbQueue;
}

@end
