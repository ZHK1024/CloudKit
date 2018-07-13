//
//  CKDBBaseRecord.h
//  UserData
//
//  Created by ZHK on 2018/7/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CKRecord;
@interface CKDBBaseRecord : NSObject

@property (nonatomic, strong) CKRecord *record;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger date;


+ (NSArray <CKDBBaseRecord *>*)recordsWithCKRecords:(NSArray <CKRecord *>*)records;

@end