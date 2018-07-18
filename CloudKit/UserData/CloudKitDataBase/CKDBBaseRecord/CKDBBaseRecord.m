//
//  CKDBBaseRecord.m
//  UserData
//
//  Created by ZHK on 2018/7/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "CKDBBaseRecord.h"
#import <CloudKit/CloudKit.h>

@implementation CKDBBaseRecord

#pragma mark - Init

+ (NSArray <CKDBBaseRecord *>*)recordsWithCKRecords:(NSArray <CKRecord *>*)records {
    if (records.count == 0) {
        return @[];
    }
    NSMutableArray *temp = [NSMutableArray new];
    for (CKRecord *record in records) {
        CKDBBaseRecord *rd = [[CKDBBaseRecord alloc] init];
        rd.record = record;
        [temp addObject:rd];
    }
    return temp;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    [self.record setValue:title forKey:@"title"];
}

- (void)setContent:(NSString *)content {
    [self.record setValue:content forKey:@"content"];
}

- (void)setDate:(NSInteger)date {
    [self.record setValue:@(date) forKey:@"date"];
}

- (void)setSync:(BOOL)sync {
    [self.record setValue:@(sync) forKey:@"sync"];
}

- (void)setRecordId:(NSString *)recordId {
    [self.recordId setValue:recordId forKey:@"recordId"];
}

#pragma mark - Getter

- (NSString *)title {
    return [_record valueForKey:@"title"];
}

- (NSString *)content {
    return [_record valueForKey:@"content"];
}

- (NSInteger)date {
    return [[_record valueForKey:@"date"] integerValue];
}

- (BOOL)sync {
    return [[_record valueForKey:@"sync"] boolValue];
}

- (NSString *)recordId {
    return [_record valueForKey:@"recordId"];;
}

- (CKRecord *)record {
    if (_record == nil) {
        self.record = [[CKRecord alloc] initWithRecordType:@"Notes"];
    }
    return _record;
}

@end
