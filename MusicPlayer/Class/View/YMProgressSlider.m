//
//  YMProgressSlider.m
//  MusicPlayer
//
//  Created by Andrew on 2019/9/27.
//  Copyright © 2019 余默. All rights reserved.
//

#import "YMProgressSlider.h"

@implementation YMProgressSlider

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    UIImage *image = [[UIImage imageNamed:@"btn_play_progress"] imageByResizeToSize:CGSizeMake(30, 30)];
    [self setThumbImage:image forState:UIControlStateNormal];
    
    UIImage *imageHeight = [[UIImage imageNamed:@"btn_play_progess_heightlight"] imageByResizeToSize:CGSizeMake(30, 30)];
    [self setThumbImage:imageHeight forState:UIControlStateHighlighted];
}

- (CGRect)trackRectForBounds:(CGRect)bounds{
    return CGRectMake(0, (CGRectGetHeight(self.frame)-self.trackHeight)/2, CGRectGetWidth(self.frame), self.trackHeight);
}

//两边有空隙,修改方法
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    rect.origin.x = rect.origin.x - 4;
    rect.size.width = rect.size.width + 8;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 5 , 5);
}

@end

@implementation UIImage (DFImage)

- (UIImage *)imageByResizeToSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
