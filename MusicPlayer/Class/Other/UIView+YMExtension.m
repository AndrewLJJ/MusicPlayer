//
//  UIView+YMExtension.m
//  BLKC
//
//  Created by Mac on 2017/10/9.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "UIView+YMExtension.h"

@implementation UIView (YMExtension)

- (CGSize)ym_size
{
    return self.frame.size;
}

- (void)setYm_size:(CGSize)ym_size
{
    CGRect frame = self.frame;
    frame.size = ym_size;
    self.frame = frame;
}

- (CGFloat)ym_width
{
    return self.frame.size.width;
}

- (void)setYm_width:(CGFloat)ym_width
{
    CGRect frame = self.frame;
    frame.size.width = ym_width;
    self.frame = frame;
}

- (CGFloat)ym_height
{
    return self.frame.size.height;
}

- (void)setYm_height:(CGFloat)ym_height
{
    CGRect frame = self.frame;
    frame.size.height = ym_height;
    self.frame = frame;
}

- (CGFloat)ym_x
{
    return self.frame.origin.x;
}

- (void)setYm_x:(CGFloat)ym_x
{
    CGRect frame = self.frame;
    frame.origin.x = ym_x;
    self.frame = frame;
}

- (CGFloat)ym_y
{
    return self.frame.origin.y;
}

- (void)setYm_y:(CGFloat)ym_y
{
    CGRect frame = self.frame;
    frame.origin.y = ym_y;
    self.frame = frame;
}

- (CGFloat)ym_centerX
{
    return self.center.x;
}

- (void)setYm_centerX:(CGFloat)ym_centerX
{
    CGPoint center = self.center;
    center.x = ym_centerX;
    self.center = center;
}

- (CGFloat)ym_centerY
{
    return self.center.y;
}

- (void)setYm_centerY:(CGFloat)ym_centerY
{
    CGPoint center = self.center;
    center.y = ym_centerY;
    self.center = center;
}

- (CGFloat)ym_right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setYm_right:(CGFloat)ym_right
{
    self.ym_x = ym_right - self.ym_width;
}

- (CGFloat)ym_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setYm_bottom:(CGFloat)ym_bottom
{
    self.ym_y = ym_bottom - self.ym_height;
}

+ (instancetype)ym_viewFormXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (BOOL)ym_intersectWithView:(UIView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect selfRect = [self convertRect:self.bounds toView:window];
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    return CGRectIntersectsRect(selfRect, viewRect);
}

@end
