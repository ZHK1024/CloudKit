//
//  LoclaDBBaseRecord.h
//  UserData
//
//  Created by ZHK on 2018/7/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "LocalDBRecord.h"

@class FMResultSet, LocalDBQuery;
@interface LocalDBBaseRecord : NSObject <LocalDBRecord>

@property (nonatomic, strong, readonly) LocalDBQuery *query;
@property (nonatomic, assign) DBOperations            operation;

@property (nonatomic, strong) NSString  *recordId;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *content;
@property (nonatomic, assign) NSInteger  date;
@property (nonatomic, assign) BOOL       sync;

+ (NSArray *)recordsWithResultSet:(FMResultSet *)resultSet;

@end
