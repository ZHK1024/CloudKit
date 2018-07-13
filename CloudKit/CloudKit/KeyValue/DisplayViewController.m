//
//  DisplayViewController.m
//  iCloud
//
//  Created by ZHK on 2017/12/12.
//  Copyright © 2017年 ZHK. All rights reserved.
//

#import "DisplayViewController.h"
#import <CloudKit/CloudKit.h>

@interface DisplayViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 355, 0)];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *db = container.privateCloudDatabase;
    [db fetchRecordWithID:_record.recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        NSLog(@"record = %@", record);
        dispatch_async(dispatch_get_main_queue(), ^{
            label.text = [record valueForKey:@"content"];
            self.title = [record valueForKey:@"title"];
            [label sizeToFit];
        });
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
