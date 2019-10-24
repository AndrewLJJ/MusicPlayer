//
//  LJJPlayingViewController.m
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/4.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "LJJPlayingViewController.h"
#import <Masonry.h>
#import "LJJMusicTool.h"
#import "LJJMusic.h"
#import "LJAudionSoundTool.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+LJJTimeExtension.h"
#import "CALayer+LJJPauseAimate.h"
#import "LJJLrcView.h"
#import "LJJLrcLabel.h"
#import <MediaPlayer/MediaPlayer.h>

#define MPColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface LJJPlayingViewController () <UITableViewDelegate>

/** 歌手的背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
/** 进度条 */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/** 歌手图片 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/** 歌曲名 */
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
/** 歌手 */
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
/** 当前播放的时间 */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
/** 音乐总时长 */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

/* 进度条时间 */
@property (nonatomic, strong) NSTimer *progressTimer;

/* 播放器 */
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;
/** 播放按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;

/** 歌词View */
@property (weak, nonatomic) IBOutlet LJJLrcView *lrcView;
/** 歌词 */
@property (weak, nonatomic) IBOutlet LJJLrcLabel *lrcLabel;

/* 歌词的定时器 */
@property (nonatomic, strong) CADisplayLink *lrcTimer;


@end

@implementation LJJPlayingViewController

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.添加毛玻璃效果
    [self setupBlur];
    
    //2.改变滑块的图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    
    //5.将LJJLrcView中的lrclabe设置为主控制器的lrcLabel
    //这里应该在播放音乐之前就展示歌词
    self.lrcView.lrcLabel = self.lrcLabel;
    
    //3.开始播放音乐
    [self startPlayingMusic];
    
    //4.设置歌词view contensize
    self.lrcView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    
    //6.接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addIconViewAnimate) name:@"LJJIconViewNotification" object:nil];
    
}

#pragma mark - 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 布局子控件
/**
 viewWillLayoutSubviews 调用完之后才会调用 viewDidAppear
 如果用用SB创建控制器，这个方法会调用两次，第一次是SB的宽度，第二次才是屏幕的宽高
 */
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //3.添加圆角
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = MPColor(36, 36, 36, 1).CGColor;
    self.iconView.layer.borderWidth = 8;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /*
     * 如果这几行代码放在这个方法里，歌手的图片从正方形渐变成圆开的一个动画（时间很快，几乎看不到）
    //3.添加圆角
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = MPColor(36, 36, 36, 1).CGColor;
    self.iconView.layer.borderWidth = 8;
     */
}

#pragma mark - 开始播放音乐
- (void)startPlayingMusic
{
    //0.清除之前的歌词
    self.lrcLabel.text = nil;
    
    //1.获取当前正在播放的音乐
    LJJMusic *playingMusic = [LJJMusicTool playingMusic];
    
    //2.设置界面信息
    self.albumImage.image = [UIImage imageNamed:playingMusic.icon];
    self.iconView.image = [UIImage imageNamed:playingMusic.icon];
    self.songLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;
    
    //3.播放音乐
    AVAudioPlayer *currentPlayer = [LJAudionSoundTool LJ_StartMusicWithFileName:playingMusic.filename];
    self.currentTimeLabel.text = [NSString stringWithTime:currentPlayer.currentTime];
    self.totalTimeLabel.text = [NSString stringWithTime:currentPlayer.duration];
    self.currentPlayer = currentPlayer;
    //3.1设置播放按钮
    self.playOrPauseButton.selected = self.currentPlayer.isPlaying;
    
    //3.1 设置歌词
    self.lrcView.lrcName = playingMusic.lrcname;
    self.lrcView.duration = currentPlayer.duration;//获取当歌曲的时长
    
    //4.开启定时器
    [self removeProgressTimer];//点击下一首时，移除原来的定时器
    [self addProgressTimer];
    
    //4.1添加歌词的定时器
    [self removeLicTimer];
    [self addLrcTimer];
    
    //5.添加iconView的动画
    [self addIconViewAnimate];
    
}

#pragma mark - 添加iconView的转圈的动画
- (void)addIconViewAnimate
{
    CABasicAnimation *rotateAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimate.fromValue = @(0);
    rotateAnimate.toValue = @(M_PI * 2);
    rotateAnimate.repeatCount = NSIntegerMax;//旋转无数次
    rotateAnimate.duration = 35;//旋转一圈的需要的时间
    /** 将动画添加到图层 */
    [self.iconView.layer addAnimation:rotateAnimate forKey:nil];
 
    //更新动画是否进入后台
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"iconViewAnimate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

/* 这个封装成一个类方法
- (NSString *)stringWithTime:(NSTimeInterval)time
{
    NSInteger min = time / 60;
 
     //(int)time % 60
     
     //因为定时器是一秒后执行，开始播放的时候，进度条已经开始滑动，但时间还没有跳动
     
     //round(time)
 
    NSInteger sec = (int)round(time) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}

*/

#pragma mark - 添加毛玻璃效果
- (void)setupBlur
{
    //1.初始化toolBar
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [self.albumImage addSubview:toolBar];
    toolBar.barStyle = UIBarStyleBlack;
    
    //2.添加约束
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.albumImage);
    }];
}

