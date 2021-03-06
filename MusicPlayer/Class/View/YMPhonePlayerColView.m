//
//  YMPhonePlayerColView.m
//  MusicPlayer
//
//  Created by Andrew on 2019/9/11.
//  Copyright © 2019 余默. All rights reserved.
//

#import "YMPhonePlayerColView.h"
#import "UIView+YMExtension.h"
#import "HarryColor.h"
#import "YMSTKAudioPlayer.h"
#import "YMLocalCacheInfo.h"

@interface YMPhonePlayerColView () {
    NSInteger PlayMode;
}

/** 上一首X值 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnXConstraint;
/** 上一首X值 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastBtnXConstraint;
/** 播放模式 */
@property (weak, nonatomic) IBOutlet UIButton *playModeBtn;
/** 上一首 */
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
/** 播放&&暂停 */
@property (weak, nonatomic) IBOutlet UIButton *playPauseBtn;
/** 下一首 */
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
/** 播放列表 */
@property (weak, nonatomic) IBOutlet UIButton *playListBtn;
/** 当前时间 */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeL;
/** 进度条 */
@property (weak, nonatomic) IBOutlet YMProgressSlider *progressSlider;
/** 总时间 */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeL;
/** 当前已经选中的播放模式 */
@property (nonatomic, assign) YMSTKAudioPlayerPlayMode                  currentPlayMode;

@end

@implementation YMPhonePlayerColView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nextBtnXConstraint.constant = self.lastBtnXConstraint.constant = (SCREEN_WIDTH / 2 - 30 - 32 - 40 - 40) / 2;
    
    [self initView];
    [self reloadPlayMode];
}

//获取播放playMode
- (void)reloadPlayMode {
    PlayMode = [YMLocalCacheInfo getPlayMode];
    self.currentPlayMode = PlayMode;
    switch (PlayMode) {
        case YMSTKAudioPlayerPlayModeCycle: //顺序
        {
            [self.playModeBtn setImage:[UIImage imageNamed:@"btn_play_circle"] forState:UIControlStateNormal];
            PlayMode = 2;
        }
            break;
        case YMSTKAudioPlayerPlayModeSingleCycle: //单曲
        {
            [self.playModeBtn setImage:[UIImage imageNamed:@"btn_play_loop"] forState:UIControlStateNormal];
            PlayMode = 3;
        }
            break;
        case YMSTKAudioPlayerPlayModeShuffleCycle: //随机
        {
            [self.playModeBtn setImage:[UIImage imageNamed:@"btn_play_random"] forState:UIControlStateNormal];
            PlayMode = 1;
        }
            break;
            
        default:
        {
            [self.playModeBtn setImage:[UIImage imageNamed:@"btn_play_circle"] forState:UIControlStateNormal];
            PlayMode = 2;
        }
            break;
    }
}

//播放模式
- (void)setPlayMode:(YMSTKAudioPlayerPlayMode)playMode {
    _playMode = playMode;
}

//当前播放时间
- (void)setCurrentTime:(double)currentTime {
    _currentTime = currentTime;
    self.currentTimeL.text = [self formatTime:currentTime];
}

//音频总时长
- (void)setTotalTime:(double)totalTime {
    _totalTime = totalTime;
    self.totalTimeL.text = [self formatTime:totalTime];
}

//进度条
- (void)setProgressValue:(double)progressValue {
    _progressValue = progressValue;
    self.progressSlider.value = self.currentTime / self.totalTime;
}

- (NSString *)formatTime:(double)time {
    NSInteger seconds = (NSInteger)ceil(time);
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)(seconds/60), (long)(seconds%60)];
}

