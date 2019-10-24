//
//  LJJLrcView.m
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/6.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "LJJLrcView.h"
#import <Masonry.h>
#import "LJJLrcCell.h"
#import "LJJLrcTool.h"
#import "LJJLrcLine.h"
#import "LJJLrcLabel.h"
#import "LJJMusic.h"
#import "LJJMusicTool.h"
#import <MediaPlayer/MediaPlayer.h>

@interface LJJLrcView () <UITableViewDataSource>

/* TableView */
@property (nonatomic, weak) UITableView *tableView;

/* 歌词 */
@property (nonatomic, strong) NSArray *lrcList;

/* 记录当前刷新的某行的下标 */
@property (nonatomic, assign) NSInteger currentIndex;




@end

@implementation LJJLrcView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //初始化TableView
        [self setupTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //初始化TableView
        [self setupTableView];
    }
    return self;
}

#pragma mark - 初始化TableView
- (void)setupTableView
{
    //1.初始化
    UITableView *tableView = [[UITableView alloc] init];
    [self addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //2.添加约束
    [self.tableView setContentOffset:CGPointMake(0, - self.tableView.bounds.size.height * 0.5) animated:NO];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(self.mas_height);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left).offset(self.bounds.size.width);
        make.width.equalTo(self.mas_width);
    }];
    
    //2.改变tableView属性
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 40;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.bounds.size.height * 0.5, 0, self.tableView.bounds.size.height * 0.5, 0);
}

#pragma mark - TableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    LJJLrcCell *cell = [LJJLrcCell lrcCellWithTableView:tableView];
    
    if (self.currentIndex == indexPath.row) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:20];
    } else {
        cell.lrcLabel.font = [UIFont systemFontOfSize:14];
        cell.lrcLabel.progress = 0;
    }
    
    //1.获取数据模型
    LJJLrcLine *lrcLine = self.lrcList[indexPath.row];
    
    cell.lrcLabel.text = lrcLine.text;
    
    return cell;
}

#pragma mark - 重写lrcName
- (void)setLrcName:(NSString *)lrcName
{
    
    //-1 让tableview滚动中间
    [self.tableView setContentOffset:CGPointMake(0, - self.tableView.bounds.size.height * 0.5) animated:NO];
    
    //0.将currentIndex设置为0
    self.currentIndex = 0; //在主界面一首歌快结束时，点击下一首，重复这个操作多次会报错 “[UITableView _endCellAnimationsWithContext:]” 这个里可以解决，因为歌词没有的动画没有执行完，下一首歌的歌词就要展示出来
    
    //1.记录歌词名
    _lrcName = [_lrcName copy];
    
    //2.解析歌词
    self.lrcList = [LJJLrcTool lrcToolWithName:lrcName];
    
    //2.1 设置主界面的第一句歌词
    LJJLrcLine *firstLine = self.lrcList[0];
    self.lrcLabel.text = firstLine.text;
    
    //3.刷新表格
    [self.tableView reloadData];
}

