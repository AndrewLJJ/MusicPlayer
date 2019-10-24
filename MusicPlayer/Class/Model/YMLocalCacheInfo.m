//
//  YMLocalCacheInfo.m
//  MusicPlayer
//
//  Created by Andrew on 2019/10/23.
//  Copyright © 2019 余默. All rights reserved.
//

#import "YMLocalCacheInfo.h"

@implementation YMLocalCacheInfo

/** 播放模式 */
NSString * const YM_playMode = @"ym_playMode";

static NSUserDefaults *userInfoDefaults;

+ (void)initialize
{
    userInfoDefaults = [NSUserDefaults standardUserDefaults];
}

/** 保存播放模式 */
+ (void)savePlayMode:(NSString *)playMode {
    [userInfoDefaults removeObjectForKey:YM_playMode];
    [userInfoDefaults setValue:playMode forKey:YM_playMode];
    [userInfoDefaults synchronize];
}

/** 取出播放模式 */
+ (NSInteger)getPlayMode {
    NSString *playMode = [userInfoDefaults objectForKey:YM_playMode];
    return [playMode integerValue];
}

@end
