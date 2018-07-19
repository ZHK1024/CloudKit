//
//  LoclaDBBaseRecord.m
//  UserData
//
//  Created by ZHK on 2018/7/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "LocalDBBaseRecord.h"
#import <FMResultSet.h>
#import "NSString+Encrypt.h"
#import "LocalDBQuery.h"

static NSString *const DBName = @"Note";

#define GETTER_SAFE(type, name, default) - (type *)name {return _##name ? : default;}

@interface LocalDBBaseRecord ()

@property (nonatomic, strong) NSString *insertQuery;
@property (nonatomic, strong) NSString *deleteQuery;
@property (nonatomic, strong) NSString *updateQuery;

@end

@implementation LocalDBBaseRecord

#pragma mark -

- (instancetype)initWithResultSet:(FMResultSet *)resuleSet {
    if (self = [super init]) {
        self.recordId = [resuleSet stringForColumn:@"id"];
        self.title    = [resuleSet stringForColumn:@"title"];
        self.content  = [resuleSet stringForColumn:@"content"];
        self.date     = [resuleSet intForColumn:@"date"];
        self.sync     = [resuleSet boolForColumn:@"sync"];
    }
    return self;
}

+ (NSArray *)recordsWithResultSet:(FMResultSet *)resultSet {
    NSMutableArray *temp = [NSMutableArray new];
    while ([resultSet next]) {
        LocalDBBaseRecord *record = [[LocalDBBaseRecord alloc] initWithResultSet:resultSet];
        [temp addObject:record];
    }
    return temp;
}

#pragma mark - Getter

- (LocalDBQuery *)query {
    LocalDBQuery *query = [[LocalDBQuery alloc] init];

    switch (_operation) {
        case DBOperationAdd:
            query.exetuteQuery = [NSString stringWithFormat:@"INSERT INTO %@ (`id`, `title`, `content`, `date`, `sync`) VALUES(?, ?, ?, ?, ?)", DBName];
            query.arguments = @[self.recordId, self.title, self.content, @(self.date), @(self.sync)];
            break;
        case DBOperationUpdate:
            query.exetuteQuery = [NSString stringWithFormat:@"UPDATE %@ SET `title` = ?, `content` = ?, `date` = ?, `sync` = ? WHERE id = ?", DBName];
            query.arguments = @[self.title, self.content, @(self.date), @(self.sync), self.recordId];
            break;
        case DBOperationDelete:
            query.exetuteQuery = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = ?", DBName];
            query.arguments = @[self.recordId];
            break;
        default:
            break;
    }
    return query;
}

//GETTER_SAFE(NSString, recordId, @"")
GETTER_SAFE(NSString, title, @"")
GETTER_SAFE(NSString, content, @"")

- (NSString *)recordId {
    if (_recordId == nil) {
        self.recordId = [[NSString stringWithFormat:@"%f%u", CFAbsoluteTimeGetCurrent(), arc4random() % 1000000] sha1];
    }
    return _recordId;
}

+ (NSString *)selectQuery {
    return [NSString stringWithFormat:@"SELECT * FROM %@", DBName];
}

+ (NSString *)unsyncQuery {
    return [NSString stringWithFormat:@"SELECT * FROM %@ WHERE sync = 0", DBName];
}

+ (NSString *)markSyncedQuery {
    return [NSString stringWithFormat:@"UPDATE %@ SET sync = 1 WHERE id in", DBName];
}

+ (NSString *)createQuery {
    return [NSString stringWithFormat:
            @"CREATE TABLE IF NOT EXISTS %@("
            "id           TEXT PRIMARY KEY,"    // id
            "title        TEXT,"                // 附加信息标题
            "content      TEXT,"                // 附加信息内容
            "date         INTEGER,"             // 时间
            "sync         BOOL"                 // 是否已与 CloudKit 进行同步
            ");", DBName];
}

@end
