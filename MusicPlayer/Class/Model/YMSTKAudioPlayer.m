//
//  YMSTKAudioPlayer.m
//  MusicPlayer
//
//  Created by Andrew on 2019/10/22.
//  Copyright © 2019 余默. All rights reserved.
//

#import "YMSTKAudioPlayer.h"

@interface YMSTKAudioPlayer () <STKAudioPlayerDelegate>

/** 播放器 */
@property (nonatomic, strong) STKAudioPlayer *audioPlayer;
/** 刷新计时器 */
@property (nonatomic, strong) NSTimer *refreshTimer;
/** 播放失败已重试次数 */
@property (nonatomic, assign) NSInteger replayUseCountInFail;
/** 当前播放的音频地址 */
@property (nonatomic, strong, readwrite) NSURL *currentURL;

@end

@implementation YMSTKAudioPlayer

+ (instancetype)shareInstance {
    static YMSTKAudioPlayer *player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[YMSTKAudioPlayer alloc] init];
    });
    return player;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (STKAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [[STKAudioPlayer alloc] init];
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}

- (double)duration {
    return _audioPlayer.duration;
}

- (double)progress {
    return _audioPlayer.progress;
}

- (STKAudioPlayerState)state {
    return _audioPlayer.state;
}

- (void)setRefreshTimeInterval:(NSTimeInterval)refreshTimeInterval {
    if (refreshTimeInterval <= 0) {
        _refreshTimeInterval = 0;
    } else {
        _refreshTimeInterval = refreshTimeInterval;
    }
    [self tryLaunchProgressTimer];
}

- (void)setup {
    _replayFailCount = 1;
    _replayUseCountInFail = 0;
    _refreshTimeInterval = 1;
    [self audioPlayer];
}

- (void)ym_seekToTime:(double)time {
    [_audioPlayer seekToTime:time];
}

- (void)ym_playWithURL:(NSURL *)URL {
    _replayUseCountInFail = 0;
    _currentURL = URL;
    
    STKDataSource *dataSource = [STKAudioPlayer dataSourceFromURL:URL];
    [self.audioPlayer playDataSource:dataSource withQueueItemID:URL];
    [self tryLaunchProgressTimer];
}

//暂停
- (void)ym_pause {
    [self.audioPlayer pause];
    [_refreshTimer invalidate];
    _refreshTimer = nil;
}

//继续
- (void)ym_resume {
    [self.audioPlayer resume];
    [self tryLaunchProgressTimer];
}

//停止
- (void)ym_stop {
    [self.audioPlayer stop];
    [_refreshTimer invalidate];
    _refreshTimer = nil;
}

- (void)tryLaunchProgressTimer {
    if (_refreshTimer) {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
    if (_refreshTimeInterval > 0 && (_audioPlayer.state == STKAudioPlayerStateRunning || _audioPlayer.state == STKAudioPlayerStateBuffering || _audioPlayer.state == STKAudioPlayerStatePlaying)) {
        _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:_refreshTimeInterval target:self selector:@selector(refreshTimerHandle) userInfo:nil repeats:YES];
    }
}

- (void)refreshTimerHandle {
    if (_refreshBlock) {
        _refreshBlock(_audioPlayer.duration, _audioPlayer.progress, (_audioPlayer.state == STKAudioPlayerStateError && _replayUseCountInFail < _replayFailCount) ? STKAudioPlayerStateReady : _audioPlayer.state, STKAudioPlayerErrorNone);
    }
}

#pragma mark - 播放器代理
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId {
    YMLog(@"开始播放 : %@",queueItemId);
    
    if (_startPlayBlock) {
        _startPlayBlock(_currentURL);
    }
    
    [self tryLaunchProgressTimer];
}

//当一个项目已完成缓冲时引发(可能是也可能不是当前正在播放的项目)
//如果在播放器上调用seek，则同一项可能引发多次此事件
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId {
    YMLog(@"缓冲完成 : %@",queueItemId);
}

//当播放器状态改变时触发
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState {
    YMLog(@"播放器状态改变:%@",@(state));
    
    if (_refreshBlock) {
        _refreshBlock(audioPlayer.duration, audioPlayer.progress, (_audioPlayer.state == STKAudioPlayerStateError && _replayUseCountInFail < _replayFailCount) ? STKAudioPlayerStateReady : _audioPlayer.state, STKAudioPlayerErrorNone);
    }
}

//当音频播放结束时触发
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration {
    YMLog(@"播放完成:%@",queueItemId);
    
    //播放完成尝试重启计时器，因为播放下一首时，上一首也会调用播放完成，而且可能会延迟调用
    [self tryLaunchProgressTimer];
    
    if (_finishPlayBlock) {
        _finishPlayBlock(_currentURL);
    }
}

//当发生意外且可能无法恢复的错误时引发(通常最好重新创建STKAudioPlauyer)
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {
    YMLog(@"播放错误:%@",@(errorCode));
    [_refreshTimer invalidate];
    _refreshTimer = nil;
    
    if (_refreshBlock) {
        _refreshBlock(audioPlayer.duration, audioPlayer.progress, (_audioPlayer.state == STKAudioPlayerStateError && _replayUseCountInFail < _replayFailCount) ? STKAudioPlayerStateReady : _audioPlayer.state, errorCode);
    }
    
    if (_replayUseCountInFail < _replayFailCount) {
        [self ym_playWithURL:_currentURL];
        _replayUseCountInFail ++;
    }
}

//可选实现从STKAudioPlayer获取日志信息(内部用于调试)
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer logInfo:(NSString *)line {
    YMLog(@"播放日志:%@",line);
}

//清除队列中的项时引发(通常是因为调用play、setDataSource或stop)
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didCancelQueuedItems:(NSArray *)queuedItems {
    [_refreshTimer invalidate];
    _refreshTimer = nil;
}


@end
