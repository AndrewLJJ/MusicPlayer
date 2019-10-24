//
//  LJJMusicTool.h
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/4.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJJMusic;

@interface LJJMusicTool : NSObject

/** 所有音乐 */
+ (NSArray *)musics;

/** 当前正在播放的音乐 */
+ (LJJMusic *)playingMusic;

/** 设置默认的音乐 */
+ (void)setupPlayingMusic:(LJJMusic *)playingMusic;

/** 返回上一首音乐 */
+ (LJJMusic *)previousMusic;

/** 返回下一首音乐 */
+ (LJJMusic *)nextMusic;

@end
