//
//  LocalDBRecord.h
//  CloudKit
//
//  Created by ZHK on 2018/7/12.
//Copyright © 2018年 ZHK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalDataBaseDefines.h"
#import "LocalDBQuery.h"

@class FMResultSet;
@protocol LocalDBRecord <NSObject>

//@property (nonatomic, strong, readonly) NSString *dbName;
@property (nonatomic, strong, readonly) LocalDBQuery *query;
@property (nonatomic, assign) DBOperations            operation;

/**
 获取建表 sql
 */
+ (NSString *)createQuery;


/**
 获取查询 sql
 */
+ (NSString *)selectQuery;

/**
 根据查询结果批量实例化对象

 @param resultSet 数据库查询结果对象
 @return 结果对象数组
 */
+ (NSArray *)recordsWithResultSet:(FMResultSet *)resultSet;

@end
