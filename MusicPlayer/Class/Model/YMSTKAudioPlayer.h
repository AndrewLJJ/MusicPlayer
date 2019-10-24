//
//  YMSTKAudioPlayer.h
//  MusicPlayer
//
//  Created by Andrew on 2019/10/22.
//  Copyright © 2019 余默. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STKAudioPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMSTKAudioPlayer : NSObject

/** 播放失败重试次数 默认1 */
@property (nonatomic, assign) NSInteger                     replayFailCount;
/** 刷新频率，默认0秒-不刷新，大于0才会刷新 */
@property (nonatomic, assign) NSTimeInterval                 refreshTimeInterval;
/** 音频长度 */
@property (nonatomic, assign, readonly) double               duration;
/** 播放长度 */
@property (nonatomic, assign, readonly) double               progress;
/** 播放状态 */
@property (nonatomic, assign, readonly) STKAudioPlayerState  state;
/** 当前播放的音频地址 */
@property (nonatomic, strong, readonly, nullable) NSURL      *currentURL;
/** 刷新的回调，单例状态下请记得释放 */
@property (nonatomic, copy, nullable) void(^refreshBlock)(double duration, double progress, STKAudioPlayerState state, STKAudioPlayerErrorCode errorCode);
/** 开始播放的回调 */
@property (nonatomic, copy, nullable) void(^startPlayBlock)(NSURL *URL);
/** 播放完成的回调 */
@property (nonatomic, copy, nullable) void(^finishPlayBlock)(NSURL *URL);

/**
 单例
 */
+ (instancetype)shareInstance;

/**
 播放指定音频
 
 @param URL 音频地址
 */
- (void)ym_playWithURL:(NSURL *)URL;

/**
 暂停
 */
- (void)ym_pause;

/**
 继续
 */
- (void)ym_resume;

/**
 结束播放
 */
- (void)ym_stop;

/**
 从指定时间开始播放
 
 @param time 开始播放的时间
 */
- (void)ym_seekToTime:(double)time;

@end

NS_ASSUME_NONNULL_END
