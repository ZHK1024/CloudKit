
//
//  NotesListCell.m
//  iCloud
//
//  Created by ZHK on 2017/12/14.
//  Copyright © 2017年 ZHK. All rights reserved.
//

#import "NotesListCell.h"

NSString *const NotesListCell_INDEF = @"NotesListCell";

@interface NotesListCell ()

//@property (nonatomic, strong) UIImageView *iconView;
//@property (nonatomic, strong) UILabel     *titleLabel;

@end

@implementation NotesListCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
}

#pragma mark - UI

- (void)createUI {
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
}

#pragma mark - Getter

- (UIImageView *)iconView {
    if (_iconView == nil) {
        self.iconView = [UIImageView new];
        _iconView.frame = CGRectMake(10, 10, 40, 40);
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        self.titleLabel = [UILabel new];
        _titleLabel.frame = CGRectMake(80, 15, 200, 30);
    }
    return _titleLabel;
}

@end
