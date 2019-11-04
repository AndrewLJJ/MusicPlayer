//
//  YMIconView.h
//  MusicPlayer
//
//  Created by Andrew on 2019/11/4.
//  Copyright © 2019 余默. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMIconView : UIView

/** 图片url */
@property (nonatomic, copy) NSString                    *imageUrl;

// 开始旋转
-(void)startRotating;
// 停止旋转
- (void)stopRotating;
// 恢复旋转
- (void)resumeRotate;


@end

NS_ASSUME_NONNULL_END
