//
//  NotesListCell.h
//  iCloud
//
//  Created by ZHK on 2017/12/14.
//  Copyright © 2017年 ZHK. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const NotesListCell_INDEF;

@interface NotesListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel     *titleLabel;

@end
