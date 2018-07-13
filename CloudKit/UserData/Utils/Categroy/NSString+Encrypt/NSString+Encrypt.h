//
//  NSString+Encrypt.h
//  WeiQianDai
//
//  Created by ZHK on 2017/3/13.
//  Copyright © 2017年 Weiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

- (NSString *)sha1;

- (NSString *)toBase64String;

- (NSString *)base64Decode;

- (NSString *)toJsonString;

@end
