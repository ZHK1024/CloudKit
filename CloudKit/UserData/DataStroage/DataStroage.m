//
//  DataStroage.m
//  UserData
//
//  Created by ZHK on 2018/7/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import "DataStroage.h"
#import "LocalDBManager.h"
#import "CKDBManager.h"

@interface DataStroage ()

@property (nonatomic, strong) LocalDBManager *LDBManager;

@end

@implementation DataStroage

- (void)saveRecord:(id <LocalDBRecord>)record {
    
}

+ (void)download {
    [CKDBManager recordsWithName:@"Note" block:^(NSArray<CKDBBaseRecord *> *records) {
        
    }];
}

+ (void)upload {
    
}

#pragma mark -

+ (void)records:(void(^)(NSArray *records))block {
    
}

#pragma mark - Getter

- (LocalDBManager *)LDBManager {
    if (_LDBManager == nil) {
        self.LDBManager = [[LocalDBManager alloc] init];
    }
    return _LDBManager;
}

@end
