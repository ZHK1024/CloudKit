//
//  NSDate+Uniq.m
//  CloudKit
//
//  Created by ZHK on 2018/7/12.
//Copyright © 2018年 ZHK. All rights reserved.
//

#import "NSDate+Uniq.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSDate (Uniq)

+ (NSString *)uniqText {
    NSString *text = [NSString stringWithFormat:@"%f%u", CFAbsoluteTimeGetCurrent(), arc4random() % 100000];
    return text;
}

@end
