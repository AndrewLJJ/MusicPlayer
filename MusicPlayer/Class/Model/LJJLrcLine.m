//
//  LJJLrcLine.m
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/6.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "LJJLrcLine.h"

@implementation LJJLrcLine

- (instancetype)initWithLrcLineString:(NSString *)lrcLineString
{
    if (self = [super init]) {
        //[00:00.00]月半小夜曲 李克勤
        //这里是取 “月半小夜曲 李克勤”
        //这行代码是以“]”为分隔线分成两个元素
        NSArray *lrcArray = [lrcLineString componentsSeparatedByString:@"]"];
        self.text = lrcArray[1];
        self.time = [self timeWithString:[lrcArray[0] substringFromIndex:1]];
    }
    return self;
}

+ (instancetype)lrcLineString:(NSString *)lrcLineString
{
    return [[self alloc] initWithLrcLineString:lrcLineString];
}

- (NSTimeInterval)timeWithString:(NSString *)timeString
{
    //00:23.00
    NSInteger min = [[timeString componentsSeparatedByString:@":"][0] integerValue];
    NSInteger sec = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger hs = [[timeString componentsSeparatedByString:@"."][1] integerValue];
    
    return min * 60 + sec + hs * 0.01;
}

@end
