//
//  KTGradientView.h
//  KTGradientView
//
//  Created by tujinqiu on 15/12/16.
//  Copyright © 2015年 tujinqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KTGradientDirection)
{
    KTGradientDirectionToTop = 1,
    KTGradientDirectionToLeft,
    KTGradientDirectionToBottom,
    KTGradientDirectionToRight
};

@interface KTGradientView : UIView

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithColor:(UIColor *)color direction:(KTGradientDirection)direction;
- (instancetype)initWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor direction:(KTGradientDirection)direction;

@end
