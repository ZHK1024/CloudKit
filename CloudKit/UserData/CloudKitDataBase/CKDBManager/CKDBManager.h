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

+ (void)recordsWithName:(NSString *)name block:(void(^)(NSArray <CKDBBaseRecord *>*records))block;

+ (void)saveRecords:(NSArray *)records block:(void(^)(BOOL success))block;

@end
