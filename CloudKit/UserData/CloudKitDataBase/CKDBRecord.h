//
//  CKDBRecord.h
//  CloudKit
//
//  Created by ZHK on 2018/7/12.
//Copyright © 2018年 ZHK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CKRecord;
@protocol CKDBRecord <NSObject>

- (instancetype)initWithReocrdName:(NSString *)recordName;
- (void)updateRecord:(CKRecord *)record;

@end
