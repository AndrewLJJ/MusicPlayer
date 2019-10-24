//
//  UIView+YMExtension.h
//  BLKC
//
//  Created by Mac on 2017/10/9.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YMExtension)

/* 控件的size */
@property (nonatomic, assign) CGSize ym_size;
/* 控件的宽度 */
@property (nonatomic, assign) CGFloat ym_width;
/* 控件的高度 */
@property (nonatomic, assign) CGFloat ym_height;
/* 控件的x值 */
@property (nonatomic, assign) CGFloat ym_x;
/* 控件的y值 */
@property (nonatomic, assign) CGFloat ym_y;
/* 控件的中心x值 */
@property (nonatomic, assign) CGFloat ym_centerX;
/* 控件的中心Y值 */
@property (nonatomic, assign) CGFloat ym_centerY;
/* 控制件的右边 */
@property (nonatomic, assign) CGFloat ym_right;
/* 控件的底部 */
@property (nonatomic, assign) CGFloat ym_bottom;

/** 加载xib */
+ (instancetype)ym_viewFormXib;

/** 判断是否跟window有重叠 */
- (BOOL)ym_intersectWithView:(UIView *)view;

@end
