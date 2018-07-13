//
//  DataStroage.h
//  UserData
//
//  Created by ZHK on 2018/7/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalDBRecord.h"

@interface DataStroage : NSObject

- (void)saveRecord:(id <LocalDBRecord>)record;

+ (void)records:(void(^)(NSArray *records))block;

+ (void)download;

+ (void)upload;

@end
