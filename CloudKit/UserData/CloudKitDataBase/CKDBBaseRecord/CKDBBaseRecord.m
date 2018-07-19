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

- (instancetype)initWithReocrdName:(NSString *)recordName {
    if (self = [super init]) {
        CKRecordID *recordId = [[CKRecordID alloc] initWithRecordName:recordName];
        self.record = [[CKRecord alloc] initWithRecordType:@"Notes" recordID:recordId];
    }
    return self;
}

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

- (void)updateRecord:(CKRecord *)record {
    [record setValue:self.title forKey:@"title"];
    [record setValue:self.content forKey:@"content"];
    [record setValue:@(self.date) forKey:@"date"];
    [record setValue:@(self.sync) forKey:@"sync"];
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

#pragma mark - Getter

- (NSString *)title {
    return [self.record valueForKey:@"title"];
}

- (NSString *)content {
    return [self.record valueForKey:@"content"];
}

- (NSInteger)date {
    return [[self.record valueForKey:@"date"] integerValue];
}

- (BOOL)sync {
    return [[self.record valueForKey:@"sync"] boolValue];
}

- (NSString *)recordId {
    return self.record.recordID.recordName;
}

@end
