//
//  YMPhonePlayerColView.h
//  MusicPlayer
//
//  Created by Andrew on 2019/9/11.
//  Copyright © 2019 余默. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMProgressSlider.h"

NS_ASSUME_NONNULL_BEGIN

#define PhonePlayerColView_Height 146

typedef NS_ENUM (NSInteger,YMSTKAudioPlayerPlayMode) {
    YMSTKAudioPlayerPlayModeCycle = 1,     //顺序循环 默认。
    YMSTKAudioPlayerPlayModeSingleCycle = 2,    //单曲循环。
    YMSTKAudioPlayerPlayModeShuffleCycle = 3    //随机循环
};

@interface YMPhonePlayerColView : UIView

/** 当前播放时间 */
@property (nonatomic, assign) double currentTime;
/** 总时长 */
@property (nonatomic, assign) double totalTime;
/** 播放进度 */
@property (nonatomic, assign) double  progressValue;
/** 播放mode */
@property (nonatomic, assign) YMSTKAudioPlayerPlayMode playMode;

/** 开始播放 */
- (void)startPlayingMusic;
/** 暂停播放 */
- (void)pausePlayingMusic;

@end

NS_ASSUME_NONNULL_END