#pragma mark - initView
- (void)initView {
    self.progressSlider.minimumValue = 0;
    self.progressSlider.maximumValue = 1;
    self.progressSlider.trackHeight = 3;
    self.progressSlider.minimumTrackTintColor = [UIColor whiteColor];
    self.progressSlider.maximumTrackTintColor = [HarryColor colorWith:@"#73BCF7"];
    
    [self.progressSlider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventTouchUpInside];
    //开始滑动
    [self.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    //滑动中
    [self.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //滑动结束
    [self.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    
    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
    [self.progressSlider addGestureRecognizer:sliderTap];
    
    //自动下一首
    WS(ws);
    [[YMSTKAudioPlayer shareInstance] setSTKAudioPlayAutomaticBlock:^{
        [ws nextAudio];
    }];
}

//滑动进度
- (void)changeProgress:(UISlider *)slider {
    WS(ws);
    NSInteger timeCount = slider.value * self.totalTime;
    dispatch_async(dispatch_get_main_queue(), ^{
        ws.currentTimeL.text = [self formatTime:timeCount];
        ws.progressSlider.value = timeCount / ws.totalTime;
        [[YMSTKAudioPlayer shareInstance] ym_seekToTime:timeCount];
        ws.playPauseBtn.selected = YES;
    });
}

//开始滑动
- (void)progressSliderTouchBegan:(UISlider *)sender {
    [[YMSTKAudioPlayer shareInstance] ym_pause];
}

//滑动中
- (void)progressSliderValueChanged:(UISlider *)slider {
    WS(ws);
    NSInteger timeCount = slider.value * self.totalTime;
    dispatch_async(dispatch_get_main_queue(), ^{
        ws.currentTimeL.text = [self formatTime:timeCount];
        ws.progressSlider.value = timeCount / ws.totalTime;
        ws.playPauseBtn.selected = YES;
    });
}

//滑动结束
- (void)progressSliderTouchEnded:(UISlider *)slider {
    WS(ws);
    NSInteger timeCount = slider.value * self.totalTime;
    dispatch_async(dispatch_get_main_queue(), ^{
        ws.currentTimeL.text = [self formatTime:timeCount];
        ws.progressSlider.value = timeCount / ws.totalTime;
        [[YMSTKAudioPlayer shareInstance] ym_seekToTime:timeCount];
        ws.playPauseBtn.selected = YES;
    });
    
    if (slider.value >= 1) {
        [[YMSTKAudioPlayer shareInstance] ym_pause];
        ws.playPauseBtn.selected = NO;
    } else {
        [[YMSTKAudioPlayer shareInstance] ym_resume];
        ws.playPauseBtn.selected = YES;
    }
}

//点击slider
- (void)tapSliderAction:(UIPanGestureRecognizer *)tap {
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point    = [tap locationInView:slider];
        CGFloat length   = slider.frame.size.width;
        CGFloat tapValue = point.x / length;
        self.progressSlider.value = tapValue;
        
        NSInteger timeCount = self.progressSlider.value * self.totalTime;
        [[YMSTKAudioPlayer shareInstance] ym_seekToTime:timeCount];
        [[YMSTKAudioPlayer shareInstance] ym_resume];
        self.playPauseBtn.selected = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.ym_height = 146;
}

/** 播放模式 */
- (IBAction)playModeBtnClick:(UIButton *)sender {
    switch (PlayMode) {
        case YMSTKAudioPlayerPlayModeCycle: //顺序
        {
            [sender setImage:[UIImage imageNamed:@"btn_play_circle"] forState:UIControlStateNormal];
            PlayMode = 2;
            [YMLocalCacheInfo savePlayMode:@"1"];
        }
            break;
        case YMSTKAudioPlayerPlayModeSingleCycle: //单曲
        {
            [sender setImage:[UIImage imageNamed:@"btn_play_loop"] forState:UIControlStateNormal];
            PlayMode = 3;
            [YMLocalCacheInfo savePlayMode:@"2"];
        }
            break;
        case YMSTKAudioPlayerPlayModeShuffleCycle: //随机
        {
            [sender setImage:[UIImage imageNamed:@"btn_play_random"] forState:UIControlStateNormal];
            PlayMode = 1;
            [YMLocalCacheInfo savePlayMode:@"3"];
        }
            break;
            
        default:
        {
            [sender setImage:[UIImage imageNamed:@"btn_play_circle"] forState:UIControlStateNormal];
            PlayMode = 2;
            [YMLocalCacheInfo savePlayMode:@"1"];
        }
            break;
    }
    
    self.currentPlayMode = [YMLocalCacheInfo getPlayMode];
}

/** 上一首 */
- (IBAction)lastBtnClick:(UIButton *)sender {
    YMModel *model = nil;
    switch (self.currentPlayMode) {
        case YMSTKAudioPlayerPlayModeCycle: //顺序
        {
            model = [self previousMusic];
        }
            break;
        case YMSTKAudioPlayerPlayModeSingleCycle: //单曲
        {
            model = [self singeMusic];
        }
            break;
        case YMSTKAudioPlayerPlayModeShuffleCycle: //随机
        {
            model = [self shuffleMusic];
        }
            break;
            
        default:
            break;
    }
    [[YMSTKAudioPlayer shareInstance] ym_playWithURL:[NSURL URLWithString:model.url]];
}

/** 暂停&&播放 */
- (IBAction)playPauseBtnClick:(UIButton *)sender {
    if (sender.selected) { //播放中
        [[YMSTKAudioPlayer shareInstance] ym_pause];
        sender.selected = NO;
    } else { //暂停 || 停止
        [[YMSTKAudioPlayer shareInstance] ym_resume];
        sender.selected = YES;
    }
}

/** 下一首 */
- (IBAction)nextBtnClick:(UIButton *)sender {
    YMModel *model = nil;
    switch (self.currentPlayMode) {
        case YMSTKAudioPlayerPlayModeCycle: //顺序
        {
            model = [self nextMusic];
        }
            break;
        case YMSTKAudioPlayerPlayModeSingleCycle: //单曲
        {
            model = [self singeMusic];
        }
            break;
        case YMSTKAudioPlayerPlayModeShuffleCycle: //随机
        {
            model = [self shuffleMusic];
        }
            break;
            
        default:
            break;
    }
    [[YMSTKAudioPlayer shareInstance] ym_playWithURL:[NSURL URLWithString:model.url]];
}

/** 播放列表 */
- (IBAction)playListBtnClick:(UIButton *)sender {
    
}

//下一首
- (void)nextAudio {
    YMModel *model = nil;
    switch (self.currentPlayMode) {
        case YMSTKAudioPlayerPlayModeCycle: //顺序
        {
            model = [self nextMusic];
        }
            break;
        case YMSTKAudioPlayerPlayModeSingleCycle: //单曲
        {
            model = [self singeMusic];
        }
            break;
        case YMSTKAudioPlayerPlayModeShuffleCycle: //随机
        {
            model = [self shuffleMusic];
        }
            break;
            
        default:
            break;
    }
    [[YMSTKAudioPlayer shareInstance] ym_playWithURL:[NSURL URLWithString:model.url]];
}

/** 开始播放 */
- (void)startPlayingMusic {
    self.playPauseBtn.selected = YES;
}

/** 暂停播放 */
- (void)pausePlayingMusic {
    self.playPauseBtn.selected = NO;
}

/** 返回上一首音乐 */
- (YMModel *)previousMusic {
    //1.获取当前音频的下标值
    NSString *url = [[YMSTKAudioPlayer shareInstance].currentURL absoluteString];
    //获取音频数组中的url
    NSArray *urls = [self.musicModels valueForKey:@"url"];
    //查看是否存在这个url
    NSInteger currentIndex = 0;
    if ([urls containsObject:url]) {
        currentIndex = [urls indexOfObject:url];
    }
    //2.获取上一首音频的下标值
    NSInteger previousIndex = --currentIndex;
    YMModel *previousModel = nil;
    if (previousIndex < 0) {
        previousIndex = self.musicModels.count - 1;
    }
    previousModel = self.musicModels[previousIndex];
    self.currentModel = previousModel;
    return previousModel;
}

/** 返回下一首音乐 */
- (YMModel *)nextMusic {
    //1.获取当前音乐下标值
    NSString *url = [[YMSTKAudioPlayer shareInstance].currentURL absoluteString];
    //获取音频数组中的url
    NSArray *urls = [self.musicModels valueForKey:@"url"];
    //查看是否存在这个url
    NSInteger currentIndex = 0;
    if ([urls containsObject:url]) {
        currentIndex = [urls indexOfObject:url];
    }
    //2.获取上一首音频的下标值
    NSInteger nextIndex = ++currentIndex;
    YMModel *nextModel = nil;
    if (nextIndex >= self.musicModels.count) {
        nextIndex = 0;
    }
    nextModel = self.musicModels[nextIndex];
    self.currentModel = nextModel;
    return nextModel;
}

/** 单曲循环 */
- (YMModel *)singeMusic {
    //1.获取当前音乐下标值
    NSString *url = [[YMSTKAudioPlayer shareInstance].currentURL absoluteString];
    //获取音频数组中的url
    NSArray *urls = [self.musicModels valueForKey:@"url"];
    //查看是否存在这个url
    NSInteger currentIndex = 0;
    if ([urls containsObject:url]) {
        currentIndex = [urls indexOfObject:url];
    }
    YMModel *nextModel = nil;
    if (currentIndex >= self.musicModels.count) {
        currentIndex = 0;
    }
    nextModel = self.musicModels[currentIndex];
    self.currentModel = nextModel;
    return nextModel;
}

/** 随机播放 */
- (YMModel *)shuffleMusic {
    //随机获取数组中的元素的下标
    NSInteger currentIndex = arc4random() % self.musicModels.count;
    YMModel *model = self.musicModels[currentIndex];
    self.currentModel = model;
    return model;
}


@end
