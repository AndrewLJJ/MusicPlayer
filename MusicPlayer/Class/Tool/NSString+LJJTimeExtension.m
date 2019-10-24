//
//  NSString+LJJTimeExtension.m
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/5.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "NSString+LJJTimeExtension.h"

@implementation NSString (LJJTimeExtension)

+ (NSString *)stringWithTime:(NSTimeInterval)time
{
    NSInteger min = time / 60;
    /**
     (int)time % 60
     
     *  因为定时器是一秒后执行，开始播放的时候，进度条已经开始滑动，但时间还没有跳动
     
     round(time)
     */
    NSInteger sec = (int)round(time) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}

@end
