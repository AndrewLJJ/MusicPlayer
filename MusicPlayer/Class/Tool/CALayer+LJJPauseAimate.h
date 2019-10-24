//
//  CALayer+LJJPauseAimate.h
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/5.
//  Copyright © 2017年 Andrew. All rights reserved.
//  停止动画和恢复动画的分类

#import <QuartzCore/QuartzCore.h>

@interface CALayer (LJJPauseAimate)

/**
 * 暂停动画
 */
- (void)pauseAnimate;

/**
 * 恢复动画
 */
- (void)resumeAnimate;

@end
