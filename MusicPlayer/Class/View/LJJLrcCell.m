//
//  LJJLrcCell.m
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/6.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "LJJLrcCell.h"
#import "LJJLrcLabel.h"
#import <Masonry.h>

@implementation LJJLrcCell

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LJJLrcCell";
    LJJLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LJJLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //1.初始化LJJLrcLabel
        LJJLrcLabel *lrcLabel = [[LJJLrcLabel alloc] init];
        [self.contentView addSubview:lrcLabel];
        self.lrcLabel = lrcLabel;
        
        [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
        }];
        
        //设置基本属性
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        lrcLabel.textColor = [UIColor whiteColor];
        lrcLabel.font = [UIFont systemFontOfSize:14];
        lrcLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
