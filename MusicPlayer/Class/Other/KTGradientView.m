//
//  KTGradientView.m
//  KTGradientView
//
//  Created by tujinqiu on 15/12/16.
//  Copyright © 2015年 tujinqiu. All rights reserved.
//

#import "KTGradientView.h"

@implementation KTGradientView

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (instancetype)initWithColor:(UIColor *)color direction:(KTGradientDirection)direction
{
    return [self initWithFromColor:color toColor:[UIColor whiteColor] direction:direction];
}

- (instancetype)initWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor direction:(KTGradientDirection)direction
{
    if (self = [super init])
    {
        CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
        gradientLayer.colors = @[(__bridge id)[fromColor CGColor], (__bridge id)[toColor CGColor]];
        gradientLayer.locations = @[@0.0, @1.0];
        switch (direction)
        {
            case KTGradientDirectionToTop:
                gradientLayer.startPoint = CGPointMake(0.0, 1.0);
                gradientLayer.endPoint = CGPointMake(0.0, 0.0);
                break;
                
            case KTGradientDirectionToBottom:
                gradientLayer.startPoint = CGPointMake(0.0, 0.0);
                gradientLayer.endPoint = CGPointMake(0.0, 1.0);
                break;
                
            case KTGradientDirectionToLeft:
                gradientLayer.startPoint = CGPointMake(1.0, 0.0);
                gradientLayer.endPoint = CGPointMake(0.0, 0.0);
                break;
                
            case KTGradientDirectionToRight:
                gradientLayer.startPoint = CGPointMake(0.0, 0.0);
                gradientLayer.endPoint = CGPointMake(1.0, 0.0);
                break;
                
            default:
                break;
        }
    }
    
    return self;
}

@end
