//
//  YMProgressSlider.h
//  MusicPlayer
//
//  Created by Andrew on 2019/9/27.
//  Copyright © 2019 余默. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMProgressSlider : UISlider

@property (nonatomic, assign) CGFloat trackHeight;

@end

@interface UIImage ()

//裁剪图片
- (UIImage *)imageByResizeToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