#pragma mark - 重写currentTime  set方法
- (void)setCurrentTime:(NSTimeInterval)currentTime
{

    //1.记录当前播放时间
    _currentTime = currentTime;
    
    //2.判断显示哪句歌词
    NSInteger count = self.lrcList.count;
    for (NSInteger i = 0; i < count; i ++) {
        //2.1 取出当前的歌词
        LJJLrcLine *currentLine = self.lrcList[i];
        
        //2.2 取出下一句歌词
        NSInteger nextIndex = i + 1;
        LJJLrcLine *nextLrcLine = nil;
        if (nextIndex < self.lrcList.count) { //这个判断防止数组越界
            nextLrcLine = self.lrcList[nextIndex];
        }
        
        //2.3 用当前播放器的时间，跟当前这句歌词的时间和下一句歌词进行对比，如果大于等于当前歌词的时间，并且小于下一句歌词的时间，就显示当前的歌词
        if (self.currentIndex != i && currentTime >= currentLine.time && currentTime < nextLrcLine.time) {
            //1.将当前这句歌词滚动到中间
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            
            //2.记录当前刷新的某行
            self.currentIndex = i;//这行代码的顺序会决定当前刷新哪一行
            
            //3.刷新当前这句歌词，并且刷新上一句歌词
            [self.tableView reloadRowsAtIndexPaths:@[indexPath,previousIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            //4.将当前的这句歌词滚动到中间
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
            //5.设置主界面的歌词的文字
            self.lrcLabel.text = currentLine.text;
            
            //6.生成锁屏图片
            [self genaratorLockImage];
            
        }
        
        if (self.currentIndex == i) { //当前这句歌词
            
//            //1.获取当前歌词
//            LJJLrcLine *currentLine = self.lrcList[self.currentIndex];
//            
//            //2.取出下一句歌词
//            NSInteger nexIndex = self.currentIndex + 1;
//            LJJLrcLine *nextLrcLine = nil;
//            if (nexIndex < self.lrcList.count) {
//                nextLrcLine = self.lrcList[nexIndex];
//            }
            
            //3.取出当前歌词的时间，“当前播放器的时间 - 当前歌词的时间 / (下一句歌词的时间 - 当前歌词的时间)”
            CGFloat value = (currentTime - currentLine.time) / (nextLrcLine.time - currentLine.time);
            
            //4.设置当前歌词播放的进度
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            LJJLrcCell *lrcCell = [self.tableView cellForRowAtIndexPath:indexPath];
            lrcCell.lrcLabel.progress = value;
            self.lrcLabel.progress = value;
        }
        
    }
}

#pragma mark - 生成锁屏图片
- (void)genaratorLockImage
{
    //1.获取当前音乐的图片
    LJJMusic *playingMusic = [LJJMusicTool playingMusic];
    UIImage *currentImage = [UIImage imageNamed:playingMusic.icon];
    
    //2.取出歌词
    //2.1 取出当前的歌词
    LJJLrcLine *currentLrcLine = self.lrcList[self.currentIndex];
    
    //2.2 取出上一句歌词
    NSInteger preiousIndex = self.currentIndex - 1;
    LJJLrcLine *previousLrcLine = nil;
    if (preiousIndex >= 0) {
        previousLrcLine = self.lrcList[preiousIndex];
    }
    
    //2.3 取出下一句歌词
    NSInteger nextIndex = self.currentIndex + 1;
    LJJLrcLine *nextLrcLine = nil;
    if (nextIndex < self.lrcList.count) {
        nextLrcLine = self.lrcList[nextIndex];
    }
    
    //3.生成水印图片
    //3.1 获取上下文
    UIGraphicsBeginImageContext(currentImage.size);
    
    //3.2 将图片画上去
    [currentImage drawInRect:CGRectMake(0, 0, currentImage.size.width, currentImage.size.height)];
    
    //3.3 将文字画上去
    CGFloat titleH = 25;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes1 = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                  NSForegroundColorAttributeName : [UIColor lightGrayColor],
                                  NSParagraphStyleAttributeName : paragraphStyle
                                  };
    [previousLrcLine.text drawInRect:CGRectMake(0, currentImage.size.height - titleH * 3, currentImage.size.width, titleH) withAttributes:attributes1];
    [nextLrcLine.text drawInRect:CGRectMake(0, currentImage.size.height - titleH, currentImage.size.width, titleH) withAttributes:attributes1];
    
    NSDictionary *attributes2 = @{NSFontAttributeName : [UIFont systemFontOfSize:20],
                                  NSForegroundColorAttributeName : [UIColor greenColor],
                                  NSParagraphStyleAttributeName : paragraphStyle
                                  };
    [currentLrcLine.text drawInRect:CGRectMake(0, currentImage.size.height - titleH * 2, currentImage.size.width, titleH) withAttributes:attributes2];
    
    //3.4 获取画好的图片
    UIImage *lockImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //3.5关闭上下文
    UIGraphicsEndImageContext();
    
    //3.6 设置锁屏界面的图片
    [self setupLockScreenInfoWithLockImage:lockImage];
    
}

#pragma mark - 设置锁屏信息
- (void)setupLockScreenInfoWithLockImage:(UIImage *)lockImage
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
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:lockImage];
    [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    //2.4 设置歌曲的总时长
    [playingInfoDict setObject:@(self.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    //2.5设置歌曲当前的播放时间
    [playingInfoDict setObject:@(self.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    playinginfoCenter.nowPlayingInfo = playingInfoDict;
    
    //3.开启远程交互
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

@end
