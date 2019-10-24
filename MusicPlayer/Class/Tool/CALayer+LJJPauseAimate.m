//
//  CALayer+LJJPauseAimate.m
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/5.
//  Copyright © 2017年 Andrew. All rights reserved.
//

/**
 * CFTimeInterval日期之间相隔的秒数的简单方法
 */

#import "CALayer+LJJPauseAimate.h"

@implementation CALayer (LJJPauseAimate)



- (void)pauseAnimate
{
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}

- (void)resumeAnimate
{
    CFTimeInterval pausedTime = [self timeOffset];
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}

@end
