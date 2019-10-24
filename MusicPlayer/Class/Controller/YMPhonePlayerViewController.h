//
//  YMPhonePlayerViewController.h
//  MusicPlayer
//
//  Created by Andrew on 2019/9/6.
//  Copyright © 2019 余默. All rights reserved.
//

#import "GKNavigationBarViewController.h"
#import "YMModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMPhonePlayerViewController : GKNavigationBarViewController

/** View的高度 */
@property (nonatomic, assign) CGFloat                  viewHeight;
/** 播放的音频model */
@property (nonatomic, assign) NSInteger                index;
/** 音频数组 */
@property (nonatomic, copy) NSArray                    *musicModels;

@end

NS_ASSUME_NONNULL_END
