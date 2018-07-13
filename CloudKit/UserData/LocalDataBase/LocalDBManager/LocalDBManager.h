//
//  LocalDBBaseManager.h
//  UserData
//
//  Created by ZHK on 2018/7/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalDBRecord.h"


@interface LocalDBManager : NSObject

/**
 保存记录操作结果

 @param records 记录对象
 @param block   执行结果回调
 */
- (void)saveRecords:(NSArray <LocalDBRecord>*)records block:(void(^)(BOOL success))block;

/**
 查询数据

 @param className 查询的数据记录类
 @param block     查询结果回调
 */
- (void)baseRecordsWithDataClass:(Class<LocalDBRecord>)className block:(void(^)(NSArray *records))block;

@end
