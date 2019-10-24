//
//  LJAudionSoundTool.h
//  录音
//
//  Created by 刘家俊 on 17/4/3.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LJAudionSoundTool : NSObject


/**
 播放音乐

 @param fileName 音乐文件名
 */
//+ (void)LJ_StartMusicWithFileName:(NSString *)fileName;
+ (AVAudioPlayer *)LJ_StartMusicWithFileName:(NSString *)fileName;//因为需要获取音乐的时长

/**
 暂停播放
 
 @param fileName 音乐文件名
 */
+ (void)LJ_PauseMusicWithFileName:(NSString *)fileName;

/**
  停止播放
 
 @param fileName 音乐文件名
 */
+ (void)LJ_StopMusicWithFileName:(NSString *)fileName;

/**
 播放音效

 @param soundName 音效文件名
 */
+ (void)LJ_PlaySoundWithSoundName:(NSString *)soundName;

@end
