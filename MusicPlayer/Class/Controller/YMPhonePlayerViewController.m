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


@interface YMPhonePlayerViewController ()

/** 渐变背景 */
@property (nonatomic, weak) KTGradientView                 *backView;
/** 手机播放器控件View */
@property (nonatomic, weak) YMPhonePlayerColView                 *phonePlayerColView;

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
    
    self.phonePlayerColView.musicModels = self.musicModels;
    
    [self loadDataPlayer];
}

//初始化播放器 界面赋值
- (void)loadDataPlayer {
    YMModel *model = self.musicModels[self.index];
    NSURL *url = [NSURL URLWithString:model.url];
    
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
        [ws.phonePlayerColView startPlayingMusic];
    };
    
    player.finishPlayBlock = ^(NSURL * _Nonnull URL) {
        YMLog(@"播放完成:%@",URL);
    };
    
    [player ym_playWithURL:url];
}

@end
