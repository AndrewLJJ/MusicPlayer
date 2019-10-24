//
//  LJJLrcView.h
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/6.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJJLrcLabel;

@interface LJJLrcView : UIScrollView

/* 歌词名 */
@property (nonatomic, copy) NSString *lrcName;

/* 当前播放器播放的时间 */
@property (nonatomic, assign) NSTimeInterval currentTime;

/* 主界面歌词的label */
@property (nonatomic, weak) LJJLrcLabel *lrcLabel;

/* 当前播放器的总时间 */
@property (nonatomic, assign) NSTimeInterval duration;



@end
