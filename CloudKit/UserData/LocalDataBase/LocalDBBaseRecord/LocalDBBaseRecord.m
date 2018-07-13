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

static NSString *const DBName = @"Note";

#define GETTER_SAFE(type, name, default) - (type *)name {return _##name ? : default;}

@interface LocalDBBaseRecord ()

@property (nonatomic, strong) NSString *insertQuery;
@property (nonatomic, strong) NSString *deleteQuery;
@property (nonatomic, strong) NSString *updateQuery;

@property (nonatomic, assign) NSString *recordId;

@end

@implementation LocalDBBaseRecord

#pragma mark -

- (instancetype)initWithResultSet:(FMResultSet *)resuleSet {
    if (self = [super init]) {
        self.recordId = [resuleSet stringForColumn:@"id"];
        self.title    = [resuleSet stringForColumn:@"title"];
        self.content  = [resuleSet stringForColumn:@"content"];
        self.date     = [resuleSet intForColumn:@"date"];
        
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
            query.exetuteQuery = [NSString stringWithFormat:@"INSERT INTO %@ (`title`, `ckid`, `content`, `date`) VALUES(?, ?, ?, ?)", DBName];
            query.arguments = @[self.title, self.ckId, self.content, @(self.date)];
            break;
        case DBOperationUpdate:
            query.exetuteQuery = [NSString stringWithFormat:@"UPDATE %@ SET `title` = ?, `ckid` = ?, `content` = ?, `date` = ? WHERE id = ?", DBName];
            query.arguments = @[self.title, self.ckId, self.content, @(self.date), self.recordId];
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

GETTER_SAFE(NSString, ckId, @"")
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

+ (NSString *)createQuery {
    return [NSString stringWithFormat:
            @"CREATE TABLE IF NOT EXISTS %@("
            "id           TEXT PRIMARY KEY,"// id
            "ckid         TEXT,"            // Cloud Id
            "title        TEXT,"            // 附加信息标题
            "content      TEXT,"            // 附加信息内容
            "date         INTEGER"          // 时间
            ");", DBName];
}

@end
