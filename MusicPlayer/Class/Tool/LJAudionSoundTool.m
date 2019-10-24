//
//  LJAudionSoundTool.m
//  录音
//
//  Created by 刘家俊 on 17/4/3.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "LJAudionSoundTool.h"

@implementation LJAudionSoundTool

static NSMutableDictionary *_soundIDs; //这里只能设置静态
static NSMutableDictionary *_players; //这里只能设置静态

+ (void)initialize
{
    _soundIDs = [NSMutableDictionary dictionary];
    _players = [NSMutableDictionary dictionary];
}

+ (AVAudioPlayer *)LJ_StartMusicWithFileName:(NSString *)fileName
{
    //1.创建空的播放器
    AVAudioPlayer *player = nil;
    
    //2.从字典中取出播放器
    player = _players[fileName];
    
    //3.判断播放器是否为空
    if (player == nil) {
        //4.生成对应音乐资源
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        
        if (url == nil) return nil;
        
        //5.创建对应的播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        //6.保存播放器到字典中
        [_players setObject:player forKey:fileName];
        
        //7.准备播放
        [player prepareToPlay];
    }
    
    //8.准备播放
    [player play];
    
    return player;
}

+ (void)LJ_PauseMusicWithFileName:(NSString *)fileName
{
    //1.从字典中取出播放器
    AVAudioPlayer *player = _players[fileName];
    
    //2.暂停音乐
    if (player) {
        [player pause];
    }
}

+ (void)LJ_StopMusicWithFileName:(NSString *)fileName
{
    //1.从字典中取出播放器
    AVAudioPlayer *player = _players[fileName];
    
    //2.停止播放
    if (player) {
        [player stop];
        [_players removeObjectForKey:fileName];
        player = nil;
    }
    
}

+ (void)LJ_PlaySoundWithSoundName:(NSString *)soundName
{
    //1.创建soundID = 0
    SystemSoundID soundID = 0;
    
    //2.从字典中取出soundID
    soundID = [_soundIDs[soundName] unsignedIntValue];
    
    //3.判断soundID是否为0
    if (soundID == 0) {
        //3.1生成soundID
        CFURLRef url = (__bridge CFURLRef)[[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        AudioServicesCreateSystemSoundID(url, &soundID);
        
        //3.2将soundID保存到字典中
        [_soundIDs setObject:@(soundID) forKey:soundName];
    }
    
    //4.播放音效
    AudioServicesPlaySystemSound(soundID);
}

@end
