//
//  YMMainMusicViewController.h
//  MusicPlayer
//
//  Created by Andrew on 2019/9/6.
//  Copyright © 2019 余默. All rights reserved.
//

#import "GKNavigationBarViewController.h"
#import "YMModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMMainMusicViewController : GKNavigationBarViewController

/** 播放音频model */
@property (nonatomic, strong) YMModel                *musicModel;

@end

NS_ASSUME_NONNULL_END
