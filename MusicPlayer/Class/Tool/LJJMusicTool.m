//
//  LJJMusicTool.m
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/4.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "LJJMusicTool.h"
#import <MJExtension.h>
#import "LJJMusic.h"

@implementation LJJMusicTool

static NSArray *_musics;
static LJJMusic *_playingMusic;

+ (void)initialize
{
    if (_musics == nil) {
        _musics = [LJJMusic mj_objectArrayWithFilename:@"Musics.plist"];
    }
    
    if (_playingMusic == nil) {
        _playingMusic = _musics[0];//默认播放第一首歌
    }
}

/** 所有音乐 */
+ (NSArray *)musics
{
    return _musics;
}

/** 当前正在播放的音乐 */
+ (LJJMusic *)playingMusic
{
    return _playingMusic;
}

/** 设置默认的音乐 */
+ (void)setupPlayingMusic:(LJJMusic *)playingMusic
{
    _playingMusic = playingMusic;
}

/** 返回上一首音乐 */
+ (LJJMusic *)previousMusic
{
    //1.获取当前音乐下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    //2.获取上一首音乐的下标值
    NSInteger previousIndex = --currentIndex;
    LJJMusic *previousMusic = nil;//如果当前播放的是第一首，上一首会为空
    if (previousIndex < 0) {
        previousIndex = _musics.count - 1;
    }
    previousMusic = _musics[previousIndex];
    
    return previousMusic;
}

/** 返回下一首音乐 */
+ (LJJMusic *)nextMusic
{
    //1.获取当前音乐下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    //2.获取下一首音乐的下标值
    NSInteger nextIndex = ++currentIndex;
    LJJMusic *nextMusic = nil;//如果当前播放的是最后一首，下一首会为空
    if (nextIndex >= _musics.count) {
        nextIndex = 0;
    }
    nextMusic = _musics[nextIndex];
    
    return nextMusic;
}

@end
