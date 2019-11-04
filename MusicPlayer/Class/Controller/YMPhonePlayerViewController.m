//
//  YMPhonePlayerViewController.m
//  MusicPlayer
//
//  Created by Andrew on 2019/9/6.
//  Copyright © 2019 余默. All rights reserved.
//

#import "YMPhonePlayerViewController.h"
#import "KTGradientView.h"
#import "YMPhonePlayerColView.h"
#import "UIView+YMExtension.h"
#import "YMSTKAudioPlayer.h"
#import "YMModel.h"
#import "YMIconView.h"


@interface YMPhonePlayerViewController ()

/** 渐变背景 */
@property (nonatomic, weak) KTGradientView                 *backView;
/** 手机播放器控件View */
@property (nonatomic, weak) YMPhonePlayerColView                 *phonePlayerColView;
/** 封面图 */
@property (nonatomic, weak) YMIconView                 *iconView;

@end

@implementation YMPhonePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navigationBar.hidden = YES;
    
    [self initView];
}

#pragma mark - 初始化空间
- (void)initView {
    //颜色渐变
    KTGradientView *backView = [[KTGradientView alloc] initWithFromColor:YMColor(5, 82, 95) toColor:YMColor(7, 100, 118) direction:KTGradientDirectionToTop];
    backView.frame = CGRectMake(0, Height_NavBar, SCREEN_WIDTH, self.viewHeight);
    [self.view addSubview:backView];
    self.backView = backView;
    
    //音频控件
    CGFloat playColViewY = self.viewHeight - PhonePlayerColView_Height;
    YMPhonePlayerColView *phonePlayerColView = [YMPhonePlayerColView ym_viewFormXib];
    phonePlayerColView.frame = CGRectMake(0, playColViewY, SCREEN_WIDTH, PhonePlayerColView_Height);
    phonePlayerColView.playMode = YMSTKAudioPlayerPlayModeCycle;
    [self.view addSubview:phonePlayerColView];
    self.phonePlayerColView = phonePlayerColView;
    
    //封面图
    CGFloat iconH = SCREEN_HEIGHT - PhonePlayerColView_Height - Height_NavBar - 40;
    CGFloat iconY = Height_NavBar + 20;
    CGFloat iconX = 0;
    CGFloat iconW = SCREEN_WIDTH;
    YMIconView *iconView = [YMIconView ym_viewFormXib];
    iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    [self.view addSubview:iconView];
    self.iconView = iconView;
    
    self.phonePlayerColView.musicModels = self.musicModels;
    
    [self loadDataPlayer];
}

//初始化播放器 界面赋值
- (void)loadDataPlayer {
    YMModel *model = self.musicModels[self.index];
    NSURL *url = [NSURL URLWithString:model.url];
    self.phonePlayerColView.currentModel = model; //当前播放的音频model
    
    YMSTKAudioPlayer *player = [YMSTKAudioPlayer shareInstance];
    player.refreshTimeInterval = 1;
    
    WS(ws);
    player.refreshBlock = ^(double duration, double progress, STKAudioPlayerState state, STKAudioPlayerErrorCode errorCode) {
        YMLog(@"时长：%f",duration);
        YMLog(@"进度：%f",progress);
        YMLog(@"播放状态：%ld",(long)state);
        YMLog(@"播放error：%ld",(long)errorCode);
        
        //音频时长
        ws.phonePlayerColView.totalTime = duration;
        ws.phonePlayerColView.currentTime = progress;
        ws.phonePlayerColView.progressValue = progress;
        
        switch (state) {
            case STKAudioPlayerStateReady: //准备播放
            {
                
            }
                break;
            case STKAudioPlayerStateRunning:
            {
                
            }
                break;
            case STKAudioPlayerStatePlaying:
            {
                
            }
                break;
            case STKAudioPlayerStateBuffering:
            {
                
            }
                break;
            case STKAudioPlayerStatePaused: //暂停
            {
                [ws.phonePlayerColView pausePlayingMusic];
            }
                break;
            case STKAudioPlayerStateStopped: //停止播放
            {
                [ws.phonePlayerColView pausePlayingMusic];
            }
                break;
            case STKAudioPlayerStateDisposed:
            {
                
            }
                break;
            case STKAudioPlayerStateError:
            {
                
            }
                break;
                
            default:
                break;
        }
        
    };
    
    player.startPlayBlock = ^(NSURL * _Nonnull URL) {
        YMLog(@"开始播放:%@",URL);
        [ws.iconView resumeRotate]; //开始转动封面
        [ws.phonePlayerColView startPlayingMusic];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTitle" object:nil userInfo:@{@"name":ws.phonePlayerColView.currentModel.name}];
    };
    
    player.finishPlayBlock = ^(NSURL * _Nonnull URL) {
        YMLog(@"播放完成:%@",URL);
        [ws.iconView stopRotating];//停止动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //当播放完一首歌时，进行下一首
            [ws.phonePlayerColView nextAudio];
        });
    };
    
    [player ym_playWithURL:url];
}

@end