#pragma mark - 对进度条时间的处理
- (void)addProgressTimer
{
    [self updateProgressInfo];//因为定时器是一秒后执行，开始的进候这个进度条在中间，所以要更新这个时间
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    //如果点击下一首时，让进度条失效
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

#pragma mark - 更新进度条
- (void)updateProgressInfo
{
    //1.更新播放时间
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    
    //2.更新滑动条
    self.progressSlider.value = self.currentPlayer.currentTime / self.currentPlayer.duration;
}

#pragma mark - 进度条事件处理
- (IBAction)start { //touch down
    
    //移除定时器
    [self removeProgressTimer];
}

- (IBAction)end { //touch up inside
    
    //1.更新播放时间
    self.currentPlayer.currentTime = self.progressSlider.value * self.currentPlayer.duration;
    
    //2.添加定时器
    [self addProgressTimer];
}

- (IBAction)progressValueChange { //value change
    
    self.currentTimeLabel.text = [NSString stringWithTime:self.progressSlider.value * self.currentPlayer.duration];
}

- (IBAction)silderClick:(UITapGestureRecognizer *)sender {
    //1.获取点击到的点
    CGPoint point = [sender locationInView:sender.view];
    
    //2.获取点击的比例
    CGFloat ratio = point.x / self.progressSlider.bounds.size.width;
    
    //3.更新播放时间
    self.currentPlayer.currentTime = self.currentPlayer.duration * ratio;
    
    //4.更新时间和滑块的位置
    [self updateProgressInfo];
}

#pragma mark - 播放，下一首，上一首点击处理
- (IBAction)playOrPause {
    self.playOrPauseButton.selected = !self.playOrPauseButton.selected;
    if (self.currentPlayer.playing) {
        //1.暂停播放
        [self.currentPlayer pause];
        
        //2.移除定时器
        [self removeProgressTimer];
        
        //3.暂停旋转动画
        [self.iconView.layer pauseAnimate];
        
    } else {
        //1.开始播放
        [self.currentPlayer play];
        
        //2.添加定时器
        [self addProgressTimer];
        
        //3.恢复动画
        [self.iconView.layer resumeAnimate];
    }
}

- (IBAction)next {
    //1.取出下一首歌曲
    LJJMusic *nextMusic = [LJJMusicTool nextMusic];
    
    //2.播放下一首音乐
    [self playMusicWithMusic:nextMusic];

}

- (IBAction)previous {
    
    //1.取出上一首歌曲
    LJJMusic *previousMusic = [LJJMusicTool previousMusic];
    
    //2.播放上一首音乐
    [self playMusicWithMusic:previousMusic];
}

- (void)playMusicWithMusic:(LJJMusic *)music
{
    //1.获取当前播放的歌曲并停止
    LJJMusic *currentMusic = [LJJMusicTool playingMusic];
    [LJAudionSoundTool LJ_StopMusicWithFileName:currentMusic.filename];
    
    //2.设置默认播放的歌曲
    [LJJMusicTool setupPlayingMusic:music];
    
    //3.播放音乐,并更新界面信息
    [self startPlayingMusic];
}

#pragma mark - UIScrollView颜色
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //1.获取滑动的偏移量
    CGPoint point = scrollView.contentOffset;
    
    //2.获取滑动比例
    CGFloat alpha = 1 - point.x / scrollView.bounds.size.width;
    
    //3.设置alpha(如果是第一页的时候为0，透明)
    self.iconView.alpha = alpha;
    self.lrcLabel.alpha = alpha;
}

#pragma mark - 改变状态栏的文字颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 歌词定时器的处理
- (void)addLrcTimer
{
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcInfo)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLicTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

#pragma mark - 更新歌词进度
- (void)updateLrcInfo
{
    self.lrcView.currentTime = self.currentPlayer.currentTime;
}

/*
#pragma mark - 设置锁屏信息
- (void)setupLockScreenInfo
{
    // MPMediaItemPropertyAlbumTitle
    // MPMediaItemPropertyAlbumTrackCount
    // MPMediaItemPropertyAlbumTrackNumber
    // MPMediaItemPropertyArtist
    // MPMediaItemPropertyArtwork
    // MPMediaItemPropertyComposer
    // MPMediaItemPropertyDiscCount
    // MPMediaItemPropertyDiscNumber
    // MPMediaItemPropertyGenre
    // MPMediaItemPropertyPersistentID
    // MPMediaItemPropertyPlaybackDuration
    // MPMediaItemPropertyTitle
    
    //0.获取当前播放的歌曲
    LJJMusic *playingMusic = [LJJMusicTool playingMusic];
    
    //1.获取锁屏中心
    
    
    MPNowPlayingInfoCenter *playinginfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    //2.设置锁屏的参数
    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
    //2.1 设置歌曲名
    [playingInfoDict setObject:playingMusic.name forKey:MPMediaItemPropertyAlbumTitle];
    //2.2 设置歌手名
    [playingInfoDict setObject:playingMusic.singer forKey:MPMediaItemPropertyArtist];
    //2.3 设置封面的图片
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:playingMusic.icon]];
    [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    //2.4 设置歌曲的总时长
    [playingInfoDict setObject:@(self.currentPlayer.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    
    playinginfoCenter.nowPlayingInfo = playingInfoDict;
    
    //3.开启远程交互
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}
 */

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    /**
     UIEventSubtypeRemoteControlPlay                 = 100,
     UIEventSubtypeRemoteControlPause                = 101,
     UIEventSubtypeRemoteControlStop                 = 102,
     UIEventSubtypeRemoteControlTogglePlayPause      = 103,
     UIEventSubtypeRemoteControlNextTrack            = 104,
     UIEventSubtypeRemoteControlPreviousTrack        = 105,
     UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
     UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
     UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
     UIEventSubtypeRemoteControlEndSeekingForward    = 109,
     */
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay :
        case UIEventSubtypeRemoteControlPause:
            [self playOrPause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self next];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previous];
            break;
            
        default:
            break;
    }
}

@end
