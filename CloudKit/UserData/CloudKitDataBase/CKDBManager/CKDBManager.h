//
//  CKDBManager.h
//  UserData
//
//  Created by ZHK on 2018/7/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKDBBaseRecord.h"

@class CKRecord;
@interface CKDBManager : NSObject

/**
 查询库内记录

 @param name  库名称
 @param block 回调
 */
+ (void)recordsWithName:(NSString *)name block:(void(^)(NSArray <CKDBBaseRecord *>*records))block;

/**
 保存记录

 @param records  记录数组
 @param complete 执行完成回调
 */
+ (void)saveRecords:(NSArray *)records complete:(void(^)(NSArray *recordIDs, NSError *error))complete;

@end
