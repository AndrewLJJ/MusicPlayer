//
//  YMIconView.m
//  MusicPlayer
//
//  Created by Andrew on 2019/11/4.
//  Copyright © 2019 余默. All rights reserved.
//

#import "YMIconView.h"
#import <SDWebImage.h>

@interface YMIconView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
/** 动画 */
@property (nonatomic, strong) CABasicAnimation *rotateAnimation;

@end

@implementation YMIconView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImage.layer.cornerRadius = 100;
    self.iconImage.layer.masksToBounds = YES;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"text"]];
}

#pragma mark - 添加iconView的转圈的动画
// 开始旋转
-(void)startRotating {
    self.rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    self.rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    // 旋转一周
    self.rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    // 旋转时间20秒
    self.rotateAnimation.duration = 20.0;
    // 重复次数，这里用最大次数
    self.rotateAnimation.repeatCount = MAXFLOAT;
    self.rotateAnimation.removedOnCompletion = NO;
    [self.iconImage.layer addAnimation:self.rotateAnimation forKey:nil];
}

// 停止旋转
- (void)stopRotating {
    CFTimeInterval pausedTime = [self.iconImage.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 保存时间，恢复旋转需要用到
    self.iconImage.layer.speed = 0.0;
    // 停止旋转
    self.iconImage.layer.timeOffset = pausedTime;
}

// 恢复旋转
- (void)resumeRotate {
    
    if (self.iconImage.layer.timeOffset == 0) {
        [self startRotating];
        return;
    }
    // 开始旋转
    CFTimeInterval pausedTime = self.iconImage.layer.timeOffset;
    self.iconImage.layer.speed = 1.0;
    self.iconImage.layer.timeOffset = 0.0;
    self.iconImage.layer.beginTime = 0.0;
    // 恢复时间
    CFTimeInterval timeSincePause = [self.iconImage.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    // 从暂停的时间点开始旋转
    self.iconImage.layer.beginTime = timeSincePause;
}

@end
