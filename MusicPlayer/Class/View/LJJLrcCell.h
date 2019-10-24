//
//  LJJLrcCell.h
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/6.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJJLrcLabel;

@interface LJJLrcCell : UITableViewCell

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

/* lrcLabel */
@property (nonatomic, weak) LJJLrcLabel *lrcLabel;


@end
