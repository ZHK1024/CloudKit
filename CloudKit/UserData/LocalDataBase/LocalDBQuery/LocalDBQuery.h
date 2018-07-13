//
//  LocalDBQuery.h
//  UserData
//
//  Created by ZHK on 2018/7/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalDBQuery : NSObject

@property (nonatomic, strong) NSString *exetuteQuery;
//@property (nonatomic, strong) NSString *createQuery;
@property (nonatomic, strong) NSArray  *arguments;

@end
