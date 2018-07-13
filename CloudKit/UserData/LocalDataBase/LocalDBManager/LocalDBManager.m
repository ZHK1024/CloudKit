//
//  LocalDBBaseManager.m
//  UserData
//
//  Created by ZHK on 2018/7/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "LocalDBManager.h"
#import <FMDB.h>

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
        if (block) {
            block(YES);
        }
    }];
}

- (void)baseRecordsWithDataClass:(Class<LocalDBRecord>)className block:(void(^)(NSArray *records))block {
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db open];
        [db executeUpdate:[className createQuery]];
        FMResultSet *result = [db executeQuery:[className selectQuery]];
        if (block) {
            block([className recordsWithResultSet:result]);
        }
        [db close];
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
